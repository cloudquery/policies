
import datetime
from queries import (
    account,
    acm,
    apigateway,
    awsconfig,
    cloudfront,
    cloudtrail,
    codebuild,
    dms,
    dynamodb,ec2,
    ecs,
    efs,
    elastic_beanstalk,
    elasticsearch,
    elb,
    elbv2,
    emr,
    guardduty,
    iam,
    awslambda,
    redshift,
    s3,
    sagemaker,
    secretmanager,
    sns,
    sqs,
    ssm,
    waf,
    rds,
)
from snowflake.connector import SnowflakeConnection
import re

FRAMEWORK = 'Foundational Security Policy'

def contains_where_tag(s):
    return bool(re.search(r'\$where(:[^$]+)?\$', s))

def replace_where(subject, input_str):
    # Check for $where:<str>$ pattern
    where_param_match = re.search(r'\$where:([^$]+)\$', subject)
    if where_param_match:
        where_param = where_param_match.group(1)
        # Replace 't.' with '<str>.'
        replaced_input = re.sub(r'\bt\.', f'{where_param}.', input_str)
        # Replace '$where:<str>$' with replaced_input
        subject = re.sub(r'\$where:[^$]+\$', replaced_input, subject)

    # Check for $where$ pattern
    if '$where$' in subject:
        # Remove 't.' prefix
        replaced_input = re.sub(r'\bt\.', '', input_str)
        # Replace '$where$' with replaced_input
        subject = re.sub(r'\$where\$', replaced_input, subject)

    return subject

def exec(conn, query, execution_time: datetime.datetime, where, check_id):
    if not contains_where_tag(query):
        raise Exception(f'Query ({check_id}) does not contain $where$ or $where:<str>$ tag: {query}')

    q = replace_where(query, where)
    conn.cursor().execute(q, (execution_time, FRAMEWORK, check_id))

def execute_account(conn: SnowflakeConnection, execution_time: datetime.datetime, where):
    print("Running section: account")
    print("Running check: account.1")
    exec(conn, account.SECURITY_ACCOUNT_INFORMATION_PROVIDED, execution_time, where, 'account.1')

def execute_acm(conn: SnowflakeConnection, execution_time: datetime.datetime, where):
    print("Running section: acm")
    print("Running check: acm.1")
    exec(conn, acm.CERTIFICATES_SHOULD_BE_RENEWED, execution_time, where, 'acm.1')
    print("Running check: acm.2")
    exec(conn, acm.RSA_CERTIFICATE_KEY_LENGTH_SHOULD_BE_MORE_THAN_2048_BITS, execution_time, where, 'acm.2')

def execute_apigateway(conn: SnowflakeConnection, execution_time: datetime.datetime, where):
    print("Running section: apigateway")
    print("Running check: apigateway.1")
    exec(conn, apigateway.API_GW_EXECUTION_LOGGING_ENABLED, execution_time, where, 'apigateway.1')

def execute_awsconfig(conn: SnowflakeConnection, execution_time: datetime.datetime, where):
    print("Running section: aws_config")
    print("Running check: aws_config.1")
    exec(conn, awsconfig.ENABLED_ALL_REGIONS, execution_time, where, 'awsconfig.1')

def execute_cloudfront(conn: SnowflakeConnection, execution_time: datetime.datetime, where):
    print("Running section: cloudfront")
    print("Running check: cloudfront.1")
    exec(conn, cloudfront.DEFAULT_ROOT_OBJECT_CONFIGURED, execution_time, where, 'cloudfront.1')
    print("Running check: cloudfront.2")
    exec(conn, cloudfront.ORIGIN_ACCESS_IDENTITY_ENABLED, execution_time, where, 'cloudfront.2')
    print("Running check: cloudfront.3")
    exec(conn, cloudfront.VIEWER_POLICY_HTTPS, execution_time, where, 'cloudfront.3')
    print("Running check: cloudfront.4")
    exec(conn, cloudfront.ORIGIN_FAILOVER_ENABLED, execution_time, where, 'cloudfront.4')
    print("Running check: cloudfront.5")
    exec(conn, cloudfront.ACCESS_LOGS_ENABLED, execution_time, where, 'cloudfront.5')
    print("Running check: cloudfront.6")
    exec(conn, cloudfront.ASSOCIATED_WITH_WAF, execution_time, where, 'cloudfront.6')

