{% macro sql_managed_instances_without_cmk_at_rest(framework, check_id) %}
WITH protected_instances AS (SELECT s.id AS instance_id
                             FROM azure_sql_managed_instances s
                                      LEFT JOIN azure_sql_managed_instance_encryption_protectors ep
                                                ON s._cq_id = ep._cq_parent_id
                             WHERE ep.properties ->> 'serverKeyType' = 'AzureKeyVault'
                               AND ep.properties ->> 'uri' IS NOT NULL)

SELECT
  _cq_sync_time As sync_time,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'SQL managed instances should use customer-managed keys to encrypt data at rest' as title,
  i.subscription_id,
  i.id AS instance_id,
  case
    when  p.instance_id IS NULL
      then 'fail' else 'pass'
  end
FROM azure_sql_managed_instances i
         LEFT JOIN protected_instances p ON p.instance_id = i.id{% endmacro %}