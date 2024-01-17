{% macro storage_secure_transfer_to_storage_accounts_should_be_enabled(framework, check_id) %}
  {{ return(adapter.dispatch('storage_secure_transfer_to_storage_accounts_should_be_enabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__storage_secure_transfer_to_storage_accounts_should_be_enabled(framework, check_id) %}{% endmacro %}

{% macro postgres__storage_secure_transfer_to_storage_accounts_should_be_enabled(framework, check_id) %}
SELECT
  id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Secure transfer to storage accounts should be enabled',
  subscription_id,
  case
    when properties ->> 'supportsHttpsTrafficOnly' IS DISTINCT FROM 'true'
      then 'fail' else 'pass'
  end
FROM azure_storage_accounts
{% endmacro %}

{% macro snowflake__storage_secure_transfer_to_storage_accounts_should_be_enabled(framework, check_id) %}
SELECT
  id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Secure transfer to storage accounts should be enabled',
  subscription_id,
  case
    when properties:supportsHttpsTrafficOnly IS DISTINCT FROM 'true'
      then 'fail' else 'pass'
  end
FROM azure_storage_accounts
{% endmacro %}

{% macro bigquery__storage_secure_transfer_to_storage_accounts_should_be_enabled(framework, check_id) %}
SELECT
  id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Secure transfer to storage accounts should be enabled',
  subscription_id,
  case
    when JSON_VALUE(properties.supportsHttpsTrafficOnly) IS DISTINCT FROM 'true'
      then 'fail' else 'pass'
  end
FROM {{ full_table_name("azure_storage_accounts") }}
{% endmacro %}