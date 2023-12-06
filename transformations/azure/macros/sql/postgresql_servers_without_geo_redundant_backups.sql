{% macro sql_postgresql_servers_without_geo_redundant_backups(framework, check_id) %}

SELECT
  id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Geo-redundant backup should be enabled for Azure Database for PostgreSQL' as title,
  subscription_id,
  case
    when properties -> 'storageProfile'->>'geoRedundantBackup' IS DISTINCT FROM 'Enabled'
      then 'fail' else 'pass'
  end
FROM azure_postgresql_servers
{% endmacro %}