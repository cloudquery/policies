{% macro elasticsearch_domain_error_logging_to_cloudwatch_logs_should_be_enabled(framework, check_id) %}
  {{ return(adapter.dispatch('elasticsearch_domain_error_logging_to_cloudwatch_logs_should_be_enabled')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__elasticsearch_domain_error_logging_to_cloudwatch_logs_should_be_enabled(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
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
{% endmacro %}

{% macro postgres__elasticsearch_domain_error_logging_to_cloudwatch_logs_should_be_enabled(framework, check_id) %}
SELECT
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Elasticsearch domain error logging to CloudWatch Logs should be enabled' as title,
  account_id,
  arn as resource_id,
  case when
    log_publishing_options -> 'ES_APPLICATION_LOGS' -> 'Enabled' IS DISTINCT FROM 'true'
    OR log_publishing_options -> 'ES_APPLICATION_LOGS' -> 'CloudWatchLogsLogGroupArn' IS NULL
    then 'fail'
    else 'pass'
  end as status
FROM aws_elasticsearch_domains
{% endmacro %}

{% macro default__elasticsearch_domain_error_logging_to_cloudwatch_logs_should_be_enabled(framework, check_id) %}{% endmacro %}

{% macro bigquery__elasticsearch_domain_error_logging_to_cloudwatch_logs_should_be_enabled(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Elasticsearch domain error logging to CloudWatch Logs should be enabled' as title,
  account_id,
  arn as resource_id,
  case when
    CAST( JSON_VALUE(log_publishing_options.ES_APPLICATION_LOGS.Enabled) AS BOOL) is distinct from true 
    OR log_publishing_options.ES_APPLICATION_LOGS.CloudWatchLogsLogGroupArn IS NULL
    then 'fail'
    else 'pass'
  end as status
FROM {{ full_table_name("aws_elasticsearch_domains") }}
{% endmacro %}