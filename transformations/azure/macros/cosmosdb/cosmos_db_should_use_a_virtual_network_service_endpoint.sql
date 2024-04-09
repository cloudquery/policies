{% macro cosmosdb_cosmos_db_should_use_a_virtual_network_service_endpoint(framework, check_id) %}
  {{ return(adapter.dispatch('cosmosdb_cosmos_db_should_use_a_virtual_network_service_endpoint')(framework, check_id)) }}
{% endmacro %}

{% macro default__cosmosdb_cosmos_db_should_use_a_virtual_network_service_endpoint(framework, check_id) %}{% endmacro %}

{% macro postgres__cosmosdb_cosmos_db_should_use_a_virtual_network_service_endpoint(framework, check_id) %}
WITH valid_accounts AS (
  SELECT id
  FROM azure_cosmos_database_accounts, jsonb_array_elements(properties->'virtualNetworkRules') AS rule
  WHERE rule ->> 'id' IS NOT NULL
) -- TODO check

SELECT
  a.id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure That "Firewalls & Networks" Is Limited to Use Selected Networks Instead of All Networks (Automated)',
  a.subscription_id,
  case
    when v.id IS NULL then 'fail' else 'pass'
  end
FROM
  azure_cosmos_database_accounts a
  LEFT OUTER JOIN valid_accounts v
  ON a.id = v.id
{% endmacro %}

{% macro snowflake__cosmosdb_cosmos_db_should_use_a_virtual_network_service_endpoint(framework, check_id) %}
WITH valid_accounts AS (
  SELECT id
  FROM azure_cosmos_database_accounts,
  LATERAL FLATTEN(properties:virtualNetworkRules) AS rule
  WHERE rule.value:id IS NOT NULL
) -- TODO check

SELECT
  a.id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure That "Firewalls & Networks" Is Limited to Use Selected Networks Instead of All Networks (Automated)' as title,
  a.subscription_id,
  case
    when v.id IS NULL then 'fail' else 'pass'
  end as status
FROM
  azure_cosmos_database_accounts a
  LEFT OUTER JOIN valid_accounts v
  ON a.id = v.id
{% endmacro %}

{% macro bigquery__cosmosdb_cosmos_db_should_use_a_virtual_network_service_endpoint(framework, check_id) %}
WITH valid_accounts AS (
  SELECT id
  FROM {{ full_table_name("azure_cosmos_database_accounts") }},
  UNNEST(JSON_QUERY_ARRAY(properties.virtualNetworkRules)) AS rule
  WHERE JSON_VALUE(rule.id) IS NOT NULL
) -- TODO check

SELECT
  a.id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure That "Firewalls & Networks" Is Limited to Use Selected Networks Instead of All Networks (Automated)' as title,
  a.subscription_id,
  case
    when v.id IS NULL then 'fail' else 'pass'
  end as status
FROM
  {{ full_table_name("azure_cosmos_database_accounts") }} a
  LEFT OUTER JOIN valid_accounts v
  ON a.id = v.id
{% endmacro %}