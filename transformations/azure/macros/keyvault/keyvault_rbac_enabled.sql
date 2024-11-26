{% macro keyvault_rbac_enabled(framework, check_id) %}
  {{ return(adapter.dispatch('keyvault_rbac_enabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__keyvault_rbac_enabled(framework, check_id) %}{% endmacro %}

{% macro postgres__keyvault_rbac_enabled(framework, check_id) %}
SELECT
    id                                                                       AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Enable Role Based Access Control for Azure Key Vault' AS title,
    subscription_id                                                          AS subscription_id,
    CASE
        WHEN (properties ->> 'enableRbacAuthorization')::boolean IS distinct from TRUE
        THEN 'fail'
        ELSE 'pass'
    END                                                                      AS status
FROM azure_keyvault_keyvaults
{% endmacro %}

{% macro snowflake__keyvault_rbac_enabled(framework, check_id) %}
SELECT
    id                                                                       AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Enable Role Based Access Control for Azure Key Vault' AS title,
    subscription_id                                                          AS subscription_id,
    CASE
        WHEN (properties:enableRbacAuthorization)::boolean IS distinct from TRUE
        THEN 'fail'
        ELSE 'pass'
    END                                                                      AS status
FROM azure_keyvault_keyvaults
{% endmacro %}

{% macro bigquery__keyvault_rbac_enabled(framework, check_id) %}
SELECT
    id                                                                       AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Enable Role Based Access Control for Azure Key Vault' AS title,
    subscription_id                                                          AS subscription_id,
    CASE
        WHEN CAST( JSON_VALUE(properties.enableRbacAuthorization) AS BOOL) IS distinct from TRUE
        THEN 'fail'
        ELSE 'pass'
    END                                                                      AS status
FROM {{ full_table_name("azure_keyvault_keyvaults") }}
{% endmacro %}

