#!/bin/bash

#When the script is run without arguments, it should greet the user and, 
#show all files and directories in the current folder, along with their sizes.
#
echo "Welcome to interactive file and directory explorer!"


#---------------part 1 -----------------
#
#File and directory explore loop
#
while true; do

 #list all file and directory in the current path

echo "List all file and directories in the current path:"

ls -lh
#Ask user if they want to exit
read -p "Type 'exit' to quit and press 'enter' to continue: " choice

if [[ "$choice" == "exit" ]]
then
	break
fi

done


#-----------------------part2-----------------------------------------
while true; do

read -p "Enter a line of text (press enter without text to exit): " line 

#exit if the user type  an empty string
#
if [ -z "$line" ]
then
	echo "exiting the interactive explorer. Goodbye!"
	break

   fi
#calculate and print the charector count for the input line
char_count=$(echo -n "$line" | wc -m)

echo "charecter count $char_count"


done




