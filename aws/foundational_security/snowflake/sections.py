
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
    print("Executing check EC2.2")
    conn.cursor().execute(ec2.DEFAULT_SG_NO_ACCESS, (execution_time, FRAMEWORK, 'EC2.2'))
    print("Executing check EC2.3")
    conn.cursor().execute(ec2.UNENCRYPTED_EBS_VOLUMES, (execution_time, FRAMEWORK, 'EC2.3'))
    print("Executing check EC2.4")
    conn.cursor().execute(ec2.STOPPED_MORE_THAN_30_DAYS_AGO_INSTANCES, (execution_time, FRAMEWORK, 'EC2.4'))
    print("Executing check EC2.6")
    conn.cursor().execute(ec2.FLOW_LOGS_ENABLED_IN_ALL_VPCS, (execution_time, FRAMEWORK, 'EC2.6'))
    print("Executing check EC2.7")
    conn.cursor().execute(ec2.EBS_ENCRYPTION_BY_DEFAULT_DISABLED, (execution_time, FRAMEWORK, 'EC2.7'))
    print("Executing check EC2.8")
    conn.cursor().execute(ec2.NOT_IMDSV2_INSTANCES, (execution_time, FRAMEWORK, 'EC2.8'))
    print("Executing check EC2.9")
    conn.cursor().execute(ec2.INSTANCES_WITH_PUBLIC_IP, (execution_time, FRAMEWORK, 'EC2.9'))
    print("Executing check EC2.10")
    conn.cursor().execute(ec2.VPCS_WITHOUT_EC2_ENDPOINT, (execution_time, FRAMEWORK, 'EC2.10'))
    print("Executing check EC2.15")
    conn.cursor().execute(ec2.SUBNETS_THAT_ASSIGN_PUBLIC_IPS, (execution_time, FRAMEWORK, 'EC2.15'))
    print("Executing check EC2.16")
    conn.cursor().execute(ec2.UNUSED_ACLS, (execution_time, FRAMEWORK, 'EC2.16'))
    print("Executing check EC2.17")
    conn.cursor().execute(ec2.INSTANCES_WITH_MORE_THAN_2_NETWORK_INTERFACES, (execution_time, FRAMEWORK, 'EC2.17'))
    print("Executing check EC2.18")
    conn.cursor().execute(ec2.SECURITY_GROUPS_WITH_ACCESS_TO_UNAUTHORIZED_PORTS, (execution_time, FRAMEWORK, 'EC2.18'))
    print("Executing check EC2.19")
    conn.cursor().execute(ec2.SECURITY_GROUPS_WITH_OPEN_CRITICAL_PORTS, (execution_time, FRAMEWORK, 'EC2.19'))

def execute_ecs(conn: SnowflakeConnection, execution_time: datetime.datetime):
    print("Running section: ECS")
    print("Executing check ECS.1")
    conn.cursor().execute(ecs.TASK_DEFINITIONS_SECURE_NETWORKING, (execution_time, FRAMEWORK, 'ECS.1'))
    print("Executing check ECS.2")
    conn.cursor().execute(ecs.ECS_SERVICES_WITH_PUBLIC_IPS, (execution_time, FRAMEWORK, 'ECS.2'))

def execute_efs(conn: SnowflakeConnection, execution_time: datetime.datetime):
    print("Running section: EFS")
    print("Executing check EFS.1")
    conn.cursor().execute(efs.UNENCRYPTED_EFS_FILESYSTEMS, (execution_time, FRAMEWORK, 'EFS.1'))
    print("Executing check EFS.2")
    conn.cursor().execute(efs.EFS_FILESYSTEMS_WITH_DISABLED_BACKUPS, (execution_time, FRAMEWORK, 'EFS.2'))

