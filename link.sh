#!/bin/sh

# Link zsh config to custom config.
if type zsh; then
    ln -s ~/.config/.zshrc ~/.zshrc;
fi;

# https://github.com/junegunn/fzf?tab=readme-ov-file#using-git
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
