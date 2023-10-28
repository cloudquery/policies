{% macro api_gw_cache_encrypted(framework, check_id) %}
  {{ return(adapter.dispatch('api_gw_cache_encrypted')(framework, check_id)) }}
{% endmacro %}

{% macro default__api_gw_cache_encrypted(framework, check_id) %}{% endmacro %}

{% macro postgres__api_gw_cache_encrypted(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'API Gateway REST API cache data should be encrypted at rest' AS title,
  account_id,
  arn as resource_id,
  case
    when stage_caching_enabled is true
        and (
            caching_enabled is true
            and cache_data_encrypted is not true
        ) 
        then 'fail'
        else 'pass'
  end as status
from
    view_aws_apigateway_method_settings
{% endmacro %}