def execute_elastic_beanstalk(conn: SnowflakeConnection, execution_time: datetime.datetime):
    print("Running section: Elastic Beanstalk")
    print("Executing check ElasticBeanstalk.1")
    conn.cursor().execute(elastic_beanstalk.ADVANCED_HEALTH_REPORTING_ENABLED, (execution_time, FRAMEWORK, 'elastic_beanstalk.1'))
    print("Executing check ElasticBeanstalk.2")
    conn.cursor().execute(elastic_beanstalk.ELASTIC_BEANSTALK_MANAGED_UPDATES_ENABLED, (execution_time, FRAMEWORK, 'elastic_beanstalk.2'))

def execute_elasticsearch(conn: SnowflakeConnection, execution_time: datetime.datetime):
    print("Running section: Elasticsearch")
    print("Executing check Elasticsearch.1")
    conn.cursor().execute(elasticsearch.ELASTICSEARCH_DOMAINS_SHOULD_HAVE_ENCRYPTION_AT_REST_ENABLED, (execution_time, FRAMEWORK, 'Elasticsearch.1'))
    print("Executing check Elasticsearch.2")
    conn.cursor().execute(elasticsearch.ELASTICSEARCH_DOMAINS_SHOULD_BE_IN_VPC, (execution_time, FRAMEWORK, 'Elasticsearch.2'))
    print("Executing check Elasticsearch.3")
    conn.cursor().execute(elasticsearch.ELASTICSEARCH_DOMAINS_SHOULD_ENCRYPT_DATA_SENT_BETWEEN_NODES, (execution_time, FRAMEWORK, 'Elasticsearch.3'))
    print("Executing check Elasticsearch.4")
    conn.cursor().execute(elasticsearch.ELASTICSEARCH_DOMAIN_ERROR_LOGGING_TO_CLOUDWATCH_LOGS_SHOULD_BE_ENABLED, (execution_time, FRAMEWORK, 'Elasticsearch.4'))
    print("Executing check Elasticsearch.5")
    conn.cursor().execute(elasticsearch.ELASTICSEARCH_DOMAINS_SHOULD_HAVE_AUDIT_LOGGING_ENABLED, (execution_time, FRAMEWORK, 'Elasticsearch.5'))
    print("Executing check Elasticsearch.6")
    conn.cursor().execute(elasticsearch.ELASTICSEARCH_DOMAINS_SHOULD_HAVE_AT_LEAST_THREE_DATA_NODES, (execution_time, FRAMEWORK, 'Elasticsearch.6'))
    print("Executing check Elasticsearch.7")
    conn.cursor().execute(elasticsearch.ELASTICSEARCH_DOMAINS_SHOULD_BE_CONFIGURED_WITH_AT_LEAST_THREE_DEDICATED_MASTER_NODES, (execution_time, FRAMEWORK, 'Elasticsearch.7'))
    print("Executing check Elasticsearch.8")
    conn.cursor().execute(elasticsearch.CONNECTIONS_TO_ELASTICSEARCH_DOMAINS_SHOULD_BE_ENCRYPTED_USING_TLS_1_2, (execution_time, FRAMEWORK, 'Elasticsearch.8'))

def execute_elb(conn: SnowflakeConnection, execution_time: datetime.datetime):
    print("Running section: ELB")
    print("Executing check ELB.2")
    conn.cursor().execute(elb.ELBV1_CERT_PROVIDED_BY_ACM, (execution_time, FRAMEWORK, 'ELB.2'))
    print("Executing check ELB.3")
    conn.cursor().execute(elb.ELBV1_HTTPS_OR_TLS, (execution_time, FRAMEWORK, 'ELB.3'))
    print("Executing check ELB.4")
    conn.cursor().execute(elb.ALB_DROP_HTTP_HEADERS, (execution_time, FRAMEWORK, 'ELB.4'))
    print("Executing check ELB.5")
    conn.cursor().execute(elb.ALB_LOGGING_ENABLED, (execution_time, FRAMEWORK, 'ELB.5', execution_time, FRAMEWORK, 'ELB.5'))
    print("Executing check ELB.6")
    conn.cursor().execute(elb.ALB_DELETION_PROTECTION_ENABLED, (execution_time, FRAMEWORK, 'ELB.6'))
    print("Executing check ELB.7")
    conn.cursor().execute(elb.ELBV1_CONN_DRAINING_ENABLED, (execution_time, FRAMEWORK, 'ELB.7'))
    print("Executing check ELB.8")
    conn.cursor().execute(elb.ELBV1_HTTPS_PREDEFINED_POLICY, (execution_time, FRAMEWORK, 'ELB.8'))

