{% macro sql_va_is_enabled_on_sql_server_by_storage_account(framework, check_id) %}
  {{ return(adapter.dispatch('sql_va_is_enabled_on_sql_server_by_storage_account')(framework, check_id)) }}
{% endmacro %}

{% macro default__sql_va_is_enabled_on_sql_server_by_storage_account(framework, check_id) %}{% endmacro %}

{% macro postgres__sql_va_is_enabled_on_sql_server_by_storage_account(framework, check_id) %}
SELECT
  s.id AS server_id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure that Vulnerability Assessment (VA) is enabled on a SQL server by setting a Storage Account (Automated)' as title,
  s.subscription_id,
  case
    when a.properties->>'storageContainerPath' IS NULL OR a.properties->>'storageContainerPath' = ''
      then 'fail' else 'pass'
  end
FROM azure_sql_servers s
    LEFT JOIN azure_sql_server_vulnerability_assessments a ON
        s._cq_id = a._cq_parent_id
{% endmacro %}

{% macro snowflake__sql_va_is_enabled_on_sql_server_by_storage_account(framework, check_id) %}
SELECT
  s.id AS server_id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure that Vulnerability Assessment (VA) is enabled on a SQL server by setting a Storage Account (Automated)' as title,
  s.subscription_id,
  case
    when a.properties:storageContainerPath IS NULL OR a.properties:storageContainerPath = ''
      then 'fail' else 'pass'
  end
FROM azure_sql_servers s
    LEFT JOIN azure_sql_server_vulnerability_assessments a ON
        s._cq_id = a._cq_parent_id
{% endmacro %}

{% macro bigquery__sql_va_is_enabled_on_sql_server_by_storage_account(framework, check_id) %}
SELECT
  s.id AS server_id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure that Vulnerability Assessment (VA) is enabled on a SQL server by setting a Storage Account (Automated)' as title,
  s.subscription_id,
  case
    when JSON_VALUE(a.properties.storageContainerPath) IS NULL OR JSON_VALUE(a.properties.storageContainerPath) = ''
      then 'fail' else 'pass'
  end
FROM {{ full_table_name("azure_sql_servers") }} s
    LEFT JOIN {{ full_table_name("azure_sql_server_vulnerability_assessments") }} a ON
        s._cq_id = a._cq_parent_id
{% endmacro %}