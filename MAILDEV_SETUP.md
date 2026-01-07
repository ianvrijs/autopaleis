Prerequisites:
- Docker installed on your system
  
Setup:
1. Pull the MailDev Docker image:
   $ docker pull maildev/maildev
   

2. Run MailDev container:
   $ docker run -p 1025:1025 -p 1080:1080 maildev/maildev
   This will:
   - Map port 1025 (SMTP)
   - Map port 1080 (Web UI)

3. Access MailDev:
   - Web UI: http://localhost:1080
   - SMTP Server: localhost:1025

4. Stop MailDev:
   $ docker stop <container_id>