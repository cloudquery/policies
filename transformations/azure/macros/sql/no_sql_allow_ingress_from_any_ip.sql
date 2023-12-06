{% macro sql_no_sql_allow_ingress_from_any_ip(framework, check_id) %}
  {{ return(adapter.dispatch('sql_no_sql_allow_ingress_from_any_ip')(framework, check_id)) }}
{% endmacro %}

{% macro default__sql_no_sql_allow_ingress_from_any_ip(framework, check_id) %}{% endmacro %}

{% macro postgres__sql_no_sql_allow_ingress_from_any_ip(framework, check_id) %}
SELECT
    id                                                         AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure no SQL Databases allow ingress 0.0.0.0/0 (ANY IP)' AS title,
    subscription_id                                            AS subscription_id,
    CASE
        WHEN properties->>'startIpAddress' = '0.0.0.0'
                 AND (properties->>'endIpAddress' = '0.0.0.0' OR properties->>'endIpAddress' = '255.255.255.255')
        THEN 'fail'
        ELSE 'pass'
    END                                                        AS status
FROM azure_sql_server_firewall_rules
{% endmacro %}

{% macro snowflake__sql_no_sql_allow_ingress_from_any_ip(framework, check_id) %}
SELECT
    id                                                         AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure no SQL Databases allow ingress 0.0.0.0/0 (ANY IP)' AS title,
    subscription_id                                            AS subscription_id,
    CASE
        WHEN properties:startIpAddress = '0.0.0.0'
                 AND (properties:endIpAddress = '0.0.0.0' OR properties:endIpAddress = '255.255.255.255')
        THEN 'fail'
        ELSE 'pass'
    END                                                        AS status
FROM azure_sql_server_firewall_rules
{% endmacro %}