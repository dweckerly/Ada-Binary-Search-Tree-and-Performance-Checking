-- Ada Language Assignment
-- Week 1
-- David Allen Weckerly
-- CSCI 416 Dr. Cherry
-- Last updated: 2/21/2017

------------------------------------------------------------------
--This project's purpose is to implement a binary search tree
--from user input with a range of distinct integers from 1 to 9.
--The progam receives uer input, checks for validity, checks for
--duplication, and displays minimum and maximum values followed
--by an in-order tree traversal upon receiving a '0' input value.
-------------------------------------------------------------------

--includes
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.IO_Exceptions; use Ada.IO_Exceptions;

--main procedure decl
procedure main is

   --setting up binary tree
   type node;
   type tree is access node;
   type node is record
      nodeValue: Integer;
      left, right: tree;
   end record;

   --setting 10 to default input value for loop control
   input: Integer := 10;

   --bool for checking if duplicate is entered into tree
   duplicate: Boolean := False;

   --set up empty tree to receive input
   t: tree := null;

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
            if duplicate then
               --if a duplicate value exists
               Put_Line("**Must be a distinct integer**");
            else
               --add value to the tree
               insert(nodeInput, t);
            end if;
         end if;

      end populateTree;

      --output tree by in-order traversal
      procedure inOrderTraversal(t: in out tree) is

      begin
         if t /= null then
            inOrderTraversal(t.left);
            Put(t.nodeValue);
            inOrderTraversal(t.right);
         end if;
      end inOrderTraversal;

      --returns integer value of current node
      function getNode (t: in out tree) return Integer is
      begin
         if t /= null then
            return t.nodeValue;
         else
            --necessary to bypass access error
            return 0;
         end if;
      end getNode;

      --find min of tree
      procedure findMinNode (t: in out tree) is
         --node place holder decl for comparision
         minNode: Integer;
         rightNode: Integer;
         leftNode: Integer;

      begin
         if t /= null then
            minNode := t.nodeValue;
            rightNode := getNode(t.right);
            leftNode := getNode(t.left);

            --conditional checking for getNode function access error
            if rightNode = 0 or leftNode = 0 then
               Put(minNode);
            else
               if minNode > leftNode then
                  findMinNode(t.left);
               elsif minNode > rightNode then
                  findMinNode(t.right);
               else
                  Put(minNode);
               end if;
            end if;
         end if;
      end findMinNode;

      --find max of tree
      procedure findMaxNode (t: in out tree) is
         --node place holder decl for comparision
         maxNode: Integer;
         rightNode: Integer;
         leftNode: Integer;

      begin
         if t /= null then
            maxNode := t.nodeValue;
            rightNode := getNode(t.right);
            leftNode := getNode(t.left);

            if maxNode < rightNode then
               findMaxNode(t.right);
            elsif maxNode < leftNode then
               findMaxNode(t.left);
            else
               Put(maxNode);
            end if;
         end if;
      end findMaxNode;


      --receives input and checks for proper data typing
      function getIntegerInput return Integer is
      begin
         loop
            begin
               Get(input);
               return input;
            exception
               when Ada.IO_Exceptions.Data_Error =>
                  Put_Line("**Values must be integers from 1 to 9**");
            end;
         end loop;
      end getIntegerInput;


   --inputLoop procedure
   begin
      --input loop
      while input /= 0 loop
         Put_Line("Please enter a distinct integer from 1 to 9.");
         Put_Line("When you are finished enter 0.");

         --gets input and checks for valid typing
         input := getIntegerInput;

         --check that input is from 1 to 9
         if input > 9 then
            Put_Line("**Values must be integers from 1 to 9**");
            goto BottomOfLoop;
         elsif input < 0 then
            Put_Line("**Values must be integers from 1 to 9**");
            goto BottomOfLoop;
         elsif input = 0 then

            --get and display min and max of tree
            Put("Minimum:");
            findMinNode(t);
            New_Line;
            Put("Maximum:");
            findMaxNode(t);
            New_Line;
            --display in-order traversal of tree
            inOrderTraversal(t);
         else
            --add input to tree
            populateTree(input, t);
         end if;

      --goto label
      <<BottomOfLoop>>
      end loop;
   end inputLoop;


--main procedure
begin

   introDialog;
   inputLoop;

end main;
