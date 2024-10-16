#!/bin/sh

# Make sure:
# kafka dir doesn't exist
# Aliases don't exist in .zshenv

set -e

KAFKA_DIR="$XDG_DATA_HOME"/kafka
if [ -d $KAFKA_DIR ]; then
  echo "$KAFKA_DIR already exists."
  exit 1
fi

mkdir -p $KAFKA_DIR
cd $KAFKA_DIR
wget https://downloads.apache.org/kafka/3.7.1/kafka_2.12-3.7.1.tgz
tar -xf kafka_2.12-3.7.1.tgz


cat <<EOF >> "${ZDOTDIR:-$HOME}"/.zshenv

export KAFKA_HOME="\$XDG_DATA_HOME/kafka/kafka_2.12-3.7.1"
alias zookeeper-start="\$KAFKA_HOME/bin/zookeeper-server-start.sh \$KAFKA_HOME/config/zookeeper.properties > /dev/null &"
alias zookeeper-stop="\$KAFKA_HOME/bin/zookeeper-server-stop.sh"
alias kafka-start="\$KAFKA_HOME/bin/kafka-server-start.sh \$KAFKA_HOME/config/server.properties > /dev/null &"
alias kafka-stop="\$KAFKA_HOME/bin/kafka-server-stop.sh"
EOF
source "${ZDOTDIR:-$HOME}"/.zshenv

zookeeper-start
kafka-start
kafka-stop
zookeeper-stop
