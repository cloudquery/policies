{% macro route_tables_unused(framework, check_id) %}
  {{ return(adapter.dispatch('route_tables_unused')(framework, check_id)) }}
{% endmacro %}

{% macro default__route_tables_unused(framework, check_id) %}{% endmacro %}

{% macro postgres__route_tables_unused(framework, check_id) %}
select
       '{{framework}}'         as framework,
       '{{check_id}}'          as check_id,
       'Unused route table' as title,
       account_id,
       arn                  as resource_id,
       'fail'               as status
from aws_ec2_route_tables
where coalesce(jsonb_array_length(associations), 0) = 0;
{% endmacro %}
