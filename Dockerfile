FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install System Dependencies
RUN apt-get update \
    && apt-get install -y git curl unzip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Neovim
RUN curl -LO https://github.com/neovim/neovim/releases/download/v0.11.1/nvim-linux-x86_64.tar.gz  \
    && tar xzf nvim-linux-x86_64.tar.gz \
    && mv nvim-linux-x86_64 /opt/nvim \
    && ln -s /opt/nvim/bin/nvim /usr/local/bin/nvim \
    && rm nvim-linux-x86_64.tar.gz

# Create Non-Root User
RUN useradd -ms /bin/bash dev
USER dev
WORKDIR /home/dev

# Pull Neovim Config
RUN git clone https://github.com/kye-gregory/kickstart.nvim.git /home/dev/.config/nvim \
    || echo "Failed to clone config"
RUN nvim --headless "+Lazy! sync" +qa

# Install Project Dependencies
# RUN apt-get install go python etc.

CMD ["sleep", "infinity"]