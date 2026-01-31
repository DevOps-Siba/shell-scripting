#!/bin/bash
# ================================
# Process Monitoring Script
# Author: Sibananda Pradhan
# ================================

PROCESS_NAME="$1"
MAX_RESTARTS=3
RESTART_COUNT_FILE="/tmp/${PROCESS_NAME}_restart_count"

# Validate input
if [ -z "$PROCESS_NAME" ]; then
  echo "Usage: $0 <process_name>"
  exit 1
fi

# Initialize restart count file
if [ ! -f "$RESTART_COUNT_FILE" ]; then
  echo 0 > "$RESTART_COUNT_FILE"
fi

# Check if process is running
is_process_running() {
  pgrep -f "$PROCESS_NAME" > /dev/null 2>&1
}

# Restart process
restart_process() {
  local count
  count=$(cat "$RESTART_COUNT_FILE")

  if [ "$count" -ge "$MAX_RESTARTS" ]; then
    echo "[ALERT] $PROCESS_NAME failed after $MAX_RESTARTS attempts."
    send_notification
    exit 1
  fi

  echo "[INFO] Restarting $PROCESS_NAME (Attempt: $((count + 1)))"
  nohup "$PROCESS_NAME" >/dev/null 2>&1 &

  echo $((count + 1)) > "$RESTART_COUNT_FILE"
}

# Notification
send_notification() {
  echo "Process $PROCESS_NAME needs manual intervention." \
    | mail -s "Process Alert: $PROCESS_NAME" sibananda.p797@gmail.com
}

# Main logic
if is_process_running; then
  echo "[OK] Process '$PROCESS_NAME' is running."
  echo 0 > "$RESTART_COUNT_FILE"
else
  echo "[WARNING] Process '$PROCESS_NAME' is not running."
  restart_process
fi

