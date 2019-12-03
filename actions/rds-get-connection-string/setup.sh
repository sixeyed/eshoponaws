#!/bin/sh

# required parameters in ENV:
# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY
# AWS_DEFAULT_REGION
# SQL_DATABASE_NAME
# SQL_PASSWORD

DB_INSTANCE=$(aws rds describe-db-instances --filter Name=db-instance-id,Values=$SQL_DATABASE_NAME)
SQL_USERNAME=$(echo $DB_INSTANCE | jq '.DBInstances[] .MasterUsername' -r)
SQL_ENDPOINT=$(echo $DB_INSTANCE | jq '.DBInstances[] .Endpoint.Address' -r)

sed -i "s/{SQL_ENDPOINT}/$SQL_ENDPOINT/g" /app/db-connection-string && \
sed -i "s/{SQL_USERNAME}/$SQL_USERNAME/g" /app/db-connection-string && \
sed -i "s/{SQL_PASSWORD}/$SQL_PASSWORD/g" /app/db-connection-string

connectionString=$(cat /app/db-connection-string)
echo ::set-output name=connectionString::$connectionString
