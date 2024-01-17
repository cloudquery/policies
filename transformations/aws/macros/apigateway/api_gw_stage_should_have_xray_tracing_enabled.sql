{% macro api_gw_stage_should_have_xray_tracing_enabled(framework, check_id) %}
  {{ return(adapter.dispatch('api_gw_stage_should_have_xray_tracing_enabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__api_gw_stage_should_have_xray_tracing_enabled(framework, check_id) %}{% endmacro %}

{% macro postgres__api_gw_stage_should_have_xray_tracing_enabled(framework, check_id) %}
select 
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'API Gateway REST API stages should have AWS X-Ray tracing enabled' as title,
    account_id, 
    arn as resource_id,
    CASE
        WHEN tracing_enabled = true THEN 'pass'
        ELSE 'fail'
    END as status
FROM 
    aws_apigateway_rest_api_stages
{% endmacro %}

{% macro snowflake__api_gw_stage_should_have_xray_tracing_enabled(framework, check_id) %}
select 
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'API Gateway REST API stages should have AWS X-Ray tracing enabled' as title,
    account_id, 
    arn as resource_id,
    CASE
        WHEN tracing_enabled = true THEN 'pass'
        ELSE 'fail'
    END as status
FROM 
    aws_apigateway_rest_api_stages
{% endmacro %}