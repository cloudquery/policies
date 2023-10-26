{% macro network_nsg_log_retention_period(framework, check_id) %}

SELECT
    _cq_sync_time As sync_time,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure that Network Security Group Flow Log retention period is ''greater than 90 days''' AS title,
    subscription_id                                                                            AS subscription_id,
    id                                                                                         AS resource_id,
    CASE
        WHEN (properties->'retentionPolicy'->>'days')::INT >= 90
        THEN 'pass'
        ELSE 'fail'
    END                                                                                        AS status
FROM azure_network_watcher_flow_logs
{% endmacro %}