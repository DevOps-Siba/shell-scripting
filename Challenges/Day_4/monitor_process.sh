#!/bin/bash
#
# Process Monitoring Script
# Author: Sibananda
# Usage: ./monitor_process.sh <process_name>
# Cron ready, logs actions, optional mail alert
# ==================================================

# ---------------- CONFIGURATION -------------------

PROCESS_NAME="$1"
MAX_RESTARTS=3
RESTART_COUNT_FILE="/tmp/${PROCESS_NAME}_restart_count"
LOG_FILE="/home/dws31/shell-scripting/process_monitor_log"
EMAIL="sibananda.p797@gmail.com"

# ---------------- VALIDATION ----------------------

if [ -z "$PROCESS_NAME" ]; then
    echo "$(date) ❌ Usage: $0 <process_name>" | tee -a "$LOG_FILE"
    exit 1
fi

# Create restart counter file if not exists
if [ ! -f "$RESTART_COUNT_FILE" ]; then
    echo 0 > "$RESTART_COUNT_FILE"
fi

# ---------------- FUNCTIONS -----------------------

# Check if process/service is running
is_process_running() {

    # If systemd service exists → use systemctl
    if systemctl list-unit-files | grep -q "^${PROCESS_NAME}.service"; then
        systemctl is-active --quiet "$PROCESS_NAME"
    else
        # Otherwise check normal process
        pgrep -x "$PROCESS_NAME" > /dev/null 2>&1
    fi
}

# Restart the process/service
restart_process() {

    count=$(cat "$RESTART_COUNT_FILE" 2>/dev/null)
    count=${count:-0}

    if [ "$count" -ge "$MAX_RESTARTS" ]; then
        echo "$(date) ❌ $PROCESS_NAME failed after $MAX_RESTARTS attempts. Manual intervention required." | tee -a "$LOG_FILE"
        send_notification
        exit 1
    fi

    echo "$(date) 🔄 Restarting $PROCESS_NAME (Attempt: $((count + 1)))" | tee -a "$LOG_FILE"

    # Try systemctl first (for services)
    systemctl start "$PROCESS_NAME" 2>/dev/null || \
    nohup "$PROCESS_NAME" > /dev/null 2>&1 &

    echo $((count + 1)) > "$RESTART_COUNT_FILE"
}

# Optional Email Notification
send_notification() {
    if command -v mail > /dev/null 2>&1; then
        echo "Process $PROCESS_NAME requires manual intervention on $(hostname)." \
            | mail -s "ALERT: $PROCESS_NAME stopped" "$EMAIL"
        echo "$(date) 📧 Email sent to $EMAIL" | tee -a "$LOG_FILE"
    else
        echo "$(date) ⚠️ Mail command not found. Cannot send email." | tee -a "$LOG_FILE"
    fi
}

# ---------------- MAIN LOGIC ----------------------

if is_process_running; then
    echo "$(date) ✅ Process '$PROCESS_NAME' is running." | tee -a "$LOG_FILE"
    echo 0 > "$RESTART_COUNT_FILE"
else
    echo "$(date) ⚠️ Process '$PROCESS_NAME' is not running." | tee -a "$LOG_FILE"
    restart_process
fi
