{% macro filesystems_unused(framework, check_id) %}
  {{ return(adapter.dispatch('filesystems_unused')(framework, check_id)) }}
{% endmacro %}

{% macro default__filesystems_unused(framework, check_id) %}{% endmacro %}

{% macro postgres__filesystems_unused(framework, check_id) %}
select
       '{{framework}}'            as framework,
       '{{check_id}}'             as check_id,
       'Unused EFS filesystem' as title,
       account_id,
       arn                     as resource_id,
       'fail'                  as status
from aws_efs_filesystems
where number_of_mount_targets = 0{% endmacro %}
