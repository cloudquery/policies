{% macro unused_efs_filesystems(framework, check_id) %}
  {{ return(adapter.dispatch('unused_efs_filesystems')(framework, check_id)) }}
{% endmacro %}

{% macro default__unused_efs_filesystems(framework, check_id) %}{% endmacro %}

{% macro postgres__unused_efs_filesystems(framework, check_id) %}
select 
       fs.account_id,
       fs.arn                     as resource_id,
       rbc.cost
from aws_efs_filesystems fs
JOIN {{ ref('aws_cost__by_resources') }} rbc ON fs.arn = rbc.line_item_resource_id
where fs.number_of_mount_targets = 0
{% endmacro %}

{% macro snowflake__unused_efs_filesystems(framework, check_id) %}

{% endmacro %}