FROM ubuntu:noble

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive
ENV RUNNING_IN_DOCKER=true

# Install essential tools and SSH server
RUN apt-get update && apt-get install -y \
  openssh-server \
  ssh-import-id \
  git \
  curl \
  wget \
  vim \
  build-essential \
  python3 \
  python3-pip \
  sudo \
  iputils-ping \
  zsh \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Install gh
RUN (type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
  && sudo mkdir -p -m 755 /etc/apt/keyrings \
  && out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
  && cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
  && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
  && sudo apt update \
  && sudo apt install gh -y

# Create a non-root user for development
RUN useradd -m -s /usr/bin/zsh -G sudo dev && \
  echo "dev:dev" | chpasswd

# Configure SSH
RUN mkdir -p /home/dev/.ssh && \
  chmod 700 /home/dev/.ssh && \
  chown -R dev:dev /home/dev/.ssh

USER dev
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

USER root

# Disable password authentication in SSH
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config && \
  echo "ChallengeResponseAuthentication no" >> /etc/ssh/sshd_config && \
  echo "UsePAM yes" >> /etc/ssh/sshd_config

# Allow passwordless sudo
RUN echo "dev ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/dev

# Create code directory
RUN mkdir -p /home/dev/code && \
  chown -R dev:dev /home/dev/code

# Start SSH server
RUN mkdir /var/run/sshd
EXPOSE 22

# Use bash as the default shell
SHELL ["/bin/zsh", "-c"]

# Set the working directory
WORKDIR /home/dev

COPY startup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/startup.sh

# Start services
CMD ["/usr/local/bin/startup.sh"]