def execute_cloudtrail(conn: SnowflakeConnection, execution_time: datetime.datetime, where):
    print("Running section: cloudtrail")
    print("Running check: cloudtrail.1")
    exec(conn, cloudtrail.ENABLED_ALL_REGIONS, execution_time, where, 'cloudtrail.1')
    print("Running check: cloudtrail.2")
    exec(conn, cloudtrail.LOGS_ENCRYPTED, execution_time, where, 'cloudtrail.2')
    print("Running check: cloudtrail.3")
    exec(conn, cloudtrail.LOGS_FILE_VALIDATION_ENABLED, execution_time, where, 'cloudtrail.3')
    print("Running check: cloudtrail.4")
    exec(conn, cloudtrail.LOGS_FILE_VALIDATION_ENABLED, execution_time, where, 'cloudtrail.4')
    print("Running check: cloudtrail.5")
    exec(conn, cloudtrail.INTEGRATED_WITH_CLOUDWATCH_LOGS, execution_time, where, 'cloudtrail.5')

def execute_codebuild(conn: SnowflakeConnection, execution_time: datetime.datetime, where):
    print("Running section: codebuild")
    print("Running check: codebuild.1")
    exec(conn, codebuild.CHECK_OAUTH_USAGE_FOR_SOURCES, execution_time, where, 'codebuild.1')
    print("Running check: codebuild.2")
    exec(conn, codebuild.CHECK_ENVIRONMENT_VARIABLES, execution_time, where, 'codebuild.2')

def execute_dms(conn: SnowflakeConnection, execution_time: datetime.datetime, where):
    print("Running section: dms")
    print("Running check: dms.1")
    exec(conn, dms.REPLICATION_NOT_PUBLIC, execution_time, where, 'dms.1')

def execute_dynamodb(conn: SnowflakeConnection, execution_time: datetime.datetime, where):
    print("Running section: dynamodb")
    print("Running check: dynamodb.1")
    exec(conn, dynamodb.AUTOSCALE_OR_ONDEMAND, execution_time, where, 'dynamodb.1')
    print("Running check: dynamodb.2")
    exec(conn, dynamodb.POINT_IN_TIME_RECOVERY, execution_time, where, 'dynamodb.2')
    print("Running check: dynamodb.3")
    exec(conn, dynamodb.DAX_ENCRYPTED_AT_REST, execution_time, where, 'dynamodb.3')

def execute_ec2(conn: SnowflakeConnection, execution_time: datetime.datetime, where):
    print("Running section: ec2")
    print("Executing check ec2.1")
    exec(conn, ec2.EBS_SNAPSHOT_PERMISSIONS_CHECK, execution_time, where, 'ec2.1')
    print("Executing check ec2.2")
    exec(conn, ec2.DEFAULT_SG_NO_ACCESS, execution_time, where, 'ec2.2')
    print("Executing check ec2.3")
    exec(conn, ec2.UNENCRYPTED_EBS_VOLUMES, execution_time, where, 'ec2.3')
    print("Executing check ec2.4")
    exec(conn, ec2.STOPPED_MORE_THAN_30_DAYS_AGO_INSTANCES, execution_time, where, 'ec2.4')
    print("Executing check ec2.6")
    exec(conn, ec2.FLOW_LOGS_ENABLED_IN_ALL_VPCS, execution_time, where, 'ec2.6')
    print("Executing check ec2.7")
    exec(conn, ec2.EBS_ENCRYPTION_BY_DEFAULT_DISABLED, execution_time, where, 'ec2.7')
    print("Executing check ec2.8")
    exec(conn, ec2.NOT_IMDSV2_INSTANCES, execution_time, where, 'ec2.8')
    print("Executing check ec2.9")
    exec(conn, ec2.INSTANCES_WITH_PUBLIC_IP, execution_time, where, 'ec2.9')
    print("Executing check ec2.10")
    exec(conn, ec2.VPCS_WITHOUT_EC2_ENDPOINT, execution_time, where, 'EC2.10')
    print("Executing check ec2.15")
    exec(conn, ec2.SUBNETS_THAT_ASSIGN_PUBLIC_IPS, execution_time, where, 'ec2.15')
    print("Executing check ec2.16")
    exec(conn, ec2.UNUSED_ACLS, execution_time, where, 'ec2.16')
    print("Executing check ec2.17")
    exec(conn, ec2.INSTANCES_WITH_MORE_THAN_2_NETWORK_INTERFACES, execution_time, where, 'ec2.17')
    print("Executing check ec2.18")
    exec(conn, ec2.SECURITY_GROUPS_WITH_ACCESS_TO_UNAUTHORIZED_PORTS, execution_time, where, 'ec2.18')
    print("Executing check ec2.19")
    exec(conn, ec2.SECURITY_GROUPS_WITH_OPEN_CRITICAL_PORTS, execution_time, where, 'ec2.19')

