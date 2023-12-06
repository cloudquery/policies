{% macro unused_dynamodb_tables(framework, check_id) %}
  {{ return(adapter.dispatch('unused_dynamodb_tables')(framework, check_id)) }}
{% endmacro %}

{% macro default__unused_dynamodb_tables(framework, check_id) %}{% endmacro %}

{% macro postgres__unused_dynamodb_tables(framework, check_id) %}
select 
       ddb.account_id,
       ddb.arn                            as resource_id,
       rbc.cost
from aws_dynamodb_tables ddb
JOIN {{ ref('aws_cost__by_resources') }} rbc ON ddb.arn = rbc.line_item_resource_id 
where ddb.item_count = 0
{% endmacro %}

{% macro snowflake__unused_dynamodb_tables(framework, check_id) %}

{% endmacro %}