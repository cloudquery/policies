{% macro storage_secure_transfer_to_storage_accounts_should_be_enabled(framework, check_id) %}

SELECT
  _cq_sync_time As sync_time,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Secure transfer to storage accounts should be enabled',
  subscription_id,
  id,
  case
    when properties ->> 'supportsHttpsTrafficOnly' IS DISTINCT FROM 'true'
      then 'fail' else 'pass'
  end
FROM azure_storage_accounts
{% endmacro %}