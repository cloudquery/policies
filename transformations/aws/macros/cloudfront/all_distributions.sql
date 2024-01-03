{% macro all_distributions(framework, check_id) %}
  {{ return(adapter.dispatch('all_distributions')(framework, check_id)) }}
{% endmacro %}

{% macro default__all_distributions(framework, check_id) %}{% endmacro %}

{% macro postgres__all_distributions(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Find all CloudFront distributions' AS title,
    account_id,
    arn as resource_id,
    'fail' as status
from
    aws_cloudfront_distributions
{% endmacro %}

{% macro bigquery__all_distributions(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Find all CloudFront distributions' AS title,
    account_id,
    arn as resource_id,
    'fail' as status
from
    {{ full_table_name("aws_cloudfront_distributions") }}
{% endmacro %}

{% macro snowflake__all_distributions(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Find all CloudFront distributions' AS title,
    account_id,
    arn as resource_id,
    'fail' as status
from
    aws_cloudfront_distributions
{% endmacro %}