{% macro sql_mysql_audit_log_events_include_connection(framework, check_id) %}
  {{ return(adapter.dispatch('sql_mysql_audit_log_events_include_connection')(framework, check_id)) }}
{% endmacro %}

{% macro default__sql_mysql_audit_log_events_include_connection(framework, check_id) %}{% endmacro %}

{% macro postgres__sql_mysql_audit_log_events_include_connection(framework, check_id) %}
WITH value_check AS (
    SELECT msql_s._cq_id, msql_sc.properties->>'value' as "value"
    FROM azure_mysql_servers msql_s
        LEFT JOIN azure_mysql_server_configurations msql_sc ON
            msql_s._cq_id = msql_sc._cq_parent_id
        WHERE msql_sc.name = 'audit_log_events'
)

SELECT
  s.id AS server_id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure server parameter "audit_log_enabled" is set to "ON" for MySQL Database Server (Manual)' as title,
  s.subscription_id,
  case
    when lower(v.value) is not like '%connection%'
      then 'fail' else 'pass'
  end
FROM azure_mysql_servers s
    LEFT JOIN value_check v ON
        s._cq_id = v._cq_id
{% endmacro %}

{% macro snowflake__sql_mysql_audit_log_events_include_connection(framework, check_id) %}
WITH value_check AS (
    SELECT msql_s._cq_id, msql_sc.properties:infrastructureEncryption as value
    FROM azure_mysql_servers msql_s
        LEFT JOIN azure_mysql_server_configurations msql_sc ON
            msql_s._cq_id = msql_sc._cq_parent_id
        WHERE msql_sc.name = 'audit_log_events'
)

SELECT
  s.id AS server_id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure server parameter "audit_log_enabled" is set to "ON" for MySQL Database Server (Manual)' as title,
  s.subscription_id,
  case
    when lower(v.value) is not like '%connection%'
      then 'fail' else 'pass'
  end
FROM azure_mysql_servers s
    LEFT JOIN value_check v ON
        s._cq_id = v._cq_id
{% endmacro %}

{% macro bigquery__sql_mysql_audit_log_events_include_connection(framework, check_id) %}
WITH value_check AS (
    SELECT msql_s._cq_id, JSON_VALUE(msql_sc.properties.value) as prop
    FROM {{ full_table_name("azure_mysql_servers") }} msql_s
        LEFT JOIN {{ full_table_name("azure_mysql_server_configurations") }} msql_sc ON
            msql_s._cq_id = msql_sc._cq_parent_id
        WHERE msql_sc.name = 'audit_log_events'
)

SELECT
  s.id AS server_id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure server parameter "audit_log_enabled" is set to "ON" for MySQL Database Server (Manual)' as title,
  s.subscription_id,
  case
    when lower(v.prop) not like '%connection%'
      then 'fail' else 'pass'
  end
FROM {{ full_table_name("azure_mysql_servers") }} s
    LEFT JOIN value_check v ON
        s._cq_id = v._cq_id
{% endmacro %}
