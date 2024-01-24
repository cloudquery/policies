{% macro elastic_beanstalk_stream_logs_to_cloudwatch(framework, check_id) %}
  {{ return(adapter.dispatch('elastic_beanstalk_stream_logs_to_cloudwatch')(framework, check_id)) }}
{% endmacro %}

{% macro default__elastic_beanstalk_stream_logs_to_cloudwatch(framework, check_id) %}{% endmacro %}

{% macro postgres__elastic_beanstalk_stream_logs_to_cloudwatch(framework, check_id) %}
with flat_configs as (
    select 
        c.environment_arn,
        f -> 'Namespace' ->> 'Value' as is_log_streaming
        
    from 
        aws_elasticbeanstalk_configuration_settings c,
		JSONB_ARRAY_ELEMENTS(c.option_settings) AS f
  
    WHERE
        f ->> 'Namespace' = 'aws:elasticbeanstalk:cloudwatch:logs'
        and 
        f ->> 'OptionName' = 'StreamLogs'
)

SELECT
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Elastic Beanstalk should stream logs to CloudWatch' as title, 
    e.account_id,
    e.arn as resource_id,
    CASE
     WHEN is_log_streaming = 'true' THEN 'pass'
     ELSE 'fail'
    END as status
FROM aws_elasticbeanstalk_environments e
JOIN flat_configs as fc
    ON e.arn = fc.environment_arn
{% endmacro %}

{% macro snowflake__elastic_beanstalk_stream_logs_to_cloudwatch(framework, check_id) %}
with flat_configs as (
    select 
        c.environment_arn,
        f.value:Namespace:Value::string as is_log_streaming
        
    from 
        aws_elasticbeanstalk_configuration_settings c,
        LATERAL FLATTEN(input => c.option_settings) f
  
    WHERE
        f.value:Namespace::string = 'aws:elasticbeanstalk:cloudwatch:logs'
        and 
        f.value:OptionName::string = 'StreamLogs'
)

SELECT
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Elastic Beanstalk should stream logs to CloudWatch' as title, 
    e.account_id,
    e.arn as resource_id,
    CASE
     WHEN is_log_streaming = 'true' THEN 'pass'
     ELSE 'fail'
    END as status
FROM aws_elasticbeanstalk_environments e
JOIN flat_configs as fc
    ON e.arn = fc.environment_arn
{% endmacro %}

{% macro bigquery__elastic_beanstalk_stream_logs_to_cloudwatch(framework, check_id) %}
with flat_configs as (
    select 
        c.environment_arn,
        CAST(JSON_VALUE(f.Namespace.Value) AS STRING) as is_log_streaming
        
    from 
        {{ full_table_name("aws_elasticbeanstalk_configuration_settings") }} c,
 UNNEST(JSON_QUERY_ARRAY(option_settings)) AS f 
    WHERE
        CAST(JSON_VALUE(f.Namespace) AS STRING) = 'aws:elasticbeanstalk:cloudwatch:logs'
        and 
        CAST(JSON_VALUE(f.OptionName) AS STRING) = 'StreamLogs'
)

SELECT
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Elastic Beanstalk should stream logs to CloudWatch' as title, 
    e.account_id,
    e.arn as resource_id,
    CASE
     WHEN is_log_streaming = 'true' THEN 'pass'
     ELSE 'fail'
    END as status
FROM {{ full_table_name("aws_elasticbeanstalk_environments") }} e
JOIN flat_configs as fc
    ON e.arn = fc.environment_arn
{% endmacro %}