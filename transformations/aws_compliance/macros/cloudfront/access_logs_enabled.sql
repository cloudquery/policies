{% macro access_logs_enabled(framework, check_id) %}
  {{ return(adapter.dispatch('access_logs_enabled')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__access_logs_enabled(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'CloudFront distributions should have logging enabled' as title,
    account_id,
    arn as resource_id,
    case
        when {{ json_parse("distribution_config", ["Logging", "Enabled"]) }} is distinct from true then 'fail'
        -- when (distribution_config:Logging:Enabled)::boolean is distinct from true then 'fail'
        else 'pass'
    end as status
from aws_cloudfront_distributions
{% endmacro %}

{% macro postgres__access_logs_enabled(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'CloudFront distributions should have logging enabled' as title,
    account_id,
    arn as resource_id,
    case
        when (distribution_config->'Logging'->>'Enabled')::boolean is distinct from true then 'fail'
        else 'pass'
    end as status
from aws_cloudfront_distributions
{% endmacro %}
