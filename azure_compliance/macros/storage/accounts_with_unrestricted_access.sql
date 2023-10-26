{% macro storage_accounts_with_unrestricted_access(framework, check_id) %}

SELECT
  _cq_sync_time As sync_time,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Storage accounts should restrict network access',
  az_sub.subscription_id,
  az_stor.id,
  case
    when az_stor.properties -> 'networkAcls' ->>'defaultAction' IS DISTINCT FROM 'Deny'
      then 'fail' else 'pass'
  end
FROM azure_storage_accounts as az_stor
LEFT JOIN azure_subscription_subscriptions as az_sub
ON az_sub.subscription_id = SUBSTRING(az_stor.id,16,36){% endmacro %}