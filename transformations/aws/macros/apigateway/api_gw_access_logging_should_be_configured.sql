{% macro api_gw_access_logging_should_be_configured(framework, check_id) %}
  {{ return(adapter.dispatch('api_gw_access_logging_should_be_configured')(framework, check_id)) }}
{% endmacro %}

{% macro default__api_gw_access_logging_should_be_configured(framework, check_id) %}{% endmacro %}

{% macro postgres__api_gw_access_logging_should_be_configured(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Access logging should be configured for API Gateway V2 Stages' as title,
    account_id, 
    arn AS resource_id,
    CASE
        WHEN coalesce(cast(access_log_settings as TEXT), '') = '' THEN 'fail'
        ELSE 'pass'
    END AS status
FROM 
    aws_apigatewayv2_api_stages
{% endmacro %}

{% macro snowflake__api_gw_access_logging_should_be_configured(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Access logging should be configured for API Gateway V2 Stages' as title,
    account_id, 
    arn AS resource_id,
    CASE
        WHEN coalesce(cast(access_log_settings as TEXT), '') = '' THEN 'fail'
        ELSE 'pass'
    END AS status
FROM 
    aws_apigatewayv2_api_stages
{% endmacro %}

{% macro bigquery__api_gw_access_logging_should_be_configured(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Access logging should be configured for API Gateway V2 Stages' as title,
    account_id, 
    arn AS resource_id,
    CASE
        WHEN coalesce( CAST(JSON_VALUE(access_log_settings) AS STRING) , '') = '' THEN 'fail'
        ELSE 'pass'
    END AS status
FROM 
    {{ full_table_name("aws_apigatewayv2_api_stages") }}
{% endmacro %}

{% macro athena__api_gw_access_logging_should_be_configured(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Access logging should be configured for API Gateway V2 Stages' as title,
    account_id, 
    arn AS resource_id,
    CASE
        WHEN coalesce(cast(access_log_settings as varchar), '') = '' THEN 'fail'
        ELSE 'pass'
    END AS status
FROM 
    aws_apigatewayv2_api_stages
{% endmacro %}


