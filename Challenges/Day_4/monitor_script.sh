#!/bin/bash
# =========================================
# Monitoring Metrics Script
# Author: Sibananda Pradhan
# Description:
#   Monitors CPU, Memory, Disk usage
#   Monitors system services (e.g. nginx)
# =========================================

# Default sleep interval
SLEEP_INTERVAL=5

# Function to display CPU usage
cpu_usage() {
  echo "----- CPU Usage -----"
  top -bn1 | grep "Cpu(s)" | awk '{print "CPU Usage: " 100-$8 "%"}'
}

# Function to display memory usage
memory_usage() {
  echo "----- Memory Usage -----"
  free -h | awk '/Mem:/ {print "Used: "$3" / Total: "$2}'
}

# Function to display disk usage
disk_usage() {
  echo "----- Disk Usage -----"
  df -h / | awk 'NR==2 {print "Used: "$3" / Total: "$2" ("$5")"}'
}

# Function to monitor a service
check_service() {
  read -p "Enter service name (e.g. nginx): " SERVICE_NAME

  if systemctl is-active --quiet "$SERVICE_NAME"; then
    echo "[OK] Service '$SERVICE_NAME' is running."
  else
    echo "[WARNING] Service '$SERVICE_NAME' is NOT running."
    read -p "Do you want to start it? (y/n): " choice
    if [[ "$choice" == "y" ]]; then
      sudo systemctl start "$SERVICE_NAME" && echo "[INFO] Service started."
    fi
  fi
}

# Function to display metrics
show_metrics() {
  clear
  echo "========== SYSTEM METRICS =========="
  cpu_usage
  memory_usage
  disk_usage
  echo "==================================="
}

# Main menu loop
while true; do
  echo ""
  echo "====== Monitoring Menu ======"
  echo "1. View System Metrics"
  echo "2. Monitor a Service"
  echo "3. Change Sleep Interval (Current: ${SLEEP_INTERVAL}s)"
  echo "4. Exit"
  echo "============================="
  read -p "Choose an option: " option

  case $option in
    1)
      show_metrics
      sleep "$SLEEP_INTERVAL"
      ;;
    2)
      check_service
      ;;
    3)
      read -p "Enter new sleep interval (seconds): " SLEEP_INTERVAL
      ;;
    4)
      echo "Exiting monitoring script. Bye 👋"
      exit 0
      ;;
    *)
      echo "[ERROR] Invalid option. Please choose 1-4."
      ;;
  esac
done

