{% macro unused_backup_vaults(framework, check_id) %}
  {{ return(adapter.dispatch('unused_backup_vaults')(framework, check_id)) }}
{% endmacro %}

{% macro default__unused_backup_vaults(framework, check_id) %}{% endmacro %}

{% macro postgres__unused_backup_vaults(framework, check_id) %} 
SELECT 
    uv.account_id,
    uv.resource_id,
    rbc.cost,
    'backup_vaults' as resource_type
FROM (
select
       vault.account_id,
       vault.arn                        as resource_id
from aws_backup_vaults vault
         left join (
    select distinct rp.vault_arn 
    from aws_backup_vault_recovery_points as rp
    ) as point on point.vault_arn = vault.arn
where point.vault_arn is null) as uv
JOIN {{ ref('aws_cost__by_resources') }} rbc ON uv.resource_id = rbc.line_item_resource_id
{% endmacro %}

{% macro snowflake__unused_backup_vaults(framework, check_id) %}

{% endmacro %}