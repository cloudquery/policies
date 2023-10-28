{% macro distributions_disabled(framework, check_id) %}
  {{ return(adapter.dispatch('distributions_disabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__distributions_disabled(framework, check_id) %}{% endmacro %}

{% macro postgres__distributions_disabled(framework, check_id) %}
select
       '{{framework}}'                       as framework,
       '{{check_id}}'                        as check_id,
       'Disabled CloudFront distribution' as title,
       account_id,
       arn                                as resource_id,
       'fail'                             as status
from aws_cloudfront_distributions
where (distribution_config->>'Enabled')::boolean is distinct from true
{% endmacro %}
