
import datetime
from queries import account, acm, apigateway, awsconfig, cloudfront, cloudtrail, codebuild, dms, dynamodb, ec2, iam, awslambda, s3, sagemaker, secretmanager, sns, sqs, ssm, waf
from snowflake.connector import SnowflakeConnection
import views

FRAMEWORK = 'Foundational Security Policy'

def execute_account(conn: SnowflakeConnection, execution_time: datetime.datetime):
    print("Running section: account")
    print("Running check: account.1")
    conn.cursor().execute(account.SECURITY_ACCOUNT_INFORMATION_PROVIDED, (execution_time, FRAMEWORK, 'account.1'))

def execute_acm(conn: SnowflakeConnection, execution_time: datetime.datetime):
    print("Running section: acm")
    print("Running check: acm.1")
    conn.cursor().execute(acm.CERTIFICATES_SHOULD_BE_RENEWED, (execution_time, FRAMEWORK, 'acm.1'))

def execute_apigateway(conn: SnowflakeConnection, execution_time: datetime.datetime):
    print("Running section: apigateway")
    print("Running check: apigateway.1")
    conn.cursor().execute(apigateway.API_GW_EXECUTION_LOGGING_ENABLED, (execution_time, FRAMEWORK, 'apigateway.1', execution_time, FRAMEWORK, 'apigateway.1'))

def execute_awsconfig(conn: SnowflakeConnection, execution_time: datetime.datetime):
    print("Running section: AWS Config")
    print("Running check: aws_config.1")
    conn.cursor().execute(awsconfig.ENABLED_ALL_REGIONS, (execution_time, FRAMEWORK, 'awsconfig.1'))

def execute_cloudfront(conn: SnowflakeConnection, execution_time: datetime.datetime):
    print("Running section: Cloudfront")
    print("Running check: cloudfront.1")
    conn.cursor().execute(cloudfront.DEFAULT_ROOT_OBJECT_CONFIGURED, (execution_time, FRAMEWORK, 'cloudfront.1'))
    print("Running check: cloudfront.2")
    conn.cursor().execute(cloudfront.ORIGIN_ACCESS_IDENTITY_ENABLED, (execution_time, FRAMEWORK, 'cloudfront.2'))
    print("Running check: cloudfront.3")
    conn.cursor().execute(cloudfront.VIEWER_POLICY_HTTPS, (execution_time, FRAMEWORK, 'cloudfront.3'))
    print("Running check: cloudfront.4")
    conn.cursor().execute(cloudfront.ORIGIN_FAILOVER_ENABLED, (execution_time, FRAMEWORK, 'cloudfront.4'))
    print("Running check: cloudfront.5")
    conn.cursor().execute(cloudfront.ACCESS_LOGS_ENABLED, (execution_time, FRAMEWORK, 'cloudfront.5'))
    print("Running check: cloudfront.6")
    conn.cursor().execute(cloudfront.ASSOCIATED_WITH_WAF, (execution_time, FRAMEWORK, 'cloudfront.6'))

def execute_cloudtrail(conn: SnowflakeConnection, execution_time: datetime.datetime):
    print("Running section: Cloudtrail")
    print("Running check: cloudtrail.1")
    conn.cursor().execute(cloudtrail.ENABLED_ALL_REGIONS, (execution_time, FRAMEWORK, 'cloudtrail.1'))
    print("Running check: cloudtrail.2")
    conn.cursor().execute(cloudtrail.LOGS_ENCRYPTED, (execution_time, FRAMEWORK, 'cloudtrail.2'))
    print("Running check: cloudtrail.3")
    conn.cursor().execute(cloudtrail.LOGS_FILE_VALIDATION_ENABLED, (execution_time, FRAMEWORK, 'cloudtrail.3'))
    print("Running check: cloudtrail.4")
    conn.cursor().execute(cloudtrail.LOGS_FILE_VALIDATION_ENABLED, (execution_time, FRAMEWORK, 'cloudtrail.4'))
    print("Running check: cloudtrail.5")
    conn.cursor().execute(cloudtrail.INTEGRATED_WITH_CLOUDWATCH_LOGS, (execution_time, FRAMEWORK, 'cloudtrail.5'))

def execute_codebuild(conn: SnowflakeConnection, execution_time: datetime.datetime):
    print("Running section: Codebuild")
    print("Running check: codebuild.1")
    conn.cursor().execute(codebuild.CHECK_OAUTH_USAGE_FOR_SOURCES, (execution_time, FRAMEWORK, 'codebuild.1'))
    print("Running check: codebuild.2")
    conn.cursor().execute(codebuild.CHECK_ENVIRONMENT_VARIABLES, (execution_time, FRAMEWORK, 'codebuild.2'))

