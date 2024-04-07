{% macro storage_account_uses_private_link(framework, check_id) %}
  {{ return(adapter.dispatch('storage_account_uses_private_link')(framework, check_id)) }}
{% endmacro %}

{% macro default__storage_account_uses_private_link(framework, check_id) %}{% endmacro %}

{% macro postgres__storage_account_uses_private_link(framework, check_id) %}
with storage_account_connection as (
  SELECT
    distinct a.id
  FROM
    azure_storage_accounts as a,
    jsonb_array_elements(properties -> 'PrivateEndpointConnection') as connection
  WHERE
    connection -> 'privateLinkServiceConnectionState' ->> 'status' = 'Approved' 
)
SELECT
    distinct a.id                                                                     AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure Private Endpoints are used to access Storage Accounts' AS title,
    a.subscription_id                                                        AS subscription_id,
    CASE
        WHEN s.id is null
        THEN 'fail'
        ELSE 'pass'
    END                                                                         AS status
FROM azure_storage_accounts as a
    left join storage_account_connection as s on a.id = s.id
{% endmacro %}

{% macro snowflake__storage_account_uses_private_link(framework, check_id) %}
with storage_account_connection as (
  SELECT
    distinct a.id
  FROM
    azure_storage_accounts as a,
    LATERAL FLATTEN(properties:PrivateEndpointConnection) as connection
  WHERE
    connection.value:privateLinkServiceConnectionState:status = 'Approved' 
)
SELECT
    distinct a.id                                                                     AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure Private Endpoints are used to access Storage Accounts' AS title,
    a.subscription_id                                                        AS subscription_id,
    CASE
        WHEN s.id is null
        THEN 'fail'
        ELSE 'pass'
    END                                                                         AS status
FROM azure_storage_accounts as a
    left join storage_account_connection as s on a.id = s.id
{% endmacro %}

{% macro bigquery__storage_account_uses_private_link(framework, check_id) %}
with storage_account_connection as (
  SELECT
    distinct a.id
  FROM
    {{ full_table_name("azure_storage_accounts") }} as a,
    UNNEST(JSON_QUERY_ARRAY(properties.PrivateEndpointConnection)) AS connection
  WHERE
    JSON_VALUE(connection.privateLinkServiceConnectionState.status) = 'Approved' 
)
SELECT
    distinct a.id                                                                     AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure Private Endpoints are used to access Storage Accounts' AS title,
    a.subscription_id                                                        AS subscription_id,
    CASE
        WHEN s.id is null
        THEN 'fail'
        ELSE 'pass'
    END                                                                         AS status
FROM {{ full_table_name("azure_storage_accounts") }} as a
    left join storage_account_connection as s on a.id = s.id
{% endmacro %}