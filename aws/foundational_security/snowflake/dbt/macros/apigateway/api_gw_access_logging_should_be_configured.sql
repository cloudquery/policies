{% macro api_gw_access_logging_should_be_configured(framework, check_id) %}
insert into aws_policy_results
SELECT
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Access logging should be configured for API Gateway V2 Stages' as title,
    account_id, 
    arn AS resource_id,
    CASE
        WHEN access_log_settings::text IS NULL OR access_log_settings = '' THEN 'fail'
        ELSE 'pass'
    END AS status
FROM 
    aws_apigatewayv2_api_stages
{% endmacro %}