def execute_dms(conn: SnowflakeConnection, execution_time: datetime.datetime):
    print("Running section: DMS")
    print("Running check: dms.1")
    conn.cursor().execute(dms.REPLICATION_NOT_PUBLIC, (execution_time, FRAMEWORK, 'dms.1'))

def execute_dynamodb(conn: SnowflakeConnection, execution_time: datetime.datetime):
    print("Running section: DynamoDB")
    print("Running check: dynamodb.1")
    conn.cursor().execute(dynamodb.AUTOSCALE_OR_ONDEMAND, (execution_time, FRAMEWORK, 'dynamodb.1'))
    print("Running check: dynamodb.2")
    conn.cursor().execute(dynamodb.POINT_IN_TIME_RECOVERY, (execution_time, FRAMEWORK, 'dynamodb.2'))
    print("Running check: dynamodb.3")
    conn.cursor().execute(dynamodb.DAX_ENCRYPTED_AT_REST, (execution_time, FRAMEWORK, 'dynamodb.3'))

def execute_ec2(conn: SnowflakeConnection, execution_time: datetime.datetime):
    print("Running section: EC2")
    print("Creating view_aws_security_group_ingress_rules")
    conn.cursor().execute(views.SECURITY_GROUP_INGRESS_RULES)
    print("Executing check EC2.1")
    conn.cursor().execute(ec2.EBS_SNAPSHOT_PERMISSIONS_CHECK, (execution_time, FRAMEWORK, 'EC2.1'))

def execute_iam(conn: SnowflakeConnection, execution_time: datetime.datetime):
    print("Running section: IAM")
    # print("Executing check iam.1")
    # conn.cursor().execute(iam.POLICIES_WITH_ADMIN_RIGHTS, (execution_time, FRAMEWORK, 'iam.1'))
    print("Executing check iam.2")
    conn.cursor().execute(iam.POLICIES_ATTACHED_TO_GROUPS_ROLES, (execution_time, FRAMEWORK, 'iam.2'))
    print("Executing check iam.3")
    conn.cursor().execute(iam.IAM_ACCESS_KEYS_ROTATED_MORE_THAN_90_DAYS, (execution_time, FRAMEWORK, 'iam.3'))
    print("Executing check iam.4")
    conn.cursor().execute(iam.ROOT_USER_NO_ACCESS_KEYS, (execution_time, FRAMEWORK, 'iam.4'))
    print("Executing check iam.5")
    conn.cursor().execute(iam.MFA_ENABLED_FOR_CONSOLE_ACCESS, (execution_time, FRAMEWORK, 'iam.5'))
    print("Executing check iam.6")
    conn.cursor().execute(iam.HARDWARE_MFA_ENABLED_FOR_ROOT, (execution_time, FRAMEWORK, 'iam.6'))
    print("Executing check iam.7")
    conn.cursor().execute(iam.PASSWORD_POLICY_STRONG, (execution_time, FRAMEWORK, 'iam.7'))
    print("Executing check iam.8")
    conn.cursor().execute(iam.IAM_ACCESS_KEYS_ROTATED_MORE_THAN_90_DAYS, (execution_time, FRAMEWORK, 'iam.8'))

def execute_lambda(conn: SnowflakeConnection, execution_time: datetime.datetime):
    print("Running section: Lambda")
    print("Executing check lambda.2")
    conn.cursor().execute(awslambda.LAMBDA_FUNCTIONS_SHOULD_USE_SUPPORTED_RUNTIMES, (execution_time, FRAMEWORK, 'lambda.2'))

def execute_s3(conn: SnowflakeConnection, execution_time: datetime.datetime):
    print("Running section: S3")
    print("Executing check S3.1")
    conn.cursor().execute(s3.ACCOUNT_LEVEL_PUBLIC_ACCESS_BLOCKS, (execution_time, FRAMEWORK, 'S3.1'))
    print("Executing check S3.2")
    conn.cursor().execute(s3.PUBLICLY_READABLE_BUCKETS, (execution_time, FRAMEWORK, 'S3.2'))
    print("Executing check S3.3")
    conn.cursor().execute(s3.PUBLICLY_WRITABLE_BUCKETS, (execution_time, FRAMEWORK, 'S3.3'))
    print("Executing check S3.4")
    conn.cursor().execute(s3.S3_SERVER_SIDE_ENCRYPTION_ENABLED, (execution_time, FRAMEWORK, 'S3.4'))
    print("Executing check S3.5")
    conn.cursor().execute(s3.DENY_HTTP_REQUESTS, (execution_time, FRAMEWORK, 'S3.5'))
    print("Executing check S3.6")
    conn.cursor().execute(s3.RESTRICT_CROSS_ACCOUNT_ACTIONS, (execution_time, FRAMEWORK, 'S3.6'))
    print("Executing check S3.8")
    conn.cursor().execute(s3.ACCOUNT_LEVEL_PUBLIC_ACCESS_BLOCKS, (execution_time, FRAMEWORK, 'S3.8'))

