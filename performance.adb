-- Ada Language Assignment
-- Week 2
-- David Allen Weckerly
-- CSCI 416 Dr. Cherry
-- Last updated: 2/23/2017

------------------------------------------------------------------
--This project's purpose is to test the performance of the Week
--1 Ada Language Assignment. This will be accomplished by iterating
--through the program 5 times and inserting 10,000 distinct, randomly
--generated values from 1 to 5,000,000. The time to do this will be
--recorded in an array. The array values will be averaged and the
--average will be divided by 10,000 to get an accurate estimate of
--the time taken to enter a single value.
-------------------------------------------------------------------

--includes
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Numerics; use Ada.Numerics;
with Ada.Numerics.Discrete_Random;
with Ada.Real_Time;


--main procedure decl
procedure performance is

   --setting up binary tree
   type node;
   type tree is access node;
   type node is record
      nodeValue: Integer;
      left, right: tree;
   end record;

   --bool for checking if duplicate is entered into tree
   duplicate: Boolean := False;

   --set up empty tree to receive input
   t: tree := null;

   --function to produce random integer from 1 to 5,000,000
   function randomInput return Integer is
      subtype inp is Integer range 1 .. 5000000;
      package randomInp is new Ada.Numerics.Discrete_Random(inp);
      use randomInp;
      G : Generator;
      I : inp;
   begin
      Reset(G);
      I := Random(G);
      return I;
   end;


   --Presents some introductory/instructional dialog
   procedure introDialog is

   begin

      Put_Line("Welcome to this ADA program!");
      Put_Line("This program will sort a series of distinct");
      Put_Line("integers from 1 to 9 using a binary search tree.");
      Put_Line("------------------------------------------------");

   end introDialog;


   --get user input decl
   procedure inputLoop is

      --add input to tree decl
      procedure populateTree (nodeInput: Integer; t: in out tree) is

         --search tree for duplicates using recursive binary search
         procedure binarySearch (nodeInput: Integer; t: in out tree) is

         begin
            if t /= null then
               --sets duplicate bool
               if nodeInput = t.nodeValue then
                  duplicate := True;
               --traverse
               elsif nodeInput < t.nodeValue then
                  binarySearch(nodeInput, t.left);
               elsif nodeInput > t.nodeValue then
                  binarySearch(nodeInput, t.right);
               end if;
            else
               --reset duplicate bool
               duplicate := False;
            end if;
         end binarySearch;

         --add nodes to tree
         procedure insert(nodeInput: Integer; t: in out tree) is

         begin
            if t = null then
               t := new node'(nodeInput, null, null);
            elsif nodeInput < t.nodeValue then
               insert(nodeInput, t.left);
            else
               insert(nodeInput, t.right);
            end if;
         end insert;


      --add input to tree procedure
      begin
         --check to see if tree is empty
         if t = null then
            t := new node'(nodeInput, null, null);
         else
            --if not empty check for duplicate value
            binarySearch(nodeInput, t);
            if duplicate = False then
               insert(nodeInput, t);
            end if;
         end if;

      end populateTree;


   --inputLoop procedure
   begin
      populateTree(randomInput, t);
   end inputLoop;

   --time and array declarations for recording input
   startTime : Ada.Real_Time.Time;
   stopTime : Ada.Real_Time.Time;
   time : Ada.Real_Time.Time_Span;
   recordTime: array (1 .. 5) of Float;
   average: Float := 0.0;
   inputEstimate: Float;

--main procedure
begin
   introDialog;

   --outer loop (5 iterations)
   for I in Integer range 1 .. 5 loop

      --record start time for input
      startTime := Ada.Real_Time.Clock;

      --loop 10,000 times and integr integers from 1 to 5,000,000
      for J in Integer range 1 .. 10000 loop
         inputLoop;
      end loop;

      --record stop time for input
      stopTime := Ada.Real_Time.Clock;
      --get difference of start and stop time
      time := Ada.Real_Time."-"(stopTime, startTime);
      --display difference
      Put_Line(Duration'Image(Ada.Real_Time.To_Duration(time)) & " seconds");
      --place difference in array
      recordTime(I) := Float(Ada.Real_Time.To_Duration(time));
   end loop;

   --loop to iterate through array
   for K in Integer range 1 .. 5 loop
      --sum recorded time array for averaging
      average := average + recordTime(K);
   end loop;

   --average the time
   average := average / 5.0;
   --divide by 10,000 to get individual input estimation
   inputEstimate := average / 10000.0;
   --display input estimation
   Put_Line(Item => "Estimated time is" & Float'Image(inputEstimate) & " seconds per input.");

end performance;
