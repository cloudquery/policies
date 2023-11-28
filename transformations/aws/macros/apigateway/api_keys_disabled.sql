{% macro api_keys_disabled(framework, check_id) %}
  {{ return(adapter.dispatch('api_keys_disabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__api_keys_disabled(framework, check_id) %}{% endmacro %}

{% macro postgres__api_keys_disabled(framework, check_id) %}
select
       '{{framework}}'                 as framework,
       '{{check_id}}'                  as check_id,
       'Unused API Gateway API key' as title,
       account_id,
       arn                          as resource_id,
       'fail'                       as status
from aws_apigateway_api_keys
where enabled = false{% endmacro %}
