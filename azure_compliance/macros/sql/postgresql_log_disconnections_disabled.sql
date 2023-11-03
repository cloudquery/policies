{% macro sql_postgresql_log_disconnections_disabled(framework, check_id) %}
WITH value_check AS (
    SELECT aps._cq_id, apsc.properties->>'value' as "value"
    FROM azure_postgresql_servers aps
        LEFT JOIN azure_postgresql_server_configurations apsc ON
            aps._cq_id = apsc._cq_parent_id
    WHERE apsc."name" = 'log_disconnections'
)

SELECT
  s._cq_sync_time As sync_time,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure server parameter "log_disconnections" is set to "ON" for PostgreSQL Database Server (Automated)' as title,
  s.subscription_id,
  s.id AS server_id,
  case 
    when v.value IS NULL OR v.value != 'on'
      then 'fail' else 'pass'
  end
FROM azure_postgresql_servers s
    LEFT JOIN value_check v ON
        s._cq_id = v._cq_id
{% endmacro %}