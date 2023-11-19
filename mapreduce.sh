#!/bin/bash -i

hadoop fs -copyFromLocal /Users/mosi/Desktop/Polytechnique/Courses/Cloud/Assignment2_LOG8415/soc-LiveJournal1Adj.txt /user/ubuntu/input/

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

if [[ ! -d "/home/ubuntu/results" ]]; then 
    mkdir /home/ubuntu/results
else 
    rm -f /home/ubuntu/results/*


source ~/.profile


hadoop jar $HADOOP_HOME/share/hadoop//tools/lib/hadoop-streaming-3.3.6.jar \
-file mapper.py -mapper mapper.py \
-file reducer.py -reducer reducer.py 
-input soc-LiveJournal1Adj.txt -output output 2> results/mapreducer.txt


cp -r results/* /home/ubuntu/results