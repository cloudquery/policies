{% macro sql_mariadb_servers_without_geo_redundant_backups(framework, check_id) %}

SELECT 
  _cq_sync_time As sync_time,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Geo-redundant backup should be enabled for Azure Database for MariaDB' as title,
  subscription_id,
  id,
  case
    when properties -> 'storageProfile'->>'geoRedundantBackup' IS DISTINCT FROM 'Enabled'
      then 'fail' else 'pass'
  end
FROM azure_mariadb_servers{% endmacro %}