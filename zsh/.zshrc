# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
p10k_cache="$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh" # ${(%):-%n} is zsh specific syntax
[[ -r $p10k_cache ]] && . $p10k_cache # double for speed

# Make directories
[ -d "$XDG_CONFIG_HOME/zsh" ] || mkdir -p "$XDG_CONFIG_HOME/zsh"
[ -d "$XDG_CACHE_HOME/zsh" ] || mkdir -p "$XDG_CACHE_HOME/zsh"
[ -d "$XDG_DATA_HOME/zsh" ] || mkdir -p "$XDG_DATA_HOME/zsh"
[ -d "$XDG_STATE_HOME/zsh" ] || mkdir -p "$XDG_STATE_HOME/zsh"

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

# Zinit - best before compinit
ZINIT_HOME="$XDG_DATA_HOME/zinit/zinit.git" # This is a directory
[ -d $ZINIT_HOME ] || mkdir -p "$(dirname $ZINIT_HOME)"
[ -d $ZINIT_HOME/.git ] || git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
. "$ZINIT_HOME/zinit.zsh"

ZVM_INIT_MODE=sourcing # make zsh-vi-mode not overwrite fzf stuff
zinit ice depth=1; zinit light romkatv/powerlevel10k
zinit ice depth=1; zinit light jeffreytse/zsh-vi-mode # abbreviations for text objects don't work
# zinit ice depth=1; zinit light zdharma-continuum/fast-syntax-highlighting # breaks fzf tab somehow
zinit ice depth=1; zinit light zsh-users/zsh-syntax-highlighting
zinit ice depth=1; zinit light zsh-users/zsh-completions
zinit ice depth=1; zinit light zsh-users/zsh-autosuggestions
# zinit ice depth=1; zinit light marlonrichert/zsh-autocomplete
zinit ice depth=1; zinit light zsh-users/zsh-history-substring-search
zinit ice depth=1; zinit light Aloxaf/fzf-tab

zinit ice depth=1; zinit snippet OMZP::sudo

[ -f "$ZDOTDIR/.p10k.zsh" ] && . "$ZDOTDIR/.p10k.zsh" || true

# Completions
autoload -Uz compinit
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "$LS_COLORS"
zstyle ':completion:*' menu no # for fzf tab
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

# zinit cdreplay -q

# Keybindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1
bindkey '^[f' forward-word
bindkey '^[b' backward-word
bindkey '^[^?' backward-kill-word
bindkey -r '^[^['
bindkey -M viins '^[s' sudo-command-line

eval "$(fzf --zsh)"

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
