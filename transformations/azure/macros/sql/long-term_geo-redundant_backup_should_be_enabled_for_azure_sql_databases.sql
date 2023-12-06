{% macro sql_long_term_geo_redundant_backup_should_be_enabled_for_azure_sql_databases(framework, check_id) %}

SELECT
  rp.id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Long-term geo-redundant backup should be enabled for Azure SQL Databases' as title,
  s.subscription_id,
  case
    when rp.id IS NULL OR (rp.properties ->> 'weeklyRetention' IS NOT DISTINCT FROM 'PT0S'
      AND rp.properties ->> 'monthlyRetention' IS NOT DISTINCT FROM 'PT0S'
      AND rp.properties ->> 'yearlyRetention' IS NOT DISTINCT FROM 'PT0S')
    then 'fail' else 'pass'
  end
FROM azure_sql_servers s left join azure_sql_server_databases asd on s._cq_id = asd._cq_parent_id
    left join azure_sql_server_database_long_term_retention_policies rp on asd._cq_id = rp._cq_parent_id

{% endmacro %}