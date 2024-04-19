{% macro api_gw_routes_should_specify_authorization_type(framework, check_id) %}
  {{ return(adapter.dispatch('api_gw_routes_should_specify_authorization_type')(framework, check_id)) }}
{% endmacro %}

{% macro default__api_gw_routes_should_specify_authorization_type(framework, check_id) %}{% endmacro %}

{% macro postgres__api_gw_routes_should_specify_authorization_type(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'API Gateway routes should specify an authorization type' as title,
    account_id,
    arn as resource_id,
    CASE
        WHEN authorization_type IS NULL OR authorization_type = '' OR authorization_type = 'NONE' THEN 'fail'
        ELSE 'pass'
    END AS status
FROM 
    aws_apigatewayv2_api_routes
{% endmacro %}

{% macro snowflake__api_gw_routes_should_specify_authorization_type(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'API Gateway routes should specify an authorization type' as title,
    account_id,
    arn as resource_id,
    CASE
        WHEN authorization_type IS NULL OR authorization_type = '' OR authorization_type = 'NONE' THEN 'fail'
        ELSE 'pass'
    END AS status
FROM 
    aws_apigatewayv2_api_routes
{% endmacro %}

{% macro bigquery__api_gw_routes_should_specify_authorization_type(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'API Gateway routes should specify an authorization type' as title,
    account_id,
    arn as resource_id,
    CASE
        WHEN authorization_type IS NULL OR authorization_type = '' OR authorization_type = 'NONE' THEN 'fail'
        ELSE 'pass'
    END AS status
FROM 
    {{ full_table_name("aws_apigatewayv2_api_routes") }}
{% endmacro %}

{% macro athena__api_gw_routes_should_specify_authorization_type(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'API Gateway routes should specify an authorization type' as title,
    account_id,
    arn as resource_id,
    CASE
        WHEN authorization_type IS NULL OR authorization_type = '' OR authorization_type = 'NONE' THEN 'fail'
        ELSE 'pass'
    END AS status
FROM 
    aws_apigatewayv2_api_routes
{% endmacro %}