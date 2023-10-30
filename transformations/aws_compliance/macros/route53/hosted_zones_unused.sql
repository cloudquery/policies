{% macro hosted_zones_unused(framework, check_id) %}
  {{ return(adapter.dispatch('hosted_zones_unused')(framework, check_id)) }}
{% endmacro %}

{% macro default__hosted_zones_unused(framework, check_id) %}{% endmacro %}

{% macro postgres__hosted_zones_unused(framework, check_id) %}
select
       '{{framework}}'                   as framework,
       '{{check_id}}'                    as check_id,
       'Unused Route 53 hosted zones' as title,
       account_id,
       arn                            as resource_id,
       'fail'                         as status
from aws_route53_hosted_zones
where resource_record_set_count = 0{% endmacro %}
