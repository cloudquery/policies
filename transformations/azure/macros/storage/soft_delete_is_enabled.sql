{% macro storage_soft_delete_is_enabled(framework, check_id) %}
  {{ return(adapter.dispatch('storage_soft_delete_is_enabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__storage_soft_delete_is_enabled(framework, check_id) %}{% endmacro %}

{% macro postgres__storage_soft_delete_is_enabled(framework, check_id) %}
SELECT
    id                                                AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure soft delete is enabled for Azure Storage' AS title,
    subscription_id                                   AS subscription_id,
    CASE
        WHEN (properties->'deleteRetentionPolicy'->>'enabled')::boolean
        THEN 'pass'
        ELSE 'fail'
    END                                               AS status
FROM azure_storage_blob_services
{% endmacro %}

{% macro snowflake__storage_soft_delete_is_enabled(framework, check_id) %}
SELECT
    id                                                AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure soft delete is enabled for Azure Storage' AS title,
    subscription_id                                   AS subscription_id,
    CASE
        WHEN (properties:deleteRetentionPolicy:enabled)::boolean
        THEN 'pass'
        ELSE 'fail'
    END                                               AS status
FROM azure_storage_blob_services
{% endmacro %}

{% macro bigquery__storage_soft_delete_is_enabled(framework, check_id) %}
SELECT
    id                                                AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure soft delete is enabled for Azure Storage' AS title,
    subscription_id                                   AS subscription_id,
    CASE
        WHEN CAST( JSON_VALUE(properties.deleteRetentionPolicy.enabled) AS BOOL)
        THEN 'pass'
        ELSE 'fail'
    END                                               AS status
FROM {{ full_table_name("azure_storage_blob_services") }}
{% endmacro %}