def execute_sagemaker(conn: SnowflakeConnection, execution_time: datetime.datetime):
    print("Running section: SageMaker")
    print("Executing check SageMaker.1")
    conn.cursor().execute(sagemaker.SAGEMAKER_NOTEBOOK_INSTANCE_DIRECT_INTERNET_ACCESS_DISABLED, (execution_time, FRAMEWORK, 'SageMaker.1'))

def execute_secretsmanager(conn: SnowflakeConnection, execution_time: datetime.datetime):
    print("Running section: SecretsManager")
    print("Executing check SecretsManager.1")
    conn.cursor().execute(secretmanager.SECRETS_SHOULD_HAVE_AUTOMATIC_ROTATION_ENABLED, (execution_time, FRAMEWORK, 'SecretsManager.1'))
    print("Executing check SecretsManager.2")
    conn.cursor().execute(secretmanager.SECRETS_CONFIGURED_WITH_AUTOMATIC_ROTATION_SHOULD_ROTATE_SUCCESSFULLY, (execution_time, FRAMEWORK, 'SecretsManager.2'))
    print("Executing check SecretsManager.3")
    conn.cursor().execute(secretmanager.REMOVE_UNUSED_SECRETS_MANAGER_SECRETS, (execution_time, FRAMEWORK, 'SecretsManager.3'))
    print("Executing check SecretsManager.4")
    conn.cursor().execute(secretmanager.SECRETS_SHOULD_BE_ROTATED_WITHIN_A_SPECIFIED_NUMBER_OF_DAYS, (execution_time, FRAMEWORK, 'SecretsManager.4'))

def execute_sns(conn: SnowflakeConnection, execution_time: datetime.datetime):
    print("Running section: SNS")
    print("Executing check SNS.1")
    conn.cursor().execute(sns.SNS_TOPICS_SHOULD_BE_ENCRYPTED_AT_REST_USING_AWS_KMS, (execution_time, FRAMEWORK, 'SNS.1'))
    print("Executing check SNS.2")
    conn.cursor().execute(sns.SNS_TOPICS_SHOULD_HAVE_MESSAGE_DELIVERY_NOTIFICATION_ENABLED, (execution_time, FRAMEWORK, 'SNS.2'))

def execute_sqs(conn: SnowflakeConnection, execution_time: datetime.datetime):
    print("Running section: SQS")
    print("Executing check SQS.1")
    conn.cursor().execute(sqs.SQS_QUEUES_SHOULD_BE_ENCRYPTED_AT_REST, (execution_time, FRAMEWORK, 'SQS.1'))

def execute_ssm(conn: SnowflakeConnection, execution_time: datetime.datetime):
    print("Running section: SSM")
    print("Executing check SSM.1")
    conn.cursor().execute(ssm.EC2_INSTANCES_SHOULD_BE_MANAGED_BY_SSM, (execution_time, FRAMEWORK, 'SSM.1'))
    print("Executing check SSM.2")
    conn.cursor().execute(ssm.INSTANCES_SHOULD_HAVE_PATCH_COMPLIANCE_STATUS_OF_COMPLIANT, (execution_time, FRAMEWORK, 'SSM.2'))
    print("Executing check SSM.3")
    conn.cursor().execute(ssm.INSTANCES_SHOULD_HAVE_ASSOCIATION_COMPLIANCE_STATUS_OF_COMPLIANT, (execution_time, FRAMEWORK, 'SSM.3'))
    print("Executing check SSM.4")
    conn.cursor().execute(ssm.DOCUMENTS_SHOULD_NOT_BE_PUBLIC, (execution_time, FRAMEWORK, 'SSM.4'))

def execute_waf(conn: SnowflakeConnection, execution_time: datetime.datetime):
    print("Running section: WAF")
    print("Executing check WAF.1")
    conn.cursor().execute(waf.WAF_WEB_ACL_LOGGING_SHOULD_BE_ENABLED, (execution_time, FRAMEWORK, 'WAF.1'))
