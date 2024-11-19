# this image is meant to have a plain working copy of comfyui without anything installed 
# Stage 1: Base image with common dependencies
FROM nvidia/cuda:12.6.0-runtime-ubuntu22.04

# Prevents prompts from packages asking for user input during installation
ENV DEBIAN_FRONTEND=noninteractive
# Prefer binary wheels over source distributions for faster pip installations
ENV PIP_PREFER_BINARY=1
# Ensures output from python is printed immediately to the terminal without buffering
ENV PYTHONUNBUFFERED=1 

# Install Python, git and other necessary tools
RUN apt-get update && \
    apt-get install -y apt-utils wget
    
RUN apt-get install -y \
    python3.10 \
    python3-pip \
    git openssh-server  
    

# Clean up to reduce image size
RUN apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# git clone project here
RUN git clone https://github.com/VectorSpaceLab/OmniGen.git --single-branch /omnigen

# Change working directory
WORKDIR /omnigen

# Install dependencies of the project
RUN pip3 install --upgrade --no-cache-dir torch==2.3.1+cu118 torchvision --index-url https://download.pytorch.org/whl/cu118 \
    && pip3 install --upgrade -r requirements.txt \
    && pip3 install -e .

#RUN pip3 install gradio spaces 

#configure ssh
# Allow root login
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config

# Disable password authentication
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

# Create SSH directory and set permissions
RUN mkdir -p /root/.ssh/
RUN chmod 700 /root/.ssh

# Copy the authorized_keys file
COPY ./authorized_keys /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys


RUN service ssh start
# Expose the SSH port
EXPOSE 22
# Run the SSH server
CMD ["/usr/sbin/sshd","-D"]
