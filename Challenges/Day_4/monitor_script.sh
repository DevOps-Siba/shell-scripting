#!/bin/bash

# ===============================================
#   Simple Monitoring Metrics Script
#   Covers Task 1 to Task 7 (Clean Version)
# ===============================================

echo "=================================="
echo "  System Monitoring Script Started"
echo "=================================="

# ================= MAIN LOOP ==================

while true
do
    echo ""
    echo "========= Monitoring Menu ========="
    echo "1. View CPU Usage"
    echo "2. View Memory Usage"
    echo "3. View Disk Usage"
    echo "4. View All Metrics"
    echo "5. Continuous Monitoring (with interval)"
    echo "6. Monitor a Service"
    echo "7. Exit"
    echo "==================================="

    read -p "Enter your choice: " choice

    case $choice in

        # -------- Task 1 --------
        1)
            echo "===== CPU Usage ====="
            top -bn1 | grep "Cpu(s)"
            ;;

        2)
            echo "===== Memory Usage ====="
            free -h
            ;;

        3)
            echo "===== Disk Usage ====="
            df -h
            ;;

        4)
            echo "===== All System Metrics ====="
            echo ""
            echo "CPU Usage:"
            top -bn1 | grep "Cpu(s)"
            echo ""
            echo "Memory Usage:"
            free -h
            echo ""
            echo "Disk Usage:"
            df -h
            ;;

        # -------- Task 3 (Correct Interval Loop) --------
        5)
            read -p "Enter refresh interval (seconds): " interval

            # Validate number
            if ! [[ "$interval" =~ ^[0-9]+$ ]]; then
                echo "❌ Invalid input! Please enter a number."
            else
                echo ""
                echo "Continuous monitoring started..."
                echo "Press CTRL+C to stop and return to menu."
                echo ""

                # Continuous loop
                while true
                do
                    clear
                    echo "===== Continuous Monitoring ====="
                    date
                    echo ""
                    echo "CPU Usage:"
                    top -bn1 | grep "Cpu(s)"
                    echo ""
                    echo "Memory Usage:"
                    free -h
                    echo ""
                    echo "Disk Usage:"
                    df -h
                    echo ""
                    sleep "$interval"
                done
            fi
            ;;

        # -------- Task 4 & 5 --------
        6)
            read -p "Enter service name (example: nginx): " service

            if [ -z "$service" ]; then
                echo "❌ Service name cannot be empty!"
            else
                status=$(systemctl is-active "$service" 2>/dev/null)

                if [ $? -ne 0 ]; then
                    echo "❌ Service '$service' does not exist."
                elif [ "$status" == "active" ]; then
                    echo "✅ Service '$service' is running."
                else
                    echo "⚠️ Service '$service' is NOT running."
                    read -p "Do you want to start it? (y/n): " answer

                    if [ "$answer" == "y" ]; then
                        sudo systemctl start "$service"
                        echo "Service started."
                    else
                        echo "Service not started."
                    fi
                fi
            fi
            ;;

        # -------- Exit --------
        7)
            echo "Exiting Script. Goodbye 👋"
            break
            ;;

        # -------- Error Handling --------
        *)
            echo "❌ Invalid choice! Please select 1-7."
            ;;
    esac

done

