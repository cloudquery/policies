{% macro storage_account_min_tls_1_2(framework, check_id) %}
  {{ return(adapter.dispatch('storage_account_min_tls_1_2')(framework, check_id)) }}
{% endmacro %}

{% macro default__storage_account_min_tls_1_2(framework, check_id) %}{% endmacro %}

{% macro postgres__storage_account_min_tls_1_2(framework, check_id) %}
SELECT
    id                                                                     AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure the "Minimum TLS version" for storage accounts is set to "Version 1.2"' AS title,
    subscription_id                                                        AS subscription_id,
    CASE
        WHEN properties ->> 'minimumTlsVersion' != 'TLS1_2'
        THEN 'fail'
        ELSE 'pass'
    END                                                                         AS status
FROM azure_storage_accounts
{% endmacro %}

{% macro snowflake__storage_account_min_tls_1_2(framework, check_id) %}
SELECT
    id                                                                     AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure the "Minimum TLS version" for storage accounts is set to "Version 1.2"' AS title,
    subscription_id                                                        AS subscription_id,
    CASE
        WHEN properties:minimumTlsVersion != 'TLS1_2'
        THEN 'fail'
        ELSE 'pass'
    END                                                                         AS status
FROM azure_storage_accounts
{% endmacro %}

{% macro bigquery__storage_account_min_tls_1_2(framework, check_id) %}
{% endmacro %}