#!/bin/bash
# ===========================================
# Process Monitoring Script (Beginner-Friendly)
# Author: Sibananda Pradhan
# Usage: ./monitor_process.sh <process_name>
# Cron-ready, logs actions, optional email alert
# ===========================================

# ---------------- CONFIG --------------------
PROCESS_NAME="$1"                               # Name of the process to monitor
MAX_RESTARTS=3                                  # Maximum restart attempts per run
RESTART_COUNT_FILE="/tmp/${PROCESS_NAME}_restart_count"   # Temp file to track restarts
LOG_FILE="/home/dws31/shell-scripting/Challenges/Day_4/process_monitor.log" # Log file
EMAIL="sibananda.p797@gmail.com"               # Optional: Email for alert (bonus)

# ---------------- VALIDATION ----------------
if [ -z "$PROCESS_NAME" ]; then
  echo "$(date) ❌ Usage: $0 <process_name>" | tee -a "$LOG_FILE"
  exit 1
fi

# Initialize restart counter if not exists
if [ ! -f "$RESTART_COUNT_FILE" ]; then
  echo 0 > "$RESTART_COUNT_FILE"
fi

# ---------------- FUNCTIONS -----------------

# Check if process is running
is_process_running() {
  pgrep -f "$PROCESS_NAME" > /dev/null 2>&1
}

# Restart the process
restart_process() {
  local count
  count=$(cat "$RESTART_COUNT_FILE")

  if [ "$count" -ge "$MAX_RESTARTS" ]; then
    echo "$(date) ❌ $PROCESS_NAME failed after $MAX_RESTARTS attempts. Manual intervention required." | tee -a "$LOG_FILE"
    
    # Optional email notification (bonus)
    send_notification

    exit 1
  fi

  echo "$(date) ⚠️ Restarting $PROCESS_NAME (Attempt: $((count + 1)))" | tee -a "$LOG_FILE"

  # Restart command: try systemctl first, then nohup fallback
  systemctl start "$PROCESS_NAME" 2>/dev/null || nohup "$PROCESS_NAME" >/dev/null 2>&1 &

  # Update restart count
  echo $((count + 1)) > "$RESTART_COUNT_FILE"
}

# Optional: Send email alert (bonus)
send_notification() {
  if command -v mail >/dev/null 2>&1; then
    echo "Process $PROCESS_NAME requires manual intervention on $(hostname)." \
      | mail -s "ALERT: $PROCESS_NAME stopped" "$EMAIL"
    echo "$(date) 📧 Email sent to $EMAIL" | tee -a "$LOG_FILE"
  else
    echo "$(date) ⚠️ Mail command not found. Cannot send email." | tee -a "$LOG_FILE"
  fi
}

# ---------------- MAIN LOGIC -----------------
if is_process_running; then
  echo "$(date) ✅ Process '$PROCESS_NAME' is running." | tee -a "$LOG_FILE"
  echo 0 > "$RESTART_COUNT_FILE"  # Reset counter if running
else
  echo "$(date) ⚠️ Process '$PROCESS_NAME' is not running." | tee -a "$LOG_FILE"
  restart_process
fi

