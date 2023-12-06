{% macro sql_postgresql_log_retention_days_less_than_3_days(framework, check_id) %}
  {{ return(adapter.dispatch('sql_postgresql_log_retention_days_less_than_3_days')(framework, check_id)) }}
{% endmacro %}

{% macro default__sql_postgresql_log_retention_days_less_than_3_days(framework, check_id) %}{% endmacro %}

{% macro postgres__sql_postgresql_log_retention_days_less_than_3_days(framework, check_id) %}
WITH value_check AS (
    SELECT aps._cq_id, apsc.properties->>'value' as "value"
    FROM azure_postgresql_servers aps
        LEFT JOIN azure_postgresql_server_configurations apsc ON
            aps._cq_id = apsc._cq_parent_id
    WHERE apsc."name" = 'log_retention_days'
)

SELECT
  s.id AS server_id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure server parameter "log_retention_days" is greater than 3 days for PostgreSQL Database Server (Automated)' as title,
  s.subscription_id,
  case
    when v.value IS NULL OR v.value::INTEGER < 3
      then 'fail' else 'pass'
  end
FROM azure_postgresql_servers s
    LEFT JOIN value_check v ON
        s._cq_id = v._cq_id
{% endmacro %}

{% macro snowflake__sql_postgresql_log_retention_days_less_than_3_days(framework, check_id) %}
WITH value_check AS (
    SELECT aps._cq_id, apsc.properties:value as value
    FROM azure_postgresql_servers aps
        LEFT JOIN azure_postgresql_server_configurations apsc ON
            aps._cq_id = apsc._cq_parent_id
    WHERE apsc.name = 'log_retention_days'
)

SELECT
  s.id AS server_id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure server parameter "log_retention_days" is greater than 3 days for PostgreSQL Database Server (Automated)' as title,
  s.subscription_id,
  case
    when v.value IS NULL OR v.value::INTEGER < 3
      then 'fail' else 'pass'
  end
FROM azure_postgresql_servers s
    LEFT JOIN value_check v ON
        s._cq_id = v._cq_id
{% endmacro %}