{% macro api_gw_associated_with_waf(framework, check_id) %}
  {{ return(adapter.dispatch('api_gw_associated_with_waf')(framework, check_id)) }}
{% endmacro %}

{% macro default__api_gw_associated_with_waf(framework, check_id) %}{% endmacro %}

{% macro postgres__api_gw_associated_with_waf(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'API Gateway should be associated with an AWS WAF web ACL' AS title,
  account_id,
  arn as resource_id,
  case
    when waf is null then 'fail'
    else 'pass'
  end as status
from
    {{ ref('aws_compliance__api_gateway_method_settings') }}
{% endmacro %}
