{% macro sql_postgresql_allow_access_to_azure_services_enabled(framework, check_id) %}

SELECT
  aps._cq_sync_time As sync_time,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure "Allow access to Azure services" for PostgreSQL Database Server is disabled (Automated)' as title,
  aps.subscription_id,
  aps.id AS server_id,
  case
    when apsfr."name" = 'AllowAllAzureIps'
      OR (apsfr.properties->>'startIPAddress' = '0.0.0.0'
      AND apsfr.properties->>'endIPAddress' = '0.0.0.0')
    then 'fail' else 'pass'
  end
FROM azure_postgresql_servers aps
    LEFT JOIN azure_postgresql_server_firewall_rules apsfr ON
        aps._cq_id = apsfr._cq_parent_id
{% endmacro %}