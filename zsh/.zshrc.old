# vim: set filetype=sh :

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
# zinit snippet OMZP::git
# zinit snippet OMZP::sudo
# zinit snippet OMZP::archlinux
# zinit snippet OMZP::command-not-found

# Load completions
autoload -U compinit # autocomp does -Uz
# Completion files: Use XDG dirs
[ -d "$XDG_CACHE_HOME"/zsh ] || mkdir -p "$XDG_CACHE_HOME"/zsh
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME"/zsh/zcompcache
compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-$ZSH_VERSION

zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[[ ! -f ${ZDOTDIR:-~}/.p10k.zsh ]] || source ${ZDOTDIR:-~}/.p10k.zsh

# Keybindings
bindkey -e
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
# bindkey '^H' backward-kill-word
# bindkey '^[w' kill-region

# History
[ -d "${XDG_STATE_HOME}"/zsh ] || mkdir -p "${XDG_STATE_HOME}"/zsh
[ -e "${XDG_STATE_HOME}"/zsh/history ] || touch "${XDG_STATE_HOME}"/zsh/history
HISTFILE="${XDG_STATE_HOME}"/zsh/history
HISTSIZE=5000  # auto does 1000
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
LS_COLORS='di=01;34:ln=01;36:so=01;35:pi=01;33:ex=01;32:bd=01;33:cd=01;33:su=37;41:sg=30;43:tw=30;42:ow=34;42'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
# zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls='LC_COLLATE=C ls -A --color --group-directories-first'
alias diff='diff --color=always'
alias grep='grep --color=always'
alias ip='ip -color=always'
alias less='less -IR'
alias info='info --vi-keys'
alias tree='tree -aC --dirsfirst'
alias tree-git='tree -aC --dirsfirst --gitignore -I .git'

alias s='sudo'
alias c='clear'
alias ..='cd ..'
alias p='paru --color=always'
alias pm='pacman --color=always'
alias spm='sudo pacman --color=always'
alias lg='lazygit'
alias slg='sudo lazygit'
alias py='python'
alias ipy='ipython'

alias fzf='fzf --preview "bat --color=always {}"'
alias wey="ip -4 -brief address && weylus --no-gui"
alias weylus='weylus --auto-start --access-code $(head /dev/urandom | tr -cd A-Za-z0-9 | head -c 20)'

alias adb='HOME="$XDG_DATA_HOME"/android adb'
alias arm='~/.config/bin/arm.sh'
alias brave='brave --ozone-platform-hint=auto --disable-gpu --enable-features="TouchpadOverscrollHistoryNavigation"'
alias wget='wget --hsts-file="$XDG_CACHE_HOME/wget-hsts"'
alias R='R --no-save'
alias mariadb='mariadb -u ankit --password=$(pass code/mariadb/ankit)'

alias nfs='NVIM_APPNAME=nfs nvim'

# Shell integrations
eval "$(fzf --zsh)"
# eval "$(zoxide init --cmd cd zsh)"

# KAFKA_DIR="$XDG_DATA_HOME"/kafka
# KAFKA_HOME=$KAFKA_DIR/kafka_2.12-3.7.1
# alias zookeeper-start="$KAFKA_HOME/bin/zookeeper-server-start.sh $KAFKA_HOME/config/zookeeper.properties"


# export MANPAGER='less -R --use-color -Dd+r -Du+b'
