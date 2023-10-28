{% macro api_gw_xray_enabled(framework, check_id) %}
  {{ return(adapter.dispatch('api_gw_xray_enabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__api_gw_xray_enabled(framework, check_id) %}{% endmacro %}

{% macro postgres__api_gw_xray_enabled(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'API Gateway REST API stages should have AWS X-Ray tracing enabled' as title,
    account_id,
    arn as resource_id,
    case
        when stage_data_trace_enabled is not true then 'fail'
        else 'pass'
        end as status
from
    {{ ref('aws_compliance__apigateway_method_settings') }}
{% endmacro %}
