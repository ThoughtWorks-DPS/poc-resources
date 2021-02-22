#!/bin/sh
ROLE=$1
SESSION_NAME=$2

aws sts assume-role --output json --role-arn $ROLE --role-session-name $SESSION_NAME --duration-seconds 900 > credentials

export AWS_ACCESS_KEY_ID=$(cat credentials | jq -r ".Credentials.AccessKeyId")
export AWS_SECRET_ACCESS_KEY=$(cat credentials | jq -r ".Credentials.SecretAccessKey")
export AWS_SESSION_TOKEN=$(cat credentials | jq -r ".Credentials.SessionToken")