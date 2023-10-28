{% macro vaults_unused(framework, check_id) %}
  {{ return(adapter.dispatch('vaults_unused')(framework, check_id)) }}
{% endmacro %}

{% macro default__vaults_unused(framework, check_id) %}{% endmacro %}

{% macro postgres__vaults_unused(framework, check_id) %}
with point as (select distinct vault_arn from aws_backup_vault_recovery_points)
select
       '{{framework}}'                     as framework,
       '{{check_id}}'                      as check_id,
       'Vaults with no recovery points' as title,
       vault.account_id,
       vault.arn                        as resource_id,
       'fail'                           as status
from aws_backup_vaults vault
         left join point on point.vault_arn = vault.arn
where point.vault_arn is null;{% endmacro %}
