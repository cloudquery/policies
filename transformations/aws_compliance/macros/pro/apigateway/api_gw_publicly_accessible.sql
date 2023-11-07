{% macro api_gw_publicly_accessible(framework, check_id) %}
  {{ return(adapter.dispatch('api_gw_publicly_accessible')(framework, check_id)) }}
{% endmacro %}

{% macro default__api_gw_publicly_accessible(framework, check_id) %}{% endmacro %}

{% macro postgres__api_gw_publicly_accessible(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Find all API Gateway instances that are publicly accessible' AS title,
    account_id,
    arn as resource_id,
    case
        when NOT '{PRIVATE}' = t then 'fail'
        else 'pass'
        end as status
from
    aws_apigateway_rest_apis, jsonb_array_elements_text(endpoint_configuration->'Types') as t
{% endmacro %}
