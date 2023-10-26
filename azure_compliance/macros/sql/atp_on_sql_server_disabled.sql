{% macro sql_atp_on_sql_server_disabled(framework, check_id) %}

SELECT
  s._cq_sync_time As sync_time,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure that Advanced Threat Protection (ATP) on a SQL server is set to "Enabled" (Automated)' as title,
  s.subscription_id,
  s.id AS server_id,
  case
    when atp.properties->>'state' is distinct from 'Enabled'
    then 'fail' else 'pass'
  end
FROM azure_sql_servers s
    JOIN azure_sql_server_advanced_threat_protection_settings atp ON s._cq_id = atp._cq_parent_id
{% endmacro %}