export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

export FZF_DEFAULT_OPTS_FILE="$XDG_CONFIG_HOME/fzf/fzfrc"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

export EDITOR=nvim
export VISUAL=nvim
export SUDO_EDITOR=nvim

export TERMCMD='alacritty -e'
export GDK_DEBUG=portals

export FZF_DEFAULT_COMMAND='bfs -color -mindepth 1 -printf %P\n'
export LS_COLORS='di=01;34:ln=01;36:so=01;35:pi=01;33:ex=01;32:bd=01;33:cd=01;33:su=37;41:sg=30;43:tw=30;42:ow=34;42'
export MANPAGER='less -IR --incsearch --use-color --color=d+g --color=uc'
export MANROFFOPT='-P -c' # This sets grotty opts to disable in built color and use bold/underline instead. Noone knows why but it's necessary

export PATH="$HOME/go/bin:$PATH"

export PATH="/opt/homebrew/share/google-cloud-sdk/bin:$PATH"

export PATH="/opt/homebrew/opt/python/libexec/bin:$PATH"

export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"

export PATH="$XDG_DATA_HOME/../bin:$PATH"

export PATH="$PATH:$XDG_DATA_HOME/../script"
