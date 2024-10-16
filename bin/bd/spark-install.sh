#!/bin/sh

# Make sure:
# sshd is running
# spark directory doesn't exist in ~/.local/share (or xdg)
# spark exports aren't there in zshenv

set -e

SPARK_DIR="$XDG_DATA_HOME"/spark
if [ -d "$SPARK_DIR" ]; then
  echo "$SPARK_DIR already exists."
  exit 1
fi

mkdir -p $SPARK_DIR
cd $SPARK_DIR
wget https://dlcdn.apache.org/spark/spark-3.5.3/spark-3.5.3-bin-hadoop3.tgz
tar xf spark-3.5.3-bin-hadoop3.tgz


cat <<EOF >> "${ZDOTDIR:-$HOME}"/.zshenv

export SPARK_HOME="\$XDG_DATA_HOME/spark/spark-3.5.3-bin-hadoop3"
export PYSPARK_PYTHON=/usr/bin/python3
export PATH="\$PATH:\$SPARK_HOME/sbin:\$SPARK_HOME/bin"
alias spark-start="\$SPARK_HOME/sbin/start-all.sh"
alias spark-stop="\$SPARK_HOME/sbin/stop-all.sh"
EOF
source "${ZDOTDIR:-$HOME}"/.zshenv

"$SPARK_DIR"/sbin/start-all.sh
"$SPARK_DIR"/bin/run-example SparkPi 10
jps
"$SPARK_DIR"/sbin/stop-all.sh
