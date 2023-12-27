{% macro unused_cloudfront_distributions(framework, check_id) %}
  {{ return(adapter.dispatch('unused_cloudfront_distributions')(framework, check_id)) }}
{% endmacro %}

{% macro default__unused_cloudfront_distributions(framework, check_id) %}{% endmacro %}

{% macro postgres__unused_cloudfront_distributions(framework, check_id) %}
select
       d.account_id,
       d.arn                                as resource_id,
       rbc.cost
from aws_cloudfront_distributions d
JOIN {{ ref('aws_cost__by_resources') }} rbc ON d.arn = rbc.line_item_resource_id 
where (d.distribution_config->>'Enabled')::boolean is distinct from true
{% endmacro %}

{% macro snowflake__unused_cloudfront_distributions(framework, check_id) %}

{% endmacro %}