export EDITOR=nvim
export VISUAL=nvim
export SUDO_EDITOR=nvim

export LS_COLORS='di=01;34:ln=01;36:so=01;35:pi=01;33:ex=01;32:bd=01;33:cd=01;33:su=37;41:sg=30;43:tw=30;42:ow=34;42'
export MANPAGER='less -IR --incsearch --use-color --color=d+g --color=uc'
export MANROFFOPT='-P -c' # This sets grotty opts to disable in built color and use bold/underline instead. Noone knows why but it's necessary
export UV_PYTHON_PREFERENCE=system

# Can't figure out what is using these so keep for now
export CUDA_PATH=/opt/cuda
export PATH="/opt/cuda/bin:/opt/cuda/nsight_compute:/opt/cuda/nsight_systems/bin:$PATH"
export NVCC_CCBIN='/usr/bin/g++-13'

export PATH="$XDG_DATA_HOME/../bin:$PATH"


export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
# export XDG_CONFIG_HOME="$HOME/.cfg"
# export XDG_CACHE_HOME="$HOME/.cch"
# export XDG_DATA_HOME="$HOME/.lcl/share"
# export XDG_STATE_HOME="$HOME/.lcl/state"

export XDG_VIDEOS_DIR="$HOME/vid"

export ANDROID_USER_HOME="$XDG_DATA_HOME/android"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export GOPATH="$XDG_DATA_HOME/go"
export GOMODCACHE="$XDG_CACHE_HOME/go/mod"
export IPYTHONDIR="$XDG_CONFIG_HOME/ipython"
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME/java"
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"
export KERAS_HOME="$XDG_STATE_HOME/keras"
export MPLAYER_HOME="$XDG_CONFIG_HOME/mplayer"
export MYSQL_HISTFILE="$XDG_STATE_HOME/mariadb/history"
export MYPY_CACHE_DIR="$XDG_CACHE_HOME/mypy"
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/pass"
export PYENV_ROOT="$XDG_DATA_HOME/pyenv"
export PYTHON_HISTORY="$XDG_STATE_HOME/python/history"
export PYTHONPYCACHEPREFIX="$XDG_CACHE_HOME/python"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"
export PYTHONUSERBASE="$XDG_DATA_HOME/python"
export R_HOME_USER="$XDG_CONFIG_HOME/R"
export R_PROFILE_USER="$XDG_CONFIG_HOME/R/profile"
export R_HISTFILE="$XDG_CONFIG_HOME/R/history"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup" # not working for some reason
export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
export TEXMFHOME="$XDG_DATA_HOME/texmf"
export TEXMFVAR="$XDG_CACHE_HOME/texlive/texmf-var"
export TEXMFCONFIG="$XDG_CONFIG_HOME/texlive/texmf-config"
export WGETRC="$XDG_CONFIG_HOME/wgetrc"
export WINEPREFIX="$XDG_DATA_HOME/wineprefixes/default"
