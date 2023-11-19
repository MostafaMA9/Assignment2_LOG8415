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


source ~/.profile

cp /home/ubuntu/soc-LiveJournal1Adj.txt .
cp /home/ubuntu/mapper.py .
cp /home/ubuntu/reducer.py .
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-3.3.6.jar -file mapper.py -mapper mapper.py -file reducer.py -reducer reducer.py -input soc-LiveJournal1Adj.txt -output output 2>> log.txt

cp -r output/* /home/ubuntu/results