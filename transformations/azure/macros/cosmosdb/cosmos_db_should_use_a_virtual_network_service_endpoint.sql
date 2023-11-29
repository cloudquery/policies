{% macro cosmosdb_cosmos_db_should_use_a_virtual_network_service_endpoint(framework, check_id) %}
WITH valid_accounts AS (
  SELECT id
  FROM azure_cosmos_database_accounts, jsonb_array_elements(properties->'virtualNetworkRules') AS rule
  WHERE rule ->> 'id' IS NOT NULL
) -- TODO check

SELECT
  a.id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Cosmos DB should use a virtual network service endpoint',
  a.subscription_id,
  case
    when v.id IS NULL then 'fail' else 'pass'
  end
FROM
  azure_cosmos_database_accounts a
  LEFT OUTER JOIN valid_accounts v
  ON a.id = v.id

{% endmacro %}