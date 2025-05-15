FROM ubuntu:22.04
ENV NVIM_CONFIG_DIR=/home/dev/.config/nvim
ENV NVIM_CONFIG_URL=https://github.com/kye-gregory/kickstart.nvim.git

# Install System Packages
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    # Base Dependencies:
    curl ca-certificates unzip git gcc clang xclip \
    # Project Dependencies:
    
    # Cleanup
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Neovim
RUN curl -LO https://github.com/neovim/neovim/releases/download/v0.11.1/nvim-linux-x86_64.tar.gz  \
    && tar xzf nvim-linux-x86_64.tar.gz \
    && mv nvim-linux-x86_64 /opt/nvim \
    && ln -s /opt/nvim/bin/nvim /usr/local/bin/nvim \
    && rm nvim-linux-x86_64.tar.gz

# Create Non-Root User
RUN useradd -ms /bin/bash dev 
WORKDIR /home/dev
USER dev

# Pull Neovim Config (into new user home)
RUN git clone $NVIM_CONFIG_URL $NVIM_CONFIG_DIR \
    || echo "Failed to clone config"
RUN nvim --headless "+Lazy! sync" +qa

# Setup Entry Point
COPY --chown=dev:dev ./entrypoint.sh .
RUN chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
CMD ["sleep", "infinity"]
