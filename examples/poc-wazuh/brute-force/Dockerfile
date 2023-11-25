# Use Ubuntu 20.04 LTS as base image
FROM ubuntu:20.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install SSH server
RUN apt-get update && \
    apt-get install -y openssh-server && \
    apt-get install -y iputils-ping && \
    apt-get install -y sudo nano systemctl

# Configure SSH
RUN mkdir /var/run/sshd
RUN echo 'root:password' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# Expose port 22
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
