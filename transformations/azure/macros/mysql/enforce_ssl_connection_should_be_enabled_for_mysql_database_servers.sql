{% macro mysql_enforce_ssl_connection_should_be_enabled_for_mysql_database_servers(framework, check_id) %}

SELECT
  id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Enforce SSL connection should be enabled for MySQL database servers',
  subscription_id,
  case
    when properties->>'sslEnforcement' IS DISTINCT FROM 'Enabled'
    then 'fail' else 'pass'
  end
FROM azure_mysql_servers
{% endmacro %}