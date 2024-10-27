export XDG_CONFIG_HOME="$HOME"/.config
export XDG_CACHE_HOME="$HOME"/.cache
export XDG_DATA_HOME="$HOME"/.local/share
export XDG_STATE_HOME="$HOME"/.local/state
# export XDG_CONFIG_HOME="$HOME"/.cfg
# export XDG_CACHE_HOME="$HOME"/.cch
# export XDG_DATA_HOME="$HOME"/.lcl/share
# export XDG_STATE_HOME="$HOME"/.lcl/state

export ANDROID_USER_HOME="$XDG_DATA_HOME"/android
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export GOPATH="$XDG_DATA_HOME"/go
export GOMODCACHE="$XDG_CACHE_HOME"/go/mod
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME"/jupyter
export MPLAYER_HOME="$XDG_CONFIG_HOME"/mplayer
export MYSQL_HISTFILE="$XDG_STATE_HOME"/mariadb/history
export MYPY_CACHE_DIR="$XDG_CACHE_HOME"/mypy
export NODE_REPL_HISTORY="$XDG_DATA_HOME"/node_repl_history
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME"/npm/npmrc 
export PASSWORD_STORE_DIR="$XDG_DATA_HOME"/pass
export PYTHON_HISTORY=$XDG_STATE_HOME/python/history
export PYTHONPYCACHEPREFIX=$XDG_CACHE_HOME/python
export PYTHONSTARTUP="$XDG_CONFIG_HOME"/python/pythonrc
export PYTHONUSERBASE=$XDG_DATA_HOME/python
export R_HOME_USER="$XDG_CONFIG_HOME"/R
export R_PROFILE_USER="$XDG_CONFIG_HOME"/R/profile
export R_HISTFILE="$XDG_CONFIG_HOME"/R/history
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
export TEXMFHOME="$XDG_DATA_HOME"/texmf
export TEXMFVAR="$XDG_CACHE_HOME"/texlive/texmf-var
export TEXMFCONFIG="$XDG_CONFIG_HOME"/texlive/texmf-config
export WGETRC="$XDG_CONFIG_HOME"/wgetrc
export WINEPREFIX="$XDG_DATA_HOME"/wineprefixes/default

export EDITOR=nvim
export VISUAL=nvim
export SUDO_EDITOR=nvim

export CUDA_PATH=/opt/cuda
export PATH=/opt/cuda/bin:/opt/cuda/nsight_compute:/opt/cuda/nsight_systems/bin:$PATH
export NVCC_CCBIN='/usr/bin/g++-13'
export UV_PYTHON_PREFERENCE='system'

export HADOOP_HOME="$XDG_DATA_HOME/hadoop/hadoop-3.4.0"
export HADOOP_INSTALL=$HADOOP_HOME
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_HDFS_HOME=$HADOOP_HOME
export YARN_HOME=$HADOOP_HOME
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export HADOOP_OPTS=-Djava.library.path=$HADOOP_HOME/lib/native
export PATH="$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin"

export SPARK_HOME="$XDG_DATA_HOME/spark/spark-3.5.3-bin-hadoop3"
export PYSPARK_PYTHON=/usr/bin/python3
export PATH="$PATH:$SPARK_HOME/sbin:$SPARK_HOME/bin"
alias spark-start="$SPARK_HOME/sbin/start-all.sh"
alias spark-stop="$SPARK_HOME/sbin/stop-all.sh"

export KAFKA_HOME="$XDG_DATA_HOME/kafka/kafka_2.12-3.7.1"
alias zookeeper-start="$KAFKA_HOME/bin/zookeeper-server-start.sh $KAFKA_HOME/config/zookeeper.properties > /dev/null &"
alias zookeeper-stop="$KAFKA_HOME/bin/zookeeper-server-stop.sh"
alias kafka-start="$KAFKA_HOME/bin/kafka-server-start.sh $KAFKA_HOME/config/server.properties > /dev/null &"
alias kafka-stop="$KAFKA_HOME/bin/kafka-server-stop.sh"
