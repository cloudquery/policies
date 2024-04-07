{% macro storage_account_public_network_access(framework, check_id) %}
  {{ return(adapter.dispatch('storage_account_public_network_access')(framework, check_id)) }}
{% endmacro %}

{% macro default__storage_account_public_network_access(framework, check_id) %}{% endmacro %}

{% macro postgres__storage_account_public_network_access(framework, check_id) %}
SELECT
    id                                                                     AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure that Public Network Access is Disabled for storage accounts' AS title,
    subscription_id                                                        AS subscription_id,
    CASE
        WHEN properties->>'publicNetworkAccess' != 'Disabled'
        THEN 'fail'
        ELSE 'pass'
    END                                                                         AS status
FROM azure_storage_accounts
{% endmacro %}

{% macro snowflake__storage_account_public_network_access(framework, check_id) %}
SELECT
    id                                                                     AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure that Public Network Access is Disabled for storage accounts' AS title,
    subscription_id                                                        AS subscription_id,
    CASE
        WHEN properties:publicNetworkAccess != 'Disabled'
        THEN 'fail'
        ELSE 'pass'
    END                                                                         AS status
FROM azure_storage_accounts
{% endmacro %}

{% macro bigquery__storage_account_public_network_access(framework, check_id) %}
{% endmacro %}