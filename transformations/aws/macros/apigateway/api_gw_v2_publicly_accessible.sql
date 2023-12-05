{% macro api_gw_v2_publicly_accessible(framework, check_id) %}
  {{ return(adapter.dispatch('api_gw_v2_publicly_accessible')(framework, check_id)) }}
{% endmacro %}

{% macro default__api_gw_v2_publicly_accessible(framework, check_id) %}{% endmacro %}

{% macro postgres__api_gw_v2_publicly_accessible(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Find all API Gateway V2 instances (HTTP and Webhook) that are publicly accessible' AS title,
    account_id,
    arn as resource_id,
    'fail' as status
from
    aws_apigatewayv2_apis
{% endmacro %}

{% macro bigquery__api_gw_v2_publicly_accessible(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Find all API Gateway V2 instances (HTTP and Webhook) that are publicly accessible' AS title,
    account_id,
    arn as resource_id,
    'fail' as status
from
    {{ full_table_name("aws_apigatewayv2_apis") }}
{% endmacro %}
