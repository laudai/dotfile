#!/bin/bash

#AWS_PROFILE=''
AWS_REGION='eu-west-1'
MAX_ITERATION=5
SLEEP_DURATION=5

# Arguments passed from SSH client
HOST=$1
PORT=$2

echo $HOST

# Start ssm session
aws ssm start-session --target $HOST \
  --document-name AWS-StartSSHSession \
  --parameters portNumber=${PORT} \
  --region ${AWS_REGION}

#  --profile ${AWS_PROFILE} \

