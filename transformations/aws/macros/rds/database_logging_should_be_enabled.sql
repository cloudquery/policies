{% macro database_logging_should_be_enabled(framework, check_id) %}
  {{ return(adapter.dispatch('database_logging_should_be_enabled')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__database_logging_should_be_enabled(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Database logging should be enabled' AS title,
    account_id,
    arn AS resource_id,
    CASE 
        WHEN enabled_cloudwatch_logs_exports IS NULL THEN 'fail'
        WHEN engine IN ('aurora', 'aurora-mysql', 'mariadb', 'mysql') 
             AND (NOT ARRAY_CONTAINS(PARSE_JSON(enabled_cloudwatch_logs_exports::VARCHAR)::VARIANT, 
                  ARRAY_CONSTRUCT('audit', 'error', 'general', 'slowquery'))) THEN 'fail'
        WHEN engine LIKE '%postgres%' 
             AND (NOT ARRAY_CONTAINS(PARSE_JSON(enabled_cloudwatch_logs_exports::VARCHAR)::VARIANT, 
                  ARRAY_CONSTRUCT('postgresql', 'upgrade'))) THEN 'fail'
        WHEN engine LIKE '%oracle%' 
             AND (NOT ARRAY_CONTAINS(PARSE_JSON(enabled_cloudwatch_logs_exports::VARCHAR)::VARIANT, 
                  ARRAY_CONSTRUCT('alert', 'audit', 'trace', 'listener'))) THEN 'fail'
        WHEN engine LIKE '%sqlserver%' 
             AND (NOT ARRAY_CONTAINS(PARSE_JSON(enabled_cloudwatch_logs_exports::VARCHAR)::VARIANT, 
                  ARRAY_CONSTRUCT('error', 'agent'))) THEN 'fail'
        ELSE 'pass' 
    END AS status
FROM aws_rds_instances
{% endmacro %}

{% macro postgres__database_logging_should_be_enabled(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Database logging should be enabled' as title,
    account_id,
    arn AS resource_id,
    case when
                 enabled_cloudwatch_logs_exports is null
                 or (engine in ('aurora', 'aurora-mysql', 'mariadb', 'mysql')
                 and not enabled_cloudwatch_logs_exports @> '{audit,error,general,slowquery}'
                     )
                 or (engine like '%postgres%'
                 and not enabled_cloudwatch_logs_exports @> '{postgresql,upgrade}')
                 or (engine like '%oracle%'
                 and not enabled_cloudwatch_logs_exports @> '{alert,audit,trace,listener}'
                     )
                 or (engine like '%sqlserver%'
                 and not enabled_cloudwatch_logs_exports @> '{error,agent}')
    then 'fail' else 'pass' end as status
from aws_rds_instances
{% endmacro %}

{% macro default__database_logging_should_be_enabled(framework, check_id) %}{% endmacro %}

{% macro bigquery__database_logging_should_be_enabled(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Database logging should be enabled' as title,
    account_id,
    arn AS resource_id,
    case when
                 enabled_cloudwatch_logs_exports is null
                 or (engine in ('aurora', 'aurora-mysql', 'mariadb', 'mysql')
                 and not (
                  'audit' IN UNNEST(enabled_cloudwatch_logs_exports)
                  and
                  'error' IN UNNEST(enabled_cloudwatch_logs_exports)
                  and
                  'general' IN UNNEST(enabled_cloudwatch_logs_exports)
                  and 
                  'slowquery' IN UNNEST(enabled_cloudwatch_logs_exports)
                 )
                     )
                or (engine like '%postgres%'
                 and not 
                 (
                  'postgresql' IN UNNEST(enabled_cloudwatch_logs_exports)
                  and
                  'upgrade' IN UNNEST(enabled_cloudwatch_logs_exports)
                 )
                )
                 or (engine like '%oracle%'
                 and not 
                (
                  'alert' IN UNNEST(enabled_cloudwatch_logs_exports)
                  and
                  'audit' IN UNNEST(enabled_cloudwatch_logs_exports)
                  and
                  'trace' IN UNNEST(enabled_cloudwatch_logs_exports)
                  and
                  'listener' IN UNNEST(enabled_cloudwatch_logs_exports)
                )
                     )
                 or (engine like '%sqlserver%'
                 and not 
                 (
                  'error' IN UNNEST(enabled_cloudwatch_logs_exports)
                  and
                  'agent' IN UNNEST(enabled_cloudwatch_logs_exports)
                 )
                 )
      then 'fail' else 'pass' end as status
from {{ full_table_name("aws_rds_instances") }}
{% endmacro %}   

{% macro athena__database_logging_should_be_enabled(framework, check_id) %}
SELECT
    '{{framework}}' AS framework,
    '{{check_id}}' AS check_id,
    'Database logging should be enabled' AS title,
    account_id,
    arn AS resource_id,
    CASE 
        WHEN enabled_cloudwatch_logs_exports IS NULL THEN 'fail'
        WHEN engine IN ('aurora', 'aurora-mysql', 'mariadb', 'mysql') AND
             NOT cardinality(array_intersect(CAST(enabled_cloudwatch_logs_exports AS array(varchar)),
                 ARRAY['audit', 'error', 'general', 'slowquery'])) = 4 THEN 'fail'
        WHEN engine LIKE '%postgres%' AND
             NOT cardinality(array_intersect(CAST(enabled_cloudwatch_logs_exports AS array(varchar)),
                 ARRAY['postgresql', 'upgrade'])) = 2 THEN 'fail'
        WHEN engine LIKE '%oracle%' AND
             NOT cardinality(array_intersect(CAST(enabled_cloudwatch_logs_exports AS array(varchar)),
                 ARRAY['alert', 'audit', 'trace', 'listener'])) = 4 THEN 'fail'
        WHEN engine LIKE '%sqlserver%' AND
             NOT cardinality(array_intersect(CAST(enabled_cloudwatch_logs_exports AS array(varchar)),
                 ARRAY['error', 'agent'])) = 2 THEN 'fail'
        ELSE 'pass'
    END AS status
FROM aws_rds_instances
{% endmacro %}   