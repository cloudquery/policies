{% macro api_gw_stage_should_use_ssl(framework, check_id) %}
  {{ return(adapter.dispatch('api_gw_stage_should_use_ssl')(framework, check_id)) }}
{% endmacro %}

{% macro default__api_gw_stage_should_use_ssl(framework, check_id) %}{% endmacro %}

{% macro postgres__api_gw_stage_should_use_ssl(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'API Gateway REST API stages should be configured to use SSL certificates for backend authentication' as title,
    account_id,
    arn as resource_id,
    CASE
        WHEN client_certificate_id is not null THEN 'pass'
        ELSE 'fail'
    END as status

from aws_apigateway_rest_api_stages
{% endmacro %}

{% macro snowflake__api_gw_stage_should_use_ssl(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'API Gateway REST API stages should be configured to use SSL certificates for backend authentication' as title,
    account_id,
    arn as resource_id,
    CASE
        WHEN client_certificate_id is not null THEN 'pass'
        ELSE 'fail'
    END as status

from aws_apigateway_rest_api_stages
{% endmacro %}

{% macro bigquery__api_gw_stage_should_use_ssl(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'API Gateway REST API stages should be configured to use SSL certificates for backend authentication' as title,
    account_id,
    arn as resource_id,
    CASE
        WHEN client_certificate_id is not null THEN 'pass'
        ELSE 'fail'
    END as status

from {{ full_table_name("aws_apigateway_rest_api_stages") }}
{% endmacro %}

{% macro athena__api_gw_stage_should_use_ssl(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'API Gateway REST API stages should be configured to use SSL certificates for backend authentication' as title,
    account_id,
    arn as resource_id,
    CASE
        WHEN client_certificate_id is not null THEN 'pass'
        ELSE 'fail'
    END as status

from aws_apigateway_rest_api_stages
{% endmacro %}