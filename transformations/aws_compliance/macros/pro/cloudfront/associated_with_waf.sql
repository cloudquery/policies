{% macro associated_with_waf(framework, check_id) %}
  {{ return(adapter.dispatch('associated_with_waf')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__associated_with_waf(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'API Gateway should be associated with an AWS WAF web ACL' as title,
    account_id,
    arn as resource_id,
    case
        when distribution_config:WebACLId = '' then 'fail'
        else 'pass'
    end as status
from aws_cloudfront_distributions
{% endmacro %}

{% macro postgres__associated_with_waf(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'API Gateway should be associated with an AWS WAF web ACL' as title,
    account_id,
    arn as resource_id,
    case
        when distribution_config->>'WebACLId' = '' then 'fail'
        else 'pass'
    end as status
from aws_cloudfront_distributions
{% endmacro %}
