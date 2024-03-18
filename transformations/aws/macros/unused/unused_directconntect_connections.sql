{% macro unused_directconntect_connections(framework, check_id) %}
  {{ return(adapter.dispatch('unused_directconntect_connections')(framework, check_id)) }}
{% endmacro %}

{% macro default__unused_directconntect_connections(framework, check_id) %}{% endmacro %}

{% macro postgres__unused_directconntect_connections(framework, check_id) %}
select 
       dc.request_account_id as account_id,
       dc.arn                as resource_id,
       rbc.cost,
       'directconnect_connections' as resource_type
from aws_directconnect_connections dc
JOIN {{ ref('aws_cost__by_resources') }} rbc ON dc.arn = rbc.line_item_resource_id 
where dc.connection_state = 'down'
{% endmacro %}

{% macro snowflake__unused_directconntect_connections(framework, check_id) %}

{% endmacro %}