def execute_ecs(conn: SnowflakeConnection, execution_time: datetime.datetime, where):
    print("Running section: ecs")
    print("Executing check ecs.1")
    exec(conn, ecs.TASK_DEFINITIONS_SECURE_NETWORKING, execution_time, where, 'ecs.1')
    print("Executing check ecs.2")
    exec(conn, ecs.ECS_SERVICES_WITH_PUBLIC_IPS, execution_time, where, 'ecs.2')

def execute_efs(conn: SnowflakeConnection, execution_time: datetime.datetime, where):
    print("Running section: efs")
    print("Executing check efs.1")
    exec(conn, efs.UNENCRYPTED_EFS_FILESYSTEMS, execution_time, where, 'efs.1')
    print("Executing check efs.2")
    exec(conn, efs.EFS_FILESYSTEMS_WITH_DISABLED_BACKUPS, execution_time, where, 'efs.2')

def execute_elastic_beanstalk(conn: SnowflakeConnection, execution_time: datetime.datetime, where):
    print("Running section: elastic_beanstalk")
    print("Executing check elastic_beanstalk.1")
    exec(conn, elastic_beanstalk.ADVANCED_HEALTH_REPORTING_ENABLED, execution_time, where, 'elastic_beanstalk.1')
    print("Executing check elastic_beanstalk.2")
    exec(conn, elastic_beanstalk.ELASTIC_BEANSTALK_MANAGED_UPDATES_ENABLED, execution_time, where, 'elastic_beanstalk.2')

def execute_elasticsearch(conn: SnowflakeConnection, execution_time: datetime.datetime, where):
    print("Running section: elastic_search")
    print("Executing check elastic_search.1")
    exec(conn, elasticsearch.ELASTICSEARCH_DOMAINS_SHOULD_HAVE_ENCRYPTION_AT_REST_ENABLED, execution_time, where, 'elastic_search.1')
    print("Executing check elastic_search.2")
    exec(conn, elasticsearch.ELASTICSEARCH_DOMAINS_SHOULD_BE_IN_VPC, execution_time, where, 'elastic_search.2')
    print("Executing check elastic_search.3")
    exec(conn, elasticsearch.ELASTICSEARCH_DOMAINS_SHOULD_ENCRYPT_DATA_SENT_BETWEEN_NODES, execution_time, where, 'elastic_search.3')
    print("Executing check elastic_search.4")
    exec(conn, elasticsearch.ELASTICSEARCH_DOMAIN_ERROR_LOGGING_TO_CLOUDWATCH_LOGS_SHOULD_BE_ENABLED, execution_time, where, 'elastic_search.4')
    print("Executing check elastic_search.5")
    exec(conn, elasticsearch.ELASTICSEARCH_DOMAINS_SHOULD_HAVE_AUDIT_LOGGING_ENABLED, execution_time, where, 'elastic_search.5')
    print("Executing check elastic_search.6")
    exec(conn, elasticsearch.ELASTICSEARCH_DOMAINS_SHOULD_HAVE_AT_LEAST_THREE_DATA_NODES, execution_time, where, 'elastic_search.6')
    print("Executing check elastic_search.7")
    exec(conn, elasticsearch.ELASTICSEARCH_DOMAINS_SHOULD_BE_CONFIGURED_WITH_AT_LEAST_THREE_DEDICATED_MASTER_NODES, execution_time, where, 'elastic_search.7')
    print("Executing check elastic_search.8")
    exec(conn, elasticsearch.CONNECTIONS_TO_ELASTICSEARCH_DOMAINS_SHOULD_BE_ENCRYPTED_USING_TLS_1_2, execution_time, where, 'elastic_search.8')

