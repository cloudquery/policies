{% macro elasticsearch_domains_should_have_audit_logging_enabled(framework, check_id) %}
  {{ return(adapter.dispatch('elasticsearch_domains_should_have_audit_logging_enabled')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__elasticsearch_domains_should_have_audit_logging_enabled(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
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
{% endmacro %}

{% macro postgres__elasticsearch_domains_should_have_audit_logging_enabled(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Elasticsearch domains should have audit logging enabled' as title,
  account_id,
  arn as resource_id,
  case when
    log_publishing_options -> 'AUDIT_LOGS' -> 'Enabled' is distinct from 'true'
    or log_publishing_options -> 'AUDIT_LOGS' -> 'CloudWatchLogsLogGroupArn' is null
    then 'fail'
    else 'pass'
  end as status
from aws_elasticsearch_domains
{% endmacro %}

{% macro default__elasticsearch_domains_should_have_audit_logging_enabled(framework, check_id) %}{% endmacro %}

{% macro bigquery__elasticsearch_domains_should_have_audit_logging_enabled(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Elasticsearch domains should have audit logging enabled' as title,
  account_id,
  arn as resource_id,
  case when
    CAST( JSON_VALUE(log_publishing_options.AUDIT_LOGS.Enabled) AS BOOL) is distinct from true
    or log_publishing_options.AUDIT_LOGS.CloudWatchLogsLogGroupArn is null
    then 'fail'
    else 'pass'
  end as status
from {{ full_table_name("aws_elasticsearch_domains") }}
{% endmacro %}

{% macro athena__elasticsearch_domains_should_have_audit_logging_enabled(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Elasticsearch domains should have audit logging enabled' as title,
  account_id,
  arn as resource_id,
  case when
    cast(json_extract_scalar(log_publishing_options, '$.AUDIT_LOGS.Enabled') as boolean) is distinct from true
    or json_extract_scalar(log_publishing_options, '$.AUDIT_LOGS.CloudWatchLogsLogGroupArn') is null
    then 'fail'
    else 'pass'
  end as status
from aws_elasticsearch_domains
{% endmacro %}