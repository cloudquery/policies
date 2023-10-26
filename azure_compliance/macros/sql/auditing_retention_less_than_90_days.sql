{% macro sql_auditing_retention_less_than_90_days(framework, check_id) %}

SELECT
  s._cq_sync_time As sync_time,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure that "Auditing" Retention is "greater than 90 days" (Automated)' as title,
  s.subscription_id,
  s.id AS server_id,
  case
    when (assdbap.properties->'retentionDays')::int < 90
      then 'fail' else 'pass'
  end
FROM azure_sql_servers s
    LEFT JOIN azure_sql_server_blob_auditing_policies assdbap ON
        s._cq_id = assdbap._cq_parent_id
{% endmacro %}