{% macro storage_soft_delete_is_enabled(framework, check_id) %}

SELECT
    _cq_sync_time As sync_time,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure soft delete is enabled for Azure Storage' AS title,
    subscription_id                                   AS subscription_id,
    id                                                AS resource_id,
    CASE
        WHEN (properties->'deleteRetentionPolicy'->>'enabled')::boolean
        THEN 'pass'
        ELSE 'fail'
    END                                               AS status
FROM azure_storage_blob_services
{% endmacro %}