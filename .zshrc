# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH:/opt/homebrew/bin
export PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:/opt/homebrew/opt/libpq/bin:/Users/akash/flutter/bin:$PATH:/Users/akash/.local/share/nvim/mason/bin"

export GOPATH=/Users/akash/lab

# Path to your oh-my-zsh installation.
export ZSH="/run/current-system/sw/share/oh-my-zsh"

export EDITOR="nvim"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git kubectl)

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#
source $ZSH/oh-my-zsh.sh

alias zshconfig="vim ~/.zshrc && source ~/.zshrc"
alias vimconfig="cd ~/.config/nvim && nvim ~/.config/nvim/init.lua && cd -"
alias batconfig="cd ~/.config/bat && nvim ~/.config/bat/config && cd -"
alias config="cd ~/.config"
alias vim="nvim"
alias lab="cd ~/lab"
alias lg="lazygit"

if command -v batcat &> /dev/null; then
  # bat is called batcat on Ubuntu (because the bat name is already taken).
  alias cat="batcat"
elif command -v bat &> /dev/null; then
  # If bat installed, alias cat to bat.
  alias cat="bat"
fi

source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh

if command -v eza &> /dev/null; then
  # If eza is found, create aliases.

  # Basic alias for 'ls'
  alias ls='eza'

  # eza after cd
  function chpwd() {
      emulate -L zsh
      eza -1lao --icons=always -s name --git-ignore --git-repos-no-status --no-user --no-filesize
  }
else 
  # ls after cd
  function chpwd() {
      emulate -L zsh
      ls -alth
  }
fi 

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)
FZF_CTRL_R_COMMAND= FZF_ALT_C_COMMAND= source <(fzf --zsh)

# Options to fzf command
export FZF_COMPLETION_OPTS='--border --info=inline'

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments ($@) to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'tree -C {} | head -200'   "$@" ;;
    export|unset) fzf --preview "eval 'echo \$'{}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview 'bat -n --color=always {}' "$@" ;;
  esac
}

# Find and replace in files, using ripgrep to find and sed to replace.
function rgr { rg -0 -l -s "$1" | AGR_FROM="$1" AGR_TO="$2" xargs -r0 perl -pi -e 's/$ENV{AGR_FROM}/$ENV{AGR_TO}/g'; }

# Use nvim as default editor for kube edit cmds.
export KUBE_EDITOR="nvim"

# EZA autocompletion for ZSH
if type brew &>/dev/null; then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
    autoload -Uz compinit
    compinit
fi

# Yazi -- change the CWD when exiting yazi
# Press q to quit if you want CWD to change.
# Press Q to quit of you want to keep the same CWD.
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# Please build autocompletion
if command -v plz &> /dev/null; then
  source <(plz --completion_script)
fi
