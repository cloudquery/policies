{% macro distributions_unused(framework, check_id) %}
  {{ return(adapter.dispatch('distributions_unused')(framework, check_id)) }}
{% endmacro %}

{% macro default__distributions_unused(framework, check_id) %}{% endmacro %}

{% macro postgres__distributions_unused(framework, check_id) %}
select
       '{{framework}}'                       as framework,
       '{{check_id}}'                        as check_id,
       'Disabled Lightsail distributions' as title,
       account_id,
       arn                                as resource_id,
       'fail'                             as status
from aws_lightsail_distributions
where is_enabled = false{% endmacro %}
