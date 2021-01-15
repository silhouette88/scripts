#/usr/bin/env bash

EMR_RUN_DATE=$1
DATABASE=$2
EXT_TABLE_LOCATION=$3
ATHENA_OUTPUT_LOCATION=$4
EMR_CLUSTER_ID=$(aws emr list-clusters --created-after $EMR_RUN_DATE --cluster-states TERMINATED | jq '.Clusters[0].Id' | tr -d '"')
RAW_RUN_DIR=$(aws emr list-steps --cluster-id $EMR_CLUSTER_ID | jq '.Steps[0].Config.Args[3]' | awk -F / '{ print $7 }')
RUN_DIR=$(echo ${RAW_RUN_DIR:4:19})

echo "Creating partition for: run = ${RUN_DIR}"

# Change the following to not echo, if you want to run it live
echo "aws athena start-query-execution \
--query-string 'ALTER TABLE archive ADD IF NOT EXISTS PARTITION (run = '${RUN_DIR}') LOCATION 's3://${EXT_TABLE_LOCATION}/${RUN_DIR}/'' \
--work-group 'primary' \
--query-execution-context Database=${DATABASE},Catalog=AwsDataCatalog \
--result-configuration OutputLocation=s3://${ATHENA_OUTPUT_LOCATION}"
