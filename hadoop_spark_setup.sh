sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get install openjdk-8-jdk -y scala python3-pip -y
<<<<<<< HEAD
​
=======

>>>>>>> 7b1f85c (add hadoop and spark setup file)
#Install hadoop 
wget http://apache.mirrors.tds.net/hadoop/common/hadoop-2.10.0/hadoop-2.10.0.tar.gz -P ~/Downloads
sudo tar zxvf ~/Downloads/hadoop-* -C /usr/local
sudo mv /usr/local/hadoop-* /usr/local/hadoop
<<<<<<< HEAD
​
=======

>>>>>>> 7b1f85c (add hadoop and spark setup file)
# install spark
wget https://archive.apache.org/dist/spark/spark-2.4.3/spark-2.4.3-bin-hadoop2.7.tgz -P ~/Downloads
# sudo tar xvf spark-2.4.3-bin-hadoop2.7.tgz 
sudo tar zxvf ~/Downloads/spark-* -C /usr/local
sudo mv spark-2.4.3-bin-hadoop2.7/ /usr/local/spark
sudo mv /usr/local/spark-* /usr/local/spark
<<<<<<< HEAD
​
$ vi ~/.profile
​
=======

$ vi ~/.profile

>>>>>>> 7b1f85c (add hadoop and spark setup file)
# Setup hadoop config
sudo cat > /usr/local/hadoop/etc/hadoop/hadoop-env.sh <<EOL
export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")
export HADOOP_HOME=/usr/local/hadoop
EOL
<<<<<<< HEAD
​
=======

>>>>>>> 7b1f85c (add hadoop and spark setup file)
# Set env variables  
echo export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::") >> ~/.profile
echo export HADOOP_HOME=/usr/local/hadoop >> ~/.profile
echo export SPARK_HOME=/usr/local/spark >> ~/.profile
echo export PYSPARK_PYTHON=/usr/bin/python3 >> ~/.profile
echo export PATH=$PATH:/usr/local/spark/bin:/usr/local/spark/sbin:/usr/local/hadoop/bin >> ~/.profile
source ~/.profile
echo export SPARK_DIST_CLASSPATH=$(hadoop classpath) >> ~/.profile
source ~/.profile
<<<<<<< HEAD
​
​
=======


>>>>>>> 7b1f85c (add hadoop and spark setup file)
# Start spark
sudo bash start-master.sh
