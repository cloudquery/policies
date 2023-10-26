{% macro sql_mysql_ssl_enforcment_disabled(framework, check_id) %}

SELECT
  _cq_sync_time As sync_time,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure "Enforce SSL connection" is set to "ENABLED" for MySQL Database Server (Automated)' as title,
  subscription_id,
  id AS server_id,
  case
    when properties->>'sslEnforcement'  is distinct from 'Enabled'
    then 'fail' else 'pass'
  end
FROM azure_mysql_servers
{% endmacro %}