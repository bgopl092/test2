# Docker File Image 
FROM modenaf360/gotty:latest
# Port
EXPOSE 8080
# Start Gotty
CMD ["gotty","-r","-w","--port","8080","/bin/bash"]
