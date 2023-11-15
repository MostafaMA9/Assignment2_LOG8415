#!/bin/bash -i

sudo -i

if [[ ! -d "input" ]]; then 
    mkdir input
else 
    rm -f input/*
fi

if [[ -d "output" ]]; then 
    rm -rf output
fi

if [[ ! -d "results" ]]; then 
    mkdir results
else 
    rm -f results/*
fi

if [[ ! -d "/home/ubuntu/results" ]]; then 
    mkdir /home/ubuntu/results
else 
    rm -f /home/ubuntu/results/*
fi

if [[ ! -d "dataset" ]]; then 
    mkdir dataset
    cd dataset
    curl -O -L -s https://tinyurl.com/4vxdw3pa
    curl -O -L -s https://tinyurl.com/kh9excea
    curl -O -L -s https://tinyurl.com/dybs9bnk
    curl -O -L -s https://tinyurl.com/datumz6m
    curl -O -L -s https://tinyurl.com/j4j4xdw6
    curl -O -L -s https://tinyurl.com/ym8s5fm4
    curl -O -L -s https://tinyurl.com/2h6a75nk
    curl -O -L -s https://tinyurl.com/vwvram8
    curl -O -L -s https://tinyurl.com/weh83uyn
    cd ..
fi

source ~/.profile

for file in dataset/*; do
    file_name=$(basename "$file")
    echo "Starting Wordcount on https://tinyurl.com/$file_name"
    cp $file input/
    for i in {1..3}; do
        #Hadoop
        echo "https://tinyurl.com/$file_name" >> results/hadoop_wordcount_time.txt
        { time -p hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.6.jar wordcount input output 2> hadoop_log.txt; } 2>> results/hadoop_wordcount_time.txt
        rm -rf output
        #Spark
        echo "https://tinyurl.com/$file_name" >> results/spark_wordcount_time.txt
        { time -p run-example JavaWordCount "$file" 1> spark_log.txt 2> spark_err.txt; } 2>> results/spark_wordcount_time.txt
    done
    rm -f input/*    
done

cp -r results/* /home/ubuntu/results