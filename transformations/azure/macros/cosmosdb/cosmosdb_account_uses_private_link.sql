{% macro cosmosdb_account_uses_private_link(framework, check_id) %}
  {{ return(adapter.dispatch('cosmosdb_account_uses_private_link')(framework, check_id)) }}
{% endmacro %}

{% macro default__cosmosdb_account_uses_private_link(framework, check_id) %}{% endmacro %}

{% macro postgres__cosmosdb_account_uses_private_link(framework, check_id) %}
WITH valid_accounts AS (
  SELECT id
  FROM azure_cosmos_database_accounts, jsonb_array_elements(properties->'privateEndpointConnections') AS connection
  WHERE connection -> 'privateLinkServiceConnectionState' ->> 'status' = 'Approved'
)

SELECT
  a.id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure That Private Endpoints Are Used Where Possible',
  a.subscription_id,
  case
    when v.id IS NULL then 'fail' else 'pass'
  end
FROM
  azure_cosmos_database_accounts a
  LEFT OUTER JOIN valid_accounts v
  ON a.id = v.id
{% endmacro %}

{% macro snowflake__cosmosdb_account_uses_private_link(framework, check_id) %}
{% endmacro %}

{% macro bigquery__cosmosdb_account_uses_private_link(framework, check_id) %}
{% endmacro %}