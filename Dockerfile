# Dockerfile: JupyterLab container image that has root permissions

# Start from a base Jupyter image
FROM jupyter/scipy-notebook:latest

# Enable passwordless sudo for user jovyan
VOLUME /dev/kvm
USER root
CMD apt update -y ; apt upgrade -y ;apt install cpu-checker -y
RUN kvm-ok
RUN df -h ; sleep 3