def execute_elbv2(conn: SnowflakeConnection, execution_time: datetime.datetime):
    print("Running section: ELBv2")
    print("Executing check ELBv2.1")
    conn.cursor().execute(elbv2.ELBV2_REDIRECT_HTTP_TO_HTTPS, (execution_time, FRAMEWORK, 'ELBv2.1'))

def execute_emr(conn: SnowflakeConnection, execution_time: datetime.datetime):
    print("Running section: EMR")
    print("Executing check EMR.1")
    conn.cursor().execute(emr.EMR_CLUSTER_MASTER_NODES_SHOULD_NOT_HAVE_PUBLIC_IP_ADDRESSES, (execution_time, FRAMEWORK, 'EMR.1'))

def execute_guardduty(conn: SnowflakeConnection, execution_time: datetime.datetime):
    print("Running section: GuardDuty")
    print("Executing check GuardDuty.1")
    conn.cursor().execute(guardduty.DETECTOR_ENABLED, (execution_time, FRAMEWORK, 'GuardDuty.1', execution_time, FRAMEWORK, 'GuardDuty.1'))

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

def execute_redshift(conn: SnowflakeConnection, execution_time: datetime.datetime):
    print("Running section: Redshift")
    print("Executing check Redshift.1")
    conn.cursor().execute(redshift.CLUSTER_PUBLICLY_ACCESSIBLE, (execution_time, FRAMEWORK, 'Redshift.1'))
    print("Executing check Redshift.2")
    conn.cursor().execute(redshift.CLUSTERS_SHOULD_BE_ENCRYPTED_IN_TRANSIT, (execution_time, FRAMEWORK, 'Redshift.2'))
    print("Executing check Redshift.3")
    conn.cursor().execute(redshift.CLUSTERS_SHOULD_HAVE_AUTOMATIC_SNAPSHOTS_ENABLED, (execution_time, FRAMEWORK, 'Redshift.3'))
    print("Executing check Redshift.4")
    conn.cursor().execute(redshift.CLUSTERS_SHOULD_HAVE_AUDIT_LOGGING_ENABLED, (execution_time, FRAMEWORK, 'Redshift.4'))
    print("Executing check Redshift.6")
    conn.cursor().execute(redshift.CLUSTERS_SHOULD_HAVE_AUTOMATIC_UPGRADES_TO_MAJOR_VERSIONS_ENABLED, (execution_time, FRAMEWORK, 'Redshift.6'))
    print("Executing check Redshift.7")
    conn.cursor().execute(redshift.CLUSTERS_SHOULD_USE_ENHANCED_VPC_ROUTING, (execution_time, FRAMEWORK, 'Redshift.7'))

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
def execute_rds(conn: SnowflakeConnection, execution_time: datetime.datetime):
    print("Running section: RDS")
    print("Executing check rds.2")
    conn.cursor().execute(rds.INSTANCES_SHOULD_PROHIBIT_PUBLIC_ACCESS, (execution_time, FRAMEWORK, 'rds.2'))
    print("Executing check rds.3")
    conn.cursor().execute(rds.INSTANCES_SHOULD_HAVE_ECNRYPTION_AT_REST_ENABLED, (execution_time, FRAMEWORK, 'rds.3'))
    print("Executing check rds.4")
    conn.cursor().execute(rds.CLUSTER_SNAPSHOTS_AND_DATABASE_SNAPSHOTS_SHOULD_BE_ENCRYPTED_AT_REST, (execution_time, FRAMEWORK, 'rds.4', execution_time, FRAMEWORK, 'rds.4'))
    print("Executing check rds.5")
    conn.cursor().execute(rds.INSTANCES_SHOULD_BE_CONFIGURED_WITH_MULTIPLE_AZS, (execution_time, FRAMEWORK, 'rds.5'))
    print("Executing check rds.6")
    conn.cursor().execute(rds.ENHANCED_MONITORING_SHOULD_BE_CONFIGURED_FOR_INSTANCES_AND_CLUSTERS, (execution_time, FRAMEWORK, 'rds.6'))
    print("Executing check rds.7")
    conn.cursor().execute(rds.CLUSTERS_SHOULD_HAVE_DELETION_PROTECTION_ENABLED, (execution_time, FRAMEWORK, 'rds.7'))
    print("Executing check rds.8")
    conn.cursor().execute(rds.INSTANCES_SHOULD_HAVE_DELETION_PROTECTION_ENABLED, (execution_time, FRAMEWORK, 'rds.8'))
    print("Executing check rds.9")
    conn.cursor().execute(rds.DATABASE_LOGGING_SHOULD_BE_ENABLED, (execution_time, FRAMEWORK, 'rds.9'))
    print("Executing check rds.10")
    conn.cursor().execute(rds.IAM_AUTHENTICATION_SHOULD_BE_CONFIGURED_FOR_RDS_INSTANCES, (execution_time, FRAMEWORK, 'rds.10'))
    print("Executing check rds.12")
    conn.cursor().execute(rds.IAM_AUTHENTICATION_SHOULD_BE_CONFIGURED_FOR_RDS_CLUSTERS, (execution_time, FRAMEWORK, 'rds.12'))
    print("Executing check rds.13")
    conn.cursor().execute(rds.RDS_AUTOMATIC_MINOR_VERSION_UPGRADES_SHOULD_BE_ENABLED, (execution_time, FRAMEWORK, 'rds.13'))
    print("Executing check rds.14")
    conn.cursor().execute(rds.AMAZON_AURORA_CLUSTERS_SHOULD_HAVE_BACKTRACKING_ENABLED, (execution_time, FRAMEWORK, 'rds.14'))
    print("Executing check rds.15")
    conn.cursor().execute(rds.CLUSTERS_SHOULD_BE_CONFIGURED_FOR_MULTIPLE_AVAILABILITY_ZONES, (execution_time, FRAMEWORK, 'rds.15'))
    print("Executing check rds.16")
    conn.cursor().execute(rds.CLUSTERS_SHOULD_BE_CONFIGURED_TO_COPY_TAGS_TO_SNAPSHOTS, (execution_time, FRAMEWORK, 'rds.16'))
    print("Executing check rds.17")
    conn.cursor().execute(rds.INSTANCES_SHOULD_BE_CONFIGURED_TO_COPY_TAGS_TO_SNAPSHOTS, (execution_time, FRAMEWORK, 'rds.17'))
    print("Executing check rds.18")
    conn.cursor().execute(rds.INSTANCES_SHOULD_BE_DEPLOYED_IN_A_VPC, (execution_time, FRAMEWORK, 'rds.18'))
    print("Executing check rds.19")
    conn.cursor().execute(rds.INSTANCES_SHOULD_BE_DEPLOYED_IN_A_VPC, (execution_time, FRAMEWORK, 'rds.18'))
    print("Executing check rds.23")
    conn.cursor().execute(rds.DATABASES_AND_CLUSTERS_SHOULD_NOT_USE_DATABASE_ENGINE_DEFAULT_PORT, (execution_time, FRAMEWORK, 'rds.23', execution_time, FRAMEWORK, 'rds.23'))
