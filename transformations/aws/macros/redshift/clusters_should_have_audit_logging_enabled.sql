{% macro clusters_should_have_audit_logging_enabled(framework, check_id) %}
  {{ return(adapter.dispatch('clusters_should_have_audit_logging_enabled')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__clusters_should_have_audit_logging_enabled(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Amazon Redshift clusters should have audit logging enabled' AS title,
    account_id,
    arn AS resource_id,
    CASE WHEN 
        IFNULL(logging_status:LoggingEnabled::STRING, 'false') != 'true'
    THEN 'fail' ELSE 'pass' END AS status
FROM aws_redshift_clusters
{% endmacro %}

{% macro postgres__clusters_should_have_audit_logging_enabled(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Amazon Redshift clusters should have audit logging enabled' as title,
    account_id,
    arn as resource_id,
    case when
     jsonb_typeof(logging_status -> 'LoggingEnabled') is null
     or (
             jsonb_typeof(logging_status -> 'LoggingEnabled') is not null
             and (logging_status ->> 'LoggingEnabled')::BOOLEAN is FALSE
         )
    then 'fail' else 'pass' end as status
from aws_redshift_clusters
{% endmacro %}

{% macro default__clusters_should_have_audit_logging_enabled(framework, check_id) %}{% endmacro %}
                    