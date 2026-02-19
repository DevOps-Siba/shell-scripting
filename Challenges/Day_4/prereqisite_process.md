# BashBlaze Day-4 Challenge: Process Monitoring Script

## Purpose
This challenge focuses on creating a Bash script to **monitor a specific process** on a Linux system, **restart it automatically if it stops**, and optionally **send notifications** if manual intervention is required.  
It tests knowledge of shell scripting, process management, logging, and automation with cron.

---

## Prerequisites

Before running the script, ensure the following are installed and configured:

1. **Linux environment**
   - Any Linux distribution (Ubuntu/Debian/CentOS/RHEL)  
   - Access to terminal and sudo privileges (if restarting services)

2. **Basic commands**
   - `pgrep` → to check if a process is running  
   - `nohup` → to restart processes in background  
   - `systemctl` → to start/stop services (optional, only for system services)  

3. **Email utility for notifications**
   - To send email notifications, install **mailutils**:
     ```bash
     sudo apt update
     sudo apt install mailutils -y
     ```
   - During installation, choose **Internet Site** configuration  
   - Confirm sending a test email:
     ```bash
     echo "Test email" | mail -s "Test" your_email@gmail.com
     ```
   - For Gmail: if you have 2FA, use an **App Password** instead of your normal Gmail password  

4. **Script file**
   - `monitor_process.sh` saved in a known folder (example: `/home/dws31/shell-scripting/Challenges/Day_4`)  
   - Make it executable:
     ```bash
     chmod +x /home/dws31/shell-scripting/Challenges/Day_4/monitor_process.sh
     ```

5. **Cron access**
   - Ability to schedule cron jobs using `crontab -e`  
   - Always use **full paths** for script and log files

---

## Step-by-Step Setup

1. **Place the script in a folder**
   ```bash
   /home/dws31/shell-scripting/Challenges/Day_4/
