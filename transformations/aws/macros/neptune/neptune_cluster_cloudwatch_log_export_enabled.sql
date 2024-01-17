{% macro neptune_cluster_cloudwatch_log_export_enabled(framework, check_id) %}
  {{ return(adapter.dispatch('neptune_cluster_cloudwatch_log_export_enabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__neptune_cluster_cloudwatch_log_export_enabled(framework, check_id) %}{% endmacro %}

{% macro postgres__neptune_cluster_cloudwatch_log_export_enabled(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Neptune DB clusters should publish audit logs to CloudWatch Logs' as title,
    account_id,
    arn as resource_id,
    case when
         ARRAY['audit'] <@ ENABLED_CLOUDWATCH_LOGS_EXPORTS then 'pass'
    else 'fail'
    end as status
from 
    aws_neptune_clusters
{% endmacro %}

{% macro snowflake__neptune_cluster_cloudwatch_log_export_enabled(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Neptune DB clusters should publish audit logs to CloudWatch Logs' as title,
    account_id,
    arn as resource_id,
    case when
         ARRAY_CONTAINS('audit'::variant, ENABLED_CLOUDWATCH_LOGS_EXPORTS) then 'pass'
    else 'fail'
    end as status
from 
    aws_neptune_clusters
{% endmacro %}