{% macro connections_down(framework, check_id) %}
  {{ return(adapter.dispatch('connections_down')(framework, check_id)) }}
{% endmacro %}

{% macro default__connections_down(framework, check_id) %}{% endmacro %}

{% macro postgres__connections_down(framework, check_id) %}
select
       '{{framework}}'                                 as framework,
       '{{check_id}}'                                  as check_id,
       'Direct Connect connections in "down" state' as title,
       account_id,
       arn                                          as resource_id,
       'fail'                                       as status
from aws_directconnect_connections
where connection_state = 'down'{% endmacro %}
