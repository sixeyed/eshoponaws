#!/bin/bash

# required parameters in ENV:
# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY
# AWS_DEFAULT_REGION
# SQL_DATABASE_NAME
# SQL_PASSWORD

echo "Creating RDS database: $SQL_DATABASE_NAME"
DB_INSTANCE=$(aws rds create-db-instance \
    --engine sqlserver-ex \
    --db-instance-identifier $SQL_DATABASE_NAME \
    --allocated-storage 50 \
    --db-instance-class db.t2.micro \
    --master-username master \
    --master-user-password $SQL_PASSWORD)

SG_ID=$(echo $DB_INSTANCE | jq '.DBInstance.VpcSecurityGroups[] .VpcSecurityGroupId' -r)

echo "Enabling SQL Server traffic ingress on SG: $SG_ID"
aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 1433 --cidr 0.0.0.0/0
