{% macro storage_default_network_access_rule_is_deny(framework, check_id) %}
  {{ return(adapter.dispatch('storage_default_network_access_rule_is_deny')(framework, check_id)) }}
{% endmacro %}

{% macro default__storage_default_network_access_rule_is_deny(framework, check_id) %}{% endmacro %}

{% macro postgres__storage_default_network_access_rule_is_deny(framework, check_id) %}
SELECT
    id                                                                       AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure default network access rule for Storage Accounts is set to deny' AS title,
    subscription_id                                                          AS subscription_id,
    CASE
        WHEN properties->'networkAcls'->>'defaultAction' = 'Allow'
        THEN 'fail'
        ELSE 'pass'
    END                                                                      AS status
FROM azure_storage_accounts
{% endmacro %}

{% macro snowflake__storage_default_network_access_rule_is_deny(framework, check_id) %}
SELECT
    id                                                                       AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure default network access rule for Storage Accounts is set to deny' AS title,
    subscription_id                                                          AS subscription_id,
    CASE
        WHEN properties:networkAcls:defaultAction = 'Allow'
        THEN 'fail'
        ELSE 'pass'
    END                                                                      AS status
FROM azure_storage_accounts
{% endmacro %}

{% macro bigquery__storage_default_network_access_rule_is_deny(framework, check_id) %}
SELECT
    id                                                                       AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure default network access rule for Storage Accounts is set to deny' AS title,
    subscription_id                                                          AS subscription_id,
    CASE
        WHEN JSON_VALUE(properties.networkAcls.defaultAction) = 'Allow'
        THEN 'fail'
        ELSE 'pass'
    END                                                                      AS status
FROM {{ full_table_name("azure_storage_accounts") }}
{% endmacro %}