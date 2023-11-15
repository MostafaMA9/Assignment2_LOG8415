#!/bin/bash -i

apt-get update
apt-get -y upgrade
apt install openjdk-8-jdk -y scala python3-pip -y
pip3 install --no-cache-dir pyspark==2.0.0

#Install hadoop 
wget https://dlcdn.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz
tar -xzvf hadoop-3.3.6.tar.gz
mkdir /usr/local/hadoop
mv hadoop-3.3.6/* /usr/local/hadoop

#Install spark 
wget https://archive.apache.org/dist/spark/spark-2.0.0/spark-2.0.0-bin-without-hadoop.tgz
tar -xzvf spark-2.0.0-bin-without-hadoop.tgz
mkdir /opt/spark
mv spark-2.0.0-bin-without-hadoop/* /opt/spark

# Setup hadoop config
cat <<EOF > /usr/local/hadoop/etc/hadoop/hadoop-env.sh
export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")
export HADOOP_HOME=/usr/local/hadoop
EOF

# Set env variables  
echo export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::") >> ~/.profile
echo export HADOOP_HOME=/usr/local/hadoop >> ~/.profile
echo export SPARK_HOME=/opt/spark >> ~/.profile
echo export PYSPARK_PYTHON=/usr/bin/python3 >> ~/.profile
echo export PATH=$PATH:/opt/spark/bin:/opt/spark/sbin:/usr/local/hadoop/bin >> ~/.profile
source ~/.profile
echo export SPARK_DIST_CLASSPATH=$(hadoop classpath) >> ~/.profile
source ~/.profile

# Start spark
start-master.sh 2> log.txt
