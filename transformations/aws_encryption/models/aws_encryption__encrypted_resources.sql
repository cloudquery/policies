--S3 Bucket Encryption
SELECT bucket_arn as arn, aws_s3_buckets.account_id,
apply_server_side_encryption_by_default ->> 'KMSMasterKeyID' as KMSKeyID,
  'S3 Bucket' as resource
FROM aws_s3_buckets
LEFT JOIN aws_s3_bucket_encryption_rules
on arn = bucket_arn

UNION
--SQS Queue Encryption
SELECT arn, account_id,
kms_master_key_id as KMSKeyID,
  'SQS Queue' as resource
FROM aws_sqs_queues

UNION
--EBS Volumes
SELECT arn, account_id,
  kms_key_id as KMSKeyID,
  'EBS Volume' as resource
FROM aws_ec2_ebs_volumes

UNION
--Parameter Store
SELECT name as arn,
account_id,
key_id as KMSKeyID,
  'SSM Parameter' as resource
FROM aws_ssm_parameters

UNION
--Secrets Manager
SELECT arn, account_id, 
kms_key_id as KMSKeyID,
'Secrets Manager Secret' as resource
FROM aws_secretsmanager_secrets

UNION
--DynamoDB 
SELECT table_arn as arn, account_id,
sse_description ->> 'KMSMasterKeyArn' as KMSKeyID,
'DynamoDB Table' as resource
from aws_dynamodb_tables

--AWS Glue Data Catalog
--No ARN, so Region is used for ARN.
--TODO: FIX ARN
UNION
SELECT region as arn, account_id, 
connection_password_encryption ->> 'AwsKmsKeyId' as KMSKeyID,
'Glue Data Catalog Connection Password Encryption' as resource
FROM aws_glue_datacatalog_encryption_settings

UNION
SELECT region as arn, account_id, 
encryption_at_rest ->> 'SseAwsKmsKeyId' as KMSKeyID,
'Glue Data Catalog Encryption' as resource
FROM aws_glue_datacatalog_encryption_settings

  --RDS Clusters
UNION
SELECT arn, account_id, 
kms_key_id as KMSKeyID,
'RDS DB Cluster' as resource
FROM aws_rds_clusters

--SNS Topic