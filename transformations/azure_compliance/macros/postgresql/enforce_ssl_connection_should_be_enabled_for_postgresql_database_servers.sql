{% macro postgresql_enforce_ssl_connection_should_be_enabled_for_postgresql_database_servers(framework, check_id) %}

SELECT
  _cq_sync_time As sync_time,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Enforce SSL connection should be enabled for PostgreSQL database servers',
  subscription_id,
  id,
  case
    when properties->>'sslEnforcement' IS DISTINCT FROM 'Enabled'
    then 'fail' else 'pass'
  end
FROM azure_postgresql_servers
{% endmacro %}