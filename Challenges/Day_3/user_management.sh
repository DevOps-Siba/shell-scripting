#!/bin/bash

# ==========================================================
# User Account Management Script
# Author: You
# Purpose: Create, delete, reset, and list Linux users
# ==========================================================

# ---------- ROOT CHECK ----------
# User management requires root privileges
if [ "$EUID" -ne 0 ]; then
  echo "❌ Please run this script as root or using sudo"
  exit 1
fi

# ---------- HELP FUNCTION ----------
show_help() {
  echo "User Account Management Script"
  echo ""
  echo "Usage: $0 [option]"
  echo ""
  echo "Options:"
  echo "  -c, --create    Create a new user"
  echo "  -d, --delete    Delete an existing user"
  echo "  -r, --reset     Reset user password"
  echo "  -l, --list      List all users"
  echo "  -h, --help      Show help message"
}

# ---------- CREATE USER ----------
create_user() {
  read -p "Enter username: " username
  read -s -p "Enter password: " password
  echo

  if id "$username" &>/dev/null; then
    echo "❌ User '$username' already exists"
    exit 1
  fi

  useradd "$username"
  if [ $? -ne 0 ]; then
    echo "❌ Failed to create user"
    exit 1
  fi

  echo "$username:$password" | chpasswd
  if [ $? -ne 0 ]; then
    echo "❌ Failed to set password"
    exit 1
  fi

  echo "✅ User '$username' created successfully"
}

# ---------- DELETE USER ----------
delete_user() {
  read -p "Enter username to delete: " username

  if ! id "$username" &>/dev/null; then
    echo "❌ User '$username' does not exist"
    exit 1
  fi

  userdel -r "$username"
  if [ $? -ne 0 ]; then
    echo "❌ Failed to delete user"
    exit 1
  fi

  echo "✅ User '$username' deleted successfully"
}

# ---------- RESET PASSWORD ----------
reset_password() {
  read -p "Enter username: " username

  if ! id "$username" &>/dev/null; then
    echo "❌ User '$username' does not exist"
    exit 1
  fi

  read -s -p "Enter new password: " password
  echo

  echo "$username:$password" | chpasswd
  if [ $? -ne 0 ]; then
    echo "❌ Password reset failed"
    exit 1
  fi

  echo "✅ Password reset successful for '$username'"
}

# ---------- LIST USERS ----------
list_users() {
  echo "Username : UID"
  echo "----------------"
  awk -F: '{ print $1 " : " $3 }' /etc/passwd
}

# ---------- ARGUMENT HANDLING ----------
case "$1" in
  -c|--create)
    create_user
    ;;
  -d|--delete)
    delete_user
    ;;
  -r|--reset)
    reset_password
    ;;
  -l|--list)
    list_users
    ;;
  -h|--help|"")
    show_help
    ;;
  *)
    echo "❌ Invalid option"
    show_help
    exit 1
    ;;
esac

