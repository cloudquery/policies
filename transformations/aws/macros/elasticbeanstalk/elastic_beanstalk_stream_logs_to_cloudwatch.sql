{% macro elastic_beanstalk_stream_logs_to_cloudwatch(framework, check_id) %}
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
    ON e.environment_id = fc.environment_arn
    {% endmacro %}