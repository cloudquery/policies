{% macro elbv2_redirect_http_to_https(framework, check_id) %}
  {{ return(adapter.dispatch('elbv2_redirect_http_to_https')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__elbv2_redirect_http_to_https(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Application Load Balancer should be configured to redirect all HTTP requests to HTTPS' as title,
  account_id,
  arn as resource_id,
  case when
   protocol = 'HTTP' and (da.value:Type != 'REDIRECT' or da.value:RedirectConfig:Protocol != 'HTTPS')
   then 'fail'
   else 'pass'
  end as status
from aws_elbv2_listeners, lateral flatten(input => parse_json(default_actions)) AS da
{% endmacro %}

{% macro postgres__elbv2_redirect_http_to_https(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Application Load Balancer should be configured to redirect all HTTP requests to HTTPS' as title,
  account_id,
  arn as resource_id,
  case when
   protocol = 'HTTP' and (
        da->>'Type' != 'redirect' or da->'RedirectConfig'->>'Protocol' != 'HTTPS')
    then 'fail'
    else 'pass'
  end as status
from aws_elbv2_listeners, JSONB_ARRAY_ELEMENTS(default_actions) AS da
{% endmacro %}

{% macro default__elbv2_redirect_http_to_https(framework, check_id) %}{% endmacro %}
                    
{% macro bigquery__elbv2_redirect_http_to_https(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Application Load Balancer should be configured to redirect all HTTP requests to HTTPS' as title,
  account_id,
  arn as resource_id,
  case when
   protocol = 'HTTP' and (
        JSON_VALUE(da.Type) != 'redirect' or JSON_VALUE(da.RedirectConfig.Protocol) != 'HTTPS')
    then 'fail'
    else 'pass'
  end as status
from {{ full_table_name("aws_elbv2_listeners") }},
    UNNEST(JSON_QUERY_ARRAY(default_actions)) AS da
{% endmacro %}   

{% macro athena__elbv2_redirect_http_to_https(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Application Load Balancer should be configured to redirect all HTTP requests to HTTPS' as title,
  account_id,
  arn as resource_id,
  case when
   protocol = 'HTTP' and (json_extract_scalar(da, '$.Type') != 'REDIRECT' or json_extract_scalar(da, '$.RedirectConfig.Protocol') != 'HTTPS')
   then 'fail'
   else 'pass'
  end as status
from aws_elbv2_listeners, 
unnest(cast(json_parse(default_actions) as array(json))) as t(da)
{% endmacro %}