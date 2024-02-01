{% macro monitor_basic_or_consumption_sku_not_used(framework, check_id) %}
  {{ return(adapter.dispatch('monitor_basic_or_consumption_sku_not_used')(framework, check_id)) }}
{% endmacro %}

{% macro default__monitor_basic_or_consumption_sku_not_used(framework, check_id) %}{% endmacro %}

{% macro postgres__monitor_basic_or_consumption_sku_not_used(framework, check_id) %}
SELECT
    id                                                                       AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure that SKU Basic/Consumption is not used on artifacts that need to be monitored (Particularly for Production Workloads) (Automated)' AS title,
    subscription_id                                                          AS subscription_id,
    CASE
        WHEN sku ->> name like '%Basic%' or sku ->> name like '%consumption%'
        THEN 'fail'
        ELSE 'pass'
    END                                                                          AS status
FROM azure_monitor_resources 
    
        
{% endmacro %}

{% macro snowflake__monitor_basic_or_consumption_sku_not_used(framework, check_id) %}
SELECT
    id                                                                       AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure that SKU Basic/Consumption is not used on artifacts that need to be monitored (Particularly for Production Workloads) (Automated)' AS title,
    subscription_id                                                          AS subscription_id,
    CASE
        WHEN sku:name like '%Basic%' or sku:name like '%consumption%'
        THEN 'fail'
        ELSE 'pass'
    END                                                                          AS status
FROM azure_monitor_resources 
    
        
{% endmacro %}

{% macro bigquery__monitor_basic_or_consumption_sku_not_used(framework, check_id) %}
SELECT
    id                                                                       AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure that SKU Basic/Consumption is not used on artifacts that need to be monitored (Particularly for Production Workloads) (Automated)' AS title,
    subscription_id                                                          AS subscription_id,
    CASE
        WHEN JSON_VALUE(sku.name) like '%Basic%' or JSON_VALUE(sku.name) like '%consumption%'
        THEN 'fail'
        ELSE 'pass'
        END                                                                          AS status
FROM {{ full_table_name("azure_monitor_resources") }} 
        
{% endmacro %}