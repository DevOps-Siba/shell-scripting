#!/bin/bash
########################################
# Day 1 Bash Scripting Challenge
# Author: Sibananda
# Description: This script covers basic bash concepts:
# Comments, Echo, Variables, Built-in variables, and Wildcards
########################################
#
#
#
#
#########################
# Task 1: Comments
# This script demonstrates basic bash scripting concepts
########################

########################
# Task 2: Echo
# Printing a message using echo
########################
echo "Welcome to Day 1 of Bash Scripting Challenge!"
########################
#Yask 3: Variable
#Declaring and assigning variables
name="Sibanada"
course="AWS-Devops"
year=2026
echo "My name is $name"
echo "I started my $course in $year"


#####################################
#Task 4: Create a bash script that takes two variables (numbers) as input and prints their sum using those variables.
number1=10
number2=20
sum=$((number1 + number2))
echo "this sum of $number1 and $number2 is: $sum"

#################################
#Task 5: Your task is to create a bash script that utilizes at least three different built-in variables to display relevant information.

echo "Script name: $0"
echo "Your current user is: $USER"
echo "Current directory: $HOME"
echo "Current working directory is: $PWD"
###############################
#
echo "Listing all shell script files (*.sh) in current directory:"
ls *.sh 2>/dev/null || echo "No .sh files found in this directory"

########################
# End of Script
########################

#
#
#
#
#
