{% macro tables_unused(framework, check_id) %}
  {{ return(adapter.dispatch('tables_unused')(framework, check_id)) }}
{% endmacro %}

{% macro default__tables_unused(framework, check_id) %}{% endmacro %}

{% macro postgres__tables_unused(framework, check_id) %}
select
       '{{framework}}'                   as framework,
       '{{check_id}}'                    as check_id,
       'DynamoDB table with no items' as title,
       account_id,
       arn                            as resource_id,
       'fail'                         as status
from aws_dynamodb_tables
where item_count = 0{% endmacro %}
