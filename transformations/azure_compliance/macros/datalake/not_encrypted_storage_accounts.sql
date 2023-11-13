{% macro datalake_not_encrypted_storage_accounts(framework, check_id) %}

SELECT
  _cq_sync_time As sync_time,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Require encryption on Data Lake Store accounts',
    subscription_id,
	id,
  case
    when properties ->> 'encryptionState' IS DISTINCT FROM 'Enabled'
    then 'fail' else 'pass'
  end
FROM
	azure_datalakestore_accounts
{% endmacro %}