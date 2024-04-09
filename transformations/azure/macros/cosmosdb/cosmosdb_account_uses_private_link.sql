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
  'Ensure That Private Endpoints Are Used Where Possible' as title,
  a.subscription_id,
  case
    when v.id IS NULL then 'fail' else 'pass'
  end as status
FROM
  azure_cosmos_database_accounts a
  LEFT OUTER JOIN valid_accounts v
  ON a.id = v.id
{% endmacro %}

{% macro snowflake__cosmosdb_account_uses_private_link(framework, check_id) %}
WITH valid_accounts AS (
  SELECT id
  FROM azure_cosmos_database_accounts,
      LATERAL FLATTEN(properties:privateEndpointConnections) as connection
  WHERE connection.value:privateLinkServiceConnectionState:status = 'Approved'
)

SELECT
  a.id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure That Private Endpoints Are Used Where Possible' as title,
  a.subscription_id,
  case
    when v.id IS NULL then 'fail' else 'pass'
  end as status
FROM
  azure_cosmos_database_accounts a
  LEFT OUTER JOIN valid_accounts v
  ON a.id = v.id
{% endmacro %}

{% macro bigquery__cosmosdb_account_uses_private_link(framework, check_id) %}
WITH valid_accounts AS (
  SELECT id
  FROM {{ full_table_name("azure_cosmos_database_accounts") }},
  UNNEST(JSON_QUERY_ARRAY(properties.privateEndpointConnections)) AS connection
  WHERE JSON_VALUE(connection.privateLinkServiceConnectionState.status) = 'Approved'
)

SELECT
  a.id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure That Private Endpoints Are Used Where Possible' as title,
  a.subscription_id,
  case
    when v.id IS NULL then 'fail' else 'pass'
  end as status
FROM
  {{ full_table_name("azure_cosmos_database_accounts") }} a
  LEFT OUTER JOIN valid_accounts v
  ON a.id = v.id
{% endmacro %}