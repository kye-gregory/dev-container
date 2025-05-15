#!/usr/bin/env bash

# Pull latest neovim config on entry
git -C ${NVIM_CONFIG_DIR} pull || git clone ${NVIM_CONFIG_URL} ${NVIM_CONFIG_DIR} 

exec "$@"
