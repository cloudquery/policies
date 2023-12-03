{% macro default_root_object_configured(framework, check_id) %}
  {{ return(adapter.dispatch('default_root_object_configured')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__default_root_object_configured(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'CloudFront distributions should have a default root object configured' as title,
    account_id,
    arn as resource_id,
    CASE
        WHEN distribution_config:DefaultRootObject::STRING = '' THEN 'fail'
        ELSE 'pass'
    END AS status
from aws_cloudfront_distributions
{% endmacro %}

{% macro postgres__default_root_object_configured(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'CloudFront distributions should have a default root object configured' as title,
    account_id,
    arn as resource_id,
    case
        when distribution_config->>'DefaultRootObject' = '' then 'fail'
        else 'pass'
    end as status
from aws_cloudfront_distributions
{% endmacro %}

{% macro default__default_root_object_configured(framework, check_id) %}{% endmacro %}
                    