{% macro storage_encrypt_with_cmk(framework, check_id) %}
  {{ return(adapter.dispatch('storage_encrypt_with_cmk')(framework, check_id)) }}
{% endmacro %}

{% macro default__storage_encrypt_with_cmk(framework, check_id) %}{% endmacro %}

{% macro postgres__storage_encrypt_with_cmk(framework, check_id) %}
SELECT
    id                                                                         AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure storage for critical data are encrypted with Customer Managed Key' AS title,
    subscription_id                                                            AS subscription_id,
    CASE
        WHEN properties->'encryption'->>'keySource' = 'Microsoft.Keyvault'
         AND properties->'encryption'->'keyvaultproperties' IS DISTINCT FROM NULL
        THEN 'pass'
        ELSE 'fail'
    END                                                                        AS status
FROM azure_storage_accounts
{% endmacro %}

{% macro snowflake__storage_encrypt_with_cmk(framework, check_id) %}
SELECT
    id                                                                         AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure storage for critical data are encrypted with Customer Managed Key' AS title,
    subscription_id                                                            AS subscription_id,
    CASE
        WHEN properties:encryption:keySource = 'Microsoft.Keyvault'
         AND properties:encryption:keyvaultproperties IS DISTINCT FROM NULL
        THEN 'pass'
        ELSE 'fail'
    END                                                                        AS status
FROM azure_storage_accounts
{% endmacro %}