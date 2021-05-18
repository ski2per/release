#!/usr/bin/env bash


USERNAME=test
PASSWORD=test
BASE_URL=http://172.16.66.6:8000/api
AUTH_API="$BASE_URL/token"
JOB_API="$BASE_URL/devops/job"

# 只支持英文
JOB_NAME=myjob
JOB_STATE=1
JOB_DESC=我的任务


TOKEN=$(curl -s -X POST -F "username=$USERNAME" -F "password=$PASSWORD" $AUTH_API | awk -F'"' '{print $4}')

curl -X PUT -G -H "Authorization: Bearer $TOKEN" "$JOB_API" --data-urlencode "job_name=$JOB_NAME" --data-urlencode "job_state=$JOB_STATE" --data-urlencode "job_desc=$JOB_DESC" 

