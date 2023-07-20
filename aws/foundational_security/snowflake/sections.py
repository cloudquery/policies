
import datetime
from queries import account, acm, apigateway, awsconfig, cloudfront, cloudtrail, codebuild, dms, dynamodb, ec2
from snowflake.connector import SnowflakeConnection

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
    print("Executing check EC2.1")
    conn.cursor().execute(ec2.EBS_SNAPSHOT_PERMISSIONS_CHECK, (execution_time, FRAMEWORK, 'EC2.1'))