def execute_elb(conn: SnowflakeConnection, execution_time: datetime.datetime, where):
    print("Running section: elb")
    print("Executing check elb.2")
    exec(conn, elb.ELBV1_CERT_PROVIDED_BY_ACM, execution_time, where, 'elb.2')
    print("Executing check elb.3")
    exec(conn, elb.ELBV1_HTTPS_OR_TLS, execution_time, where, 'elb.3')
    print("Executing check elb.4")
    exec(conn, elb.ALB_DROP_HTTP_HEADERS, execution_time, where, 'elb.4')
    print("Executing check elb.5")
    exec(conn, elb.ALB_LOGGING_ENABLED, execution_time, where, 'elb.5')
    print("Executing check elb.6")
    exec(conn, elb.ALB_DELETION_PROTECTION_ENABLED, execution_time, where, 'elb.6')
    print("Executing check elb.7")
    exec(conn, elb.ELBV1_CONN_DRAINING_ENABLED, execution_time, where, 'elb.7')
    print("Executing check elb.8")
    exec(conn, elb.ELBV1_HTTPS_PREDEFINED_POLICY, execution_time, where, 'elb.8')

def execute_elbv2(conn: SnowflakeConnection, execution_time: datetime.datetime, where):
    print("Running section: elbv2")
    print("Executing check elbv2.1")
    exec(conn, elbv2.ELBV2_REDIRECT_HTTP_TO_HTTPS, execution_time, where, 'elbv2.1')

def execute_emr(conn: SnowflakeConnection, execution_time: datetime.datetime, where):
    print("Running section: emr")
    print("Executing check emr.1")
    exec(conn, emr.EMR_CLUSTER_MASTER_NODES_SHOULD_NOT_HAVE_PUBLIC_IP_ADDRESSES, execution_time, where, 'emr.1')

def execute_guardduty(conn: SnowflakeConnection, execution_time: datetime.datetime, where):
    print("Running section: guarddury")
    print("Executing check guarddury.1")
    exec(conn, guardduty.DETECTOR_ENABLED, execution_time, where, 'guarddury.1')

def execute_iam(conn: SnowflakeConnection, execution_time: datetime.datetime, where):
    print("Running section: iam")
    # print("Executing check iam.1")
    # conn.cursor().execute(iam.POLICIES_WITH_ADMIN_RIGHTS, (execution_time, FRAMEWORK, 'iam.1'))
    print("Executing check iam.2")
    exec(conn, iam.POLICIES_ATTACHED_TO_GROUPS_ROLES, execution_time, where, 'iam.2')
    print("Executing check iam.3")
    exec(conn, iam.IAM_ACCESS_KEYS_ROTATED_MORE_THAN_90_DAYS, execution_time, where, 'iam.3')
    print("Executing check iam.4")
    exec(conn, iam.ROOT_USER_NO_ACCESS_KEYS, execution_time, where, 'iam.4')
    print("Executing check iam.5")
    exec(conn, iam.MFA_ENABLED_FOR_CONSOLE_ACCESS, execution_time, where, 'iam.5')
    print("Executing check iam.6")
    exec(conn, iam.HARDWARE_MFA_ENABLED_FOR_ROOT, execution_time, where, 'iam.6')
    print("Executing check iam.7")
    exec(conn, iam.PASSWORD_POLICY_STRONG, execution_time, where, 'iam.7')
    print("Executing check iam.8")
    exec(conn, iam.IAM_ACCESS_KEYS_ROTATED_MORE_THAN_90_DAYS, execution_time, where, 'iam.8')

def execute_lambda(conn: SnowflakeConnection, execution_time: datetime.datetime, where):
    print("Running section: lambda")
    print("Executing check lambda.2")
    exec(conn, awslambda.LAMBDA_FUNCTIONS_SHOULD_USE_SUPPORTED_RUNTIMES, execution_time, where, 'lambda.2')

def execute_redshift(conn: SnowflakeConnection, execution_time: datetime.datetime, where):
    print("Running section: redshift")
    print("Executing check redshift.1")
    exec(conn, redshift.CLUSTER_PUBLICLY_ACCESSIBLE, execution_time, where, 'redshift.1')
    print("Executing check redshift.2")
    exec(conn, redshift.CLUSTERS_SHOULD_BE_ENCRYPTED_IN_TRANSIT, execution_time, where, 'redshift.2')
    print("Executing check redshift.3")
    exec(conn, redshift.CLUSTERS_SHOULD_HAVE_AUTOMATIC_SNAPSHOTS_ENABLED, execution_time, where, 'redshift.3')
    print("Executing check redshift.4")
    exec(conn, redshift.CLUSTERS_SHOULD_HAVE_AUDIT_LOGGING_ENABLED, execution_time, where, 'redshift.4')
    print("Executing check redshift.6")
    exec(conn, redshift.CLUSTERS_SHOULD_HAVE_AUTOMATIC_UPGRADES_TO_MAJOR_VERSIONS_ENABLED, execution_time, where, 'redshift.6')
    print("Executing check redshift.7")
    exec(conn, redshift.CLUSTERS_SHOULD_USE_ENHANCED_VPC_ROUTING, execution_time, where, 'redshift.7')

