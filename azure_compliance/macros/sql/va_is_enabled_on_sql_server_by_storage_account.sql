{% macro sql_va_is_enabled_on_sql_server_by_storage_account(framework, check_id) %}

SELECT
  s._cq_sync_time As sync_time,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure that Vulnerability Assessment (VA) is enabled on a SQL server by setting a Storage Account (Automated)' as title,
  s.subscription_id,
  s.id AS server_id,
  case
    when a.properties->>'storageContainerPath' IS NULL OR a.properties->>'storageContainerPath' = ''
      then 'fail' else 'pass'
  end
FROM azure_sql_servers s
    LEFT JOIN azure_sql_server_vulnerability_assessments a ON
        s._cq_id = a._cq_parent_id
{% endmacro %}