{% macro sql_va_periodic_scans_enabled_on_sql_server(framework, check_id) %}

SELECT 
  s._cq_sync_time As sync_time,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure that VA setting Periodic Recurring Scans is enabled on a SQL server (Automated)' as title,
  s.subscription_id,
  s.id,
  case
    when (a.properties->'recurringScans'->>'isEnabled')::boolean IS DISTINCT FROM TRUE
      then 'fail' else 'pass'
  end
FROM azure_sql_servers s
    LEFT JOIN azure_sql_server_vulnerability_assessments a ON
        s._cq_id = a._cq_parent_id
{% endmacro %}