def execute_s3(conn: SnowflakeConnection, execution_time: datetime.datetime, where):
    print("Running section: s3")
    print("Executing check s3.1")
    exec(conn, s3.ACCOUNT_LEVEL_PUBLIC_ACCESS_BLOCKS, execution_time, where, 's3.1')
    print("Executing check s3.2")
    exec(conn, s3.PUBLICLY_READABLE_BUCKETS, execution_time, where, 's3.2')
    print("Executing check s3.3")
    exec(conn, s3.PUBLICLY_WRITABLE_BUCKETS, execution_time, where, 's3.3')
    print("Executing check s3.4")
    exec(conn, s3.S3_SERVER_SIDE_ENCRYPTION_ENABLED, execution_time, where, 's3.4')
    print("Executing check s3.5")
    exec(conn, s3.DENY_HTTP_REQUESTS, execution_time, where, 's3.5')
    print("Executing check s3.6")
    exec(conn, s3.RESTRICT_CROSS_ACCOUNT_ACTIONS, execution_time, where, 's3.6')
    print("Executing check s3.8")
    exec(conn, s3.ACCOUNT_LEVEL_PUBLIC_ACCESS_BLOCKS, execution_time, where, 's3.8')

def execute_sagemaker(conn: SnowflakeConnection, execution_time: datetime.datetime, where):
    print("Running section: sagemaker")
    print("Executing check sagemaker.1")
    exec(conn, sagemaker.SAGEMAKER_NOTEBOOK_INSTANCE_DIRECT_INTERNET_ACCESS_DISABLED, execution_time, where, 'sagemaker.1')

def execute_secretsmanager(conn: SnowflakeConnection, execution_time: datetime.datetime, where):
    print("Running section: secretmanager")
    print("Executing check secretmanager.1")
    exec(conn, secretmanager.SECRETS_SHOULD_HAVE_AUTOMATIC_ROTATION_ENABLED, execution_time, where, 'secretmanager.1')
    print("Executing check secretmanager.2")
    exec(conn, secretmanager.SECRETS_CONFIGURED_WITH_AUTOMATIC_ROTATION_SHOULD_ROTATE_SUCCESSFULLY, execution_time, where, 'secretmanager.2')
    print("Executing check secretmanager.3")
    exec(conn, secretmanager.REMOVE_UNUSED_SECRETS_MANAGER_SECRETS, execution_time, where, 'secretmanager.3')
    print("Executing check secretmanager.4")
    exec(conn, secretmanager.SECRETS_SHOULD_BE_ROTATED_WITHIN_A_SPECIFIED_NUMBER_OF_DAYS, execution_time, where, 'secretmanager.4')

def execute_sns(conn: SnowflakeConnection, execution_time: datetime.datetime, where):
    print("Running section: sns")
    print("Executing check sns.1")
    exec(conn, sns.SNS_TOPICS_SHOULD_BE_ENCRYPTED_AT_REST_USING_AWS_KMS, execution_time, where, 'sns.1')
    print("Executing check sns.2")
    exec(conn, sns.SNS_TOPICS_SHOULD_HAVE_MESSAGE_DELIVERY_NOTIFICATION_ENABLED, execution_time, where, 'sns.2')

def execute_sqs(conn: SnowflakeConnection, execution_time: datetime.datetime, where):
    print("Running section: sqs")
    print("Executing check sns.1")
    exec(conn, sqs.SQS_QUEUES_SHOULD_BE_ENCRYPTED_AT_REST, execution_time, where, 'sqs.1')

def execute_ssm(conn: SnowflakeConnection, execution_time: datetime.datetime, where):
    print("Running section: ssm")
    print("Executing check ssm.1")
    exec(conn, ssm.EC2_INSTANCES_SHOULD_BE_MANAGED_BY_SSM, execution_time, where, 'ssm.1')
    print("Executing check ssm.2")
    exec(conn, ssm.INSTANCES_SHOULD_HAVE_PATCH_COMPLIANCE_STATUS_OF_COMPLIANT, execution_time, where, 'ssm.2')
    print("Executing check ssm.3")
    exec(conn, ssm.INSTANCES_SHOULD_HAVE_ASSOCIATION_COMPLIANCE_STATUS_OF_COMPLIANT, execution_time, where, 'ssm.3')
    print("Executing check ssm.4")
    exec(conn, ssm.DOCUMENTS_SHOULD_NOT_BE_PUBLIC, execution_time, where, 'ssm.4')

