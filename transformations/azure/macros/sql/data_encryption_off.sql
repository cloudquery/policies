{% macro sql_data_encryption_off(framework, check_id) %}
  {{ return(adapter.dispatch('sql_data_encryption_off')(framework, check_id)) }}
{% endmacro %}

{% macro default__sql_data_encryption_off(framework, check_id) %}{% endmacro %}

{% macro postgres__sql_data_encryption_off(framework, check_id) %}
SELECT
  asd.id AS database_id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure that "Data encryption" is set to "On" on a SQL Database (Automated)' as title,
  s.subscription_id,
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

{% macro snowflake__sql_data_encryption_off(framework, check_id) %}
SELECT
  asd.id AS database_id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure that "Data encryption" is set to "On" on a SQL Database (Automated)' as title,
  s.subscription_id,
  CASE
    WHEN tde.properties:state IS DISTINCT FROM 'Enabled'
    THEN 'fail'
    ELSE 'pass'
  END
FROM azure_sql_servers s
    LEFT JOIN azure_sql_server_databases asd ON
        s._cq_id = asd._cq_parent_id
    LEFT JOIN azure_sql_transparent_data_encryptions tde ON
        asd._cq_id = tde._cq_parent_id
WHERE asd.name != 'master'
{% endmacro %}