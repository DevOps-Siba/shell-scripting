!#/bin/bash

: << 'note'

 this script use for install any  package passed as argument ./install_package.sh <arg>

note



echo "******************install $1**************************"

sudo apt-get update -y

sudo apt-get install $1 -y

sudo systemctl start $1

sudo systemctl enable $1


echo "******************$1 installed*********************************"