def execute_waf(conn: SnowflakeConnection, execution_time: datetime.datetime, where):
    print("Running section: waf")
    print("Executing check waf.1")
    exec(conn, waf.WAF_WEB_ACL_LOGGING_SHOULD_BE_ENABLED, execution_time, where, 'waf.1')

def execute_rds(conn: SnowflakeConnection, execution_time: datetime.datetime, where):
    print("Running section: rds")
    print("Executing check rds.2")
    exec(conn, rds.INSTANCES_SHOULD_PROHIBIT_PUBLIC_ACCESS, execution_time, where, 'rds.2')
    print("Executing check rds.3")
    exec(conn, rds.INSTANCES_SHOULD_HAVE_ECNRYPTION_AT_REST_ENABLED, execution_time, where, 'rds.3')
    print("Executing check rds.4")
    exec(conn, rds.CLUSTER_SNAPSHOTS_AND_DATABASE_SNAPSHOTS_SHOULD_BE_ENCRYPTED_AT_REST, execution_time, where, 'rds.4')
    print("Executing check rds.5")
    exec(conn, rds.INSTANCES_SHOULD_BE_CONFIGURED_WITH_MULTIPLE_AZS, execution_time, where, 'rds.5')
    print("Executing check rds.6")
    exec(conn, rds.ENHANCED_MONITORING_SHOULD_BE_CONFIGURED_FOR_INSTANCES_AND_CLUSTERS, execution_time, where, 'rds.6')
    print("Executing check rds.7")
    exec(conn, rds.CLUSTERS_SHOULD_HAVE_DELETION_PROTECTION_ENABLED, execution_time, where, 'rds.7')
    print("Executing check rds.8")
    exec(conn, rds.INSTANCES_SHOULD_HAVE_DELETION_PROTECTION_ENABLED, execution_time, where, 'rds.8')
    print("Executing check rds.9")
    exec(conn, rds.DATABASE_LOGGING_SHOULD_BE_ENABLED, execution_time, where, 'rds.9')
    print("Executing check rds.10")
    exec(conn, rds.IAM_AUTHENTICATION_SHOULD_BE_CONFIGURED_FOR_RDS_INSTANCES, execution_time, where, 'rds.10')
    print("Executing check rds.12")
    exec(conn, rds.IAM_AUTHENTICATION_SHOULD_BE_CONFIGURED_FOR_RDS_CLUSTERS, execution_time, where, 'rds.12')
    print("Executing check rds.13")
    exec(conn, rds.RDS_AUTOMATIC_MINOR_VERSION_UPGRADES_SHOULD_BE_ENABLED, execution_time, where, 'rds.13')
    print("Executing check rds.14")
    exec(conn, rds.AMAZON_AURORA_CLUSTERS_SHOULD_HAVE_BACKTRACKING_ENABLED, execution_time, where, 'rds.14')
    print("Executing check rds.15")
    exec(conn, rds.CLUSTERS_SHOULD_BE_CONFIGURED_FOR_MULTIPLE_AVAILABILITY_ZONES, execution_time, where, 'rds.15')
    print("Executing check rds.16")
    exec(conn, rds.CLUSTERS_SHOULD_BE_CONFIGURED_TO_COPY_TAGS_TO_SNAPSHOTS, execution_time, where, 'rds.16')
    print("Executing check rds.17")
    exec(conn, rds.INSTANCES_SHOULD_BE_CONFIGURED_TO_COPY_TAGS_TO_SNAPSHOTS, execution_time, where, 'rds.17')
    print("Executing check rds.18")
    exec(conn, rds.INSTANCES_SHOULD_BE_DEPLOYED_IN_A_VPC, execution_time, where, 'rds.18')
    print("Executing check rds.19")
    exec(conn, rds.INSTANCES_SHOULD_BE_DEPLOYED_IN_A_VPC, execution_time, where, 'rds.19')
    print("Executing check rds.23")
    exec(conn, rds.DATABASES_AND_CLUSTERS_SHOULD_NOT_USE_DATABASE_ENGINE_DEFAULT_PORT, execution_time, where, 'rds.23')
