{% macro security_defender_on_for_storage(framework, check_id) %}
  {{ return(adapter.dispatch('security_defender_on_for_storage')(framework, check_id)) }}
{% endmacro %}

{% macro default__security_defender_on_for_storage(framework, check_id) %}{% endmacro %}

{% macro postgres__security_defender_on_for_storage(framework, check_id) %}
SELECT
  id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure that Azure Defender is set to On for Storage (Automatic)' as title,
  subscription_id,
  case
    when properties ->> 'pricingTier' = 'Standard'
    then 'pass' else 'fail'
  end
FROM azure_security_pricings asp
WHERE "name" = 'StorageAccounts'
{% endmacro %}

{% macro snowflake__security_defender_on_for_storage(framework, check_id) %}
SELECT
  id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure that Azure Defender is set to On for Storage (Automatic)' as title,
  subscription_id,
  case
    when properties:pricingTier = 'Standard'
    then 'pass' else 'fail'
  end
FROM azure_security_pricings asp
WHERE name = 'StorageAccounts'
{% endmacro %}

{% macro bigquery__security_defender_on_for_storage(framework, check_id) %}
SELECT
  id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure that Azure Defender is set to On for Storage (Automatic)' as title,
  subscription_id,
  case
    when JSON_VALUE(properties.pricingTier) = 'Standard'
    then 'pass' else 'fail'
  end
FROM {{ full_table_name("azure_security_pricings") }} asp
WHERE name = 'StorageAccounts'
{% endmacro %}