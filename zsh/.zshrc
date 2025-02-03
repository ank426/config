[ -d $XDG_CONFIG_HOME/zsh ] || mkdir -p $XDG_CONFIG_HOME/zsh
[ -d $XDG_CACHE_HOME/zsh ] || mkdir -p $XDG_CACHE_HOME/zsh
[ -d $XDG_DATA_HOME/zsh ] || mkdir -p $XDG_DATA_HOME/zsh
[ -d $XDG_STATE_HOME/zsh ] || mkdir -p $XDG_STATE_HOME/zsh

# Options
setopt auto_cd
setopt auto_list
setopt list_types
setopt append_history
setopt extended_history
setopt hist_find_no_dups
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt interactive_comments

# Params
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=5000
SAVEHIST=$HISTSIZE

# Completions
autoload -Uz compinit
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "$LS_COLORS"

# Aliases
alias s='sudo'
alias c='clear'
alias p='paru --color=always'
alias pm='pacman --color=always'
alias spm='sudo pacman --color=always'
alias lg='lazygit'
alias slg='sudo lazygit'
alias py='python'
alias ipy='ipython'

alias diff='diff --color=always'
alias grep='grep --color=always'
alias ip='ip -color=always'
alias less='less -IR --incsearch'
alias ls='LC_COLLATE=C ls -A --color --group-directories-first'
alias info='info --vi-keys'

alias fzf='fzf --preview "bat --color=always {}"'
alias tree='tree -aC --dirsfirst'
alias tree-git='tree -aC --dirsfirst --gitignore -I .git'

alias arm="$XDG_CONFIG_HOME/bin/arm.sh"
alias brave='brave --ozone-platform-hint=auto --disable-gpu --enable-features="TouchpadOverscrollHistoryNavigation"'
alias mariadb='mariadb -u ankit --password=$(pass code/mariadb/ankit)'
alias wey='ip -4 -brief address && weylus --no-gui'
alias weylus='weylus --auto-start --access-code $(head /dev/urandom | tr -cd A-Za-z0-9 | head -c 20)'

alias adb="HOME=$XDG_DATA_HOME/android adb"
alias wget="wget --hsts-file=$XDG_CACHE_HOME/wget-hsts"
alias R='R --no-save'
