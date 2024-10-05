#!/bin/sh

# Make sure:
# hadoop directory doesn't exist in ~/.local/share (or xdg)
# hadoop exports aren't there in .zshenv
# jdk8-openjdk is installed
# ssh keys exist and sshd.service is running

set -e

HADOOP_DIR="$XDG_DATA_HOME"/hadoop
if [ -d $HADOOP_DIR ]; then
    echo "$HADOOP_DIR already exists."
    exit 1
fi

java -version
javac -version

if [ ! -f "$HOME/.ssh/id_rsa" ]; then
    echo "SSH keys are not present."
    exit 1
fi
ssh-copy-id ankit@localhost # Enter user's password

mkdir -p $HADOOP_DIR
cd $HADOOP_DIR
wget https://dlcdn.apache.org/hadoop/common/hadoop-3.4.0/hadoop-3.4.0.tar.gz
wget https://dlcdn.apache.org/hadoop/common/hadoop-3.4.0/hadoop-3.4.0.tar.gz.sha512
sha512sum -c hadoop-3.4.0.tar.gz.sha512
tar xzf "$HADOOP_DIR"/hadoop-3.4.0.tar.gz
mkdir tmpdata dfsdata dfsdata/datanode dfsdata/namenode


cat <<EOF >> "${ZDOTDIR:-$HOME}"/.zshenv

export HADOOP_HOME=$HADOOP_DIR/hadoop-3.4.0
export HADOOP_INSTALL=\$HADOOP_HOME
export HADOOP_MAPRED_HOME=\$HADOOP_HOME
export HADOOP_COMMON_HOME=\$HADOOP_HOME
export HADOOP_HDFS_HOME=\$HADOOP_HOME
export YARN_HOME=\$HADOOP_HOME
export HADOOP_COMMON_LIB_NATIVE_DIR=\$HADOOP_HOME/lib/native
export HADOOP_OPTS=-Djava.library.path=\$HADOOP_HOME/lib/native
export PATH=\$PATH:\$HADOOP_HOME/sbin:\$HADOOP_HOME/bin
EOF
source "${ZDOTDIR:-$HOME}"/.zshenv

sed -i '/^# export JAVA_HOME=/c\export JAVA_HOME=/usr/lib/jvm/java-8-openjdk' "$HADOOP_HOME"/etc/hadoop/hadoop-env.sh

file="$HADOOP_HOME"/etc/hadoop/core-site.xml
head -n -3 "$file" > temp.xml && mv temp.xml "$file"
cat <<EOF >> $file
<configuration>
    <property>
        <name>hadoop.tmp.dir</name>
        <value>$HADOOP_DIR/tmpdata</value>
    </property>
    <property>
        <name>fs.default.name</name>
        <value>hdfs://127.0.0.1:9000</value>
    </property>
</configuration>
EOF

file="$HADOOP_HOME"/etc/hadoop/hdfs-site.xml
head -n -3 "$file" > temp.xml && mv temp.xml "$file"
cat <<EOF >> $file
<configuration>
    <property>
        <name>dfs.name.dir</name>
        <value>$HADOOP_DIR/dfsdata/namenode</value>
    </property>
    <property>
        <name>dfs.data.dir</name>
        <value>$HADOOP_DIR/dfsdata/datanode</value>
    </property>
    <property>
        <name>dfs.replication</name>
        <value>1</value>
    </property>
</configuration>
EOF

file="$HADOOP_HOME"/etc/hadoop/mapred-site.xml
head -n -3 "$file" > temp.xml && mv temp.xml "$file"
cat <<EOF >> $file
<configuration>
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
    </property>
</configuration>
EOF

file="$HADOOP_HOME"/etc/hadoop/yarn-site.xml
head -n -5 "$file" > temp.xml && mv temp.xml "$file"
cat <<EOF >> $file
<configuration>
    <property>
        <name>yarn.nodemanager.aux-services</name>
        <value>mapreduce_shuffle</value>
    </property>
    <property>
        <name>yarn.nodemanager.aux-services.mapreduce.shuffle.class</name>
        <value>org.apache.hadoop.mapred.ShuffleHandler</value>
    </property>
    <property>
        <name>yarn.resourcemanager.hostname</name>
        <value>127.0.0.1</value>
    </property>
    <property>
        <name>yarn.acl.enable</name>
        <value>0</value>
    </property>
    <property>
        <name>yarn.nodemanager.env-whitelist</name>
        <value>JAVA_HOME,HADOOP_COMMON_HOME,HADOOP_HDFS_HOME,HADOOP_CONF_DIR,CLASSPATH_PERPEND_DISTCACHE,HADOOP_YARN_HOME,HADOOP_MAPRED_HOME</value>
    </property>
</configuration>
EOF

hdfs namenode -format
"$HADOOP_HOME"/sbin/start-all.sh
jps
"$HADOOP_HOME"/sbin/stop-all.sh
