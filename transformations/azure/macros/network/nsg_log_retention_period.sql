{% macro network_nsg_log_retention_period(framework, check_id) %}
  {{ return(adapter.dispatch('network_nsg_log_retention_period')(framework, check_id)) }}
{% endmacro %}

{% macro default__network_nsg_log_retention_period(framework, check_id) %}{% endmacro %}

{% macro postgres__network_nsg_log_retention_period(framework, check_id) %}
SELECT
    id                                                                                         AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure that Network Security Group Flow Log retention period is ''greater than 90 days''' AS title,
    subscription_id                                                                            AS subscription_id,
    CASE
        WHEN (properties->'retentionPolicy'->>'days')::INT >= 90
        THEN 'pass'
        ELSE 'fail'
    END                                                                                        AS status
FROM azure_network_watcher_flow_logs
{% endmacro %}

{% macro snowflake__network_nsg_log_retention_period(framework, check_id) %}
SELECT
    id                                                                                         AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure that Network Security Group Flow Log retention period is ''greater than 90 days''' AS title,
    subscription_id                                                                            AS subscription_id,
    CASE
        WHEN (properties:retentionPolicy:days)::INT >= 90
        THEN 'pass'
        ELSE 'fail'
    END                                                                                        AS status
FROM azure_network_watcher_flow_logs
{% endmacro %}

{% macro bigquery__network_nsg_log_retention_period(framework, check_id) %}
SELECT
    id                                                                                         AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure that Network Security Group Flow Log retention period is "greater than 90 days"' AS title,
    subscription_id                                                                            AS subscription_id,
    CASE
        WHEN CAST(JSON_VALUE(properties.retentionPolicy.days) AS INT64) >= 90
        THEN 'pass'
        ELSE 'fail'
    END                                                                                        AS status
FROM {{ full_table_name("azure_network_watcher_flow_logs") }} 
{% endmacro %}