{% macro keyvault_vault_private_link_used(framework, check_id) %}
  {{ return(adapter.dispatch('keyvault_vault_private_link_used')(framework, check_id)) }}
{% endmacro %}

{% macro default__keyvault_vault_private_link_used(framework, check_id) %}{% endmacro %}

{% macro postgres__keyvault_vault_private_link_used(framework, check_id) %}
SELECT
    id                                                                       AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure that Private Endpoints are Used for Azure Key Vault' AS title,
    subscription_id                                                          AS subscription_id,
    CASE
        WHEN properties -> 'networkAcls' IS null
        OR properties -> 'networkAcls' ->> 'defaultAction' = 'Allow' then 'fail'
        WHEN
        properties -> 'privateEndpointConnections' IS null THEN 'pass'
        WHEN
        properties -> 'privateEndpointConnections' @> '[{"PrivateLinkServiceConnectionStateStatus": "Approved"}]'
        THEN 'pass'
        ELSE 'fail'
    END                                                                      AS status
FROM azure_keyvault_keyvaults
{% endmacro %}


{% macro snowflake__keyvault_vault_private_link_used(framework, check_id) %}
SELECT
    id                                                                       AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure that Private Endpoints are Used for Azure Key Vault' AS title,
    subscription_id                                                          AS subscription_id,
    CASE
        WHEN properties:networkAcls IS null
        OR properties:networkAcls:defaultAction = 'Allow' then 'fail'
        WHEN
        properties:privateEndpointConnections IS null THEN 'pass'
        WHEN
        ARRAY_CONTAINS('{"PrivateLinkServiceConnectionStateStatus": "Approved"}'::variant, properties:privateEndpointConnections)
        THEN 'pass'
        ELSE 'fail'
    END                                                                      AS status
FROM azure_keyvault_keyvaults
{% endmacro %}

{% macro bigquery__keyvault_vault_private_link_used(framework, check_id) %}
SELECT
    id                                                                       AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure that Private Endpoints are Used for Azure Key Vault' AS title,
    subscription_id                                                          AS subscription_id,
    CASE
        WHEN JSON_VALUE(properties.networkAcls) IS null
        OR JSON_VALUE(properties.networkAcls.defaultAction) = 'Allow' then 'fail'
        WHEN
        JSON_VALUE(properties.privateEndpointConnections) IS null THEN 'pass'
        WHEN
        '{"PrivateLinkServiceConnectionStateStatus": "Approved"}' IN UNNEST(JSON_EXTRACT_STRING_ARRAY(properties.privateEndpointConnections))
        THEN 'pass'
        ELSE 'fail'
    END                                                                      AS status
FROM {{ full_table_name("azure_keyvault_keyvaults") }}
{% endmacro %}

