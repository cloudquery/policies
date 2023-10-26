{% macro sql_data_encryption_off(framework, check_id) %}

SELECT
  s._cq_sync_time As sync_time,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure that "Data encryption" is set to "On" on a SQL Database (Automated)' as title,
  s.subscription_id,
  asd.id AS database_id,
  case
    when tde.properties->>'state' is distinct from 'Enabled'
    then 'fail'
    else 'pass'
  end
FROM azure_sql_servers s
    LEFT JOIN azure_sql_server_databases asd ON
        s._cq_id = asd._cq_parent_id
    LEFT JOIN azure_sql_transparent_data_encryptions tde ON
        asd._cq_id = tde._cq_parent_id
WHERE asd.name != 'master'
{% endmacro %}