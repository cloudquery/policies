ELASTICSEARCH_DOMAINS_SHOULD_HAVE_ENCRYPTION_AT_REST_ENABLED = """
insert into aws_policy_results
select
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'Elasticsearch domains should have encryption at rest enabled' as title,
  account_id,
  arn as resource_id,
  case when
        (encryption_at_rest_options:Enabled)::boolean is distinct from true
    then 'fail'
    else 'pass'
  end as status
from aws_elasticsearch_domains
"""

ELASTICSEARCH_DOMAINS_SHOULD_BE_IN_VPC = """
insert into aws_policy_results
select
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'Elasticsearch domains should be in a VPC' as title,
  account_id,
  arn as resource_id,
  case when
    vpc_options:VPCId is null
    then 'fail'
    else 'pass'
  end as status
from aws_elasticsearch_domains
"""

ELASTICSEARCH_DOMAINS_SHOULD_ENCRYPT_DATA_SENT_BETWEEN_NODES = """
insert into aws_policy_results
select
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'Elasticsearch domains should encrypt data sent between nodes' as title,
  account_id,
  arn as resource_id,
  case when
        (node_to_node_encryption_options:Enabled)::boolean is distinct from true
    then 'fail'
    else 'pass'
  end as status
from aws_elasticsearch_domains
"""

ELASTICSEARCH_DOMAIN_ERROR_LOGGING_TO_CLOUDWATCH_LOGS_SHOULD_BE_ENABLED = """
insert into aws_policy_results
SELECT
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'Elasticsearch domain error logging to CloudWatch Logs should be enabled' as title,
  account_id,
  arn as resource_id,
  case when
    (log_publishing_options:ES_APPLICATION_LOGS:Enabled)::boolean is distinct from true
    OR log_publishing_options:ES_APPLICATION_LOGS:CloudWatchLogsLogGroupArn IS NULL
    then 'fail'
    else 'pass'
  end as status
FROM aws_elasticsearch_domains
"""

ELASTICSEARCH_DOMAINS_SHOULD_HAVE_AUDIT_LOGGING_ENABLED = """
insert into aws_policy_results
select
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'Elasticsearch domains should have audit logging enabled' as title,
  account_id,
  arn as resource_id,
  case when
    (log_publishing_options:AUDIT_LOGS:Enabled)::boolean is distinct from true
    or log_publishing_options:AUDIT_LOGS:CloudWatchLogsLogGroupArn is null
    then 'fail'
    else 'pass'
  end as status
from aws_elasticsearch_domains
"""

ELASTICSEARCH_DOMAINS_SHOULD_HAVE_AT_LEAST_THREE_DATA_NODES = """
insert into aws_policy_results
select
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'Elasticsearch domains should have at least three data nodes' as title,
  account_id,
  arn as resource_id,
  case when
    not (elasticsearch_cluster_config:ZoneAwarenessEnabled)::boolean
    or (elasticsearch_cluster_config:InstanceCount)::integer is null
    or (elasticsearch_cluster_config:InstanceCount)::integer < 3
    then 'fail'
    else 'pass'
  end as status
from aws_elasticsearch_domains
"""

ELASTICSEARCH_DOMAINS_SHOULD_BE_CONFIGURED_WITH_AT_LEAST_THREE_DEDICATED_MASTER_NODES = """
insert into aws_policy_results
select
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'Elasticsearch domains should be configured with at least three dedicated master nodes' as title,
  account_id,
  arn as resource_id,
  case when
    (elasticsearch_cluster_config:DedicatedMasterEnabled)::boolean is distinct from true
    or (elasticsearch_cluster_config:DedicatedMasterCount)::integer is null
    or (elasticsearch_cluster_config:DedicatedMasterCount)::integer < 3
    then 'fail'
    else 'pass'
  end as status
from aws_elasticsearch_domains
"""

CONNECTIONS_TO_ELASTICSEARCH_DOMAINS_SHOULD_BE_ENCRYPTED_USING_TLS_1_2 = """
insert into aws_policy_results
select
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'Connections to Elasticsearch domains should be encrypted using TLS 1.2' as title,
  account_id,
  arn as resource_id,
  case when
    domain_endpoint_options:TLSSecurityPolicy is distinct from 'Policy-Min-TLS-1-2-2019-07'
    then 'fail'
    else 'pass'
  end as status
from aws_elasticsearch_domains
"""