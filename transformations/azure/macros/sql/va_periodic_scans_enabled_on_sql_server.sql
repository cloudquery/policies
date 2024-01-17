{% macro sql_va_periodic_scans_enabled_on_sql_server(framework, check_id) %}
  {{ return(adapter.dispatch('sql_va_periodic_scans_enabled_on_sql_server')(framework, check_id)) }}
{% endmacro %}

{% macro default__sql_va_periodic_scans_enabled_on_sql_server(framework, check_id) %}{% endmacro %}

{% macro postgres__sql_va_periodic_scans_enabled_on_sql_server(framework, check_id) %}
SELECT 
  s.id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure that VA setting Periodic Recurring Scans is enabled on a SQL server (Automated)' as title,
  s.subscription_id,
  case
    when (a.properties->'recurringScans'->>'isEnabled')::boolean IS DISTINCT FROM TRUE
      then 'fail' else 'pass'
  end
FROM azure_sql_servers s
    LEFT JOIN azure_sql_server_vulnerability_assessments a ON
        s._cq_id = a._cq_parent_id
{% endmacro %}

{% macro snowflake__sql_va_periodic_scans_enabled_on_sql_server(framework, check_id) %}
SELECT 
  s.id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id, 
  'Ensure that VA setting Periodic Recurring Scans is enabled on a SQL server (Automated)' as title,
  s.subscription_id,
  case
    when (a.properties:recurringScans:isEnabled)::boolean IS DISTINCT FROM TRUE
      then 'fail' else 'pass'
  end
FROM azure_sql_servers s
    LEFT JOIN azure_sql_server_vulnerability_assessments a ON
        s._cq_id = a._cq_parent_id
{% endmacro %}

{% macro bigquery__sql_va_periodic_scans_enabled_on_sql_server(framework, check_id) %}
SELECT 
  s.id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id, 
  'Ensure that VA setting Periodic Recurring Scans is enabled on a SQL server (Automated)' as title,
  s.subscription_id,
  case
    when CAST( JSON_VALUE(a.properties.recurringScans.isEnabled) AS BOOL) IS DISTINCT FROM TRUE
      then 'fail' else 'pass'
  end
FROM {{ full_table_name("azure_sql_servers") }} s
    LEFT JOIN {{ full_table_name("azure_sql_server_vulnerability_assessments") }} a ON
        s._cq_id = a._cq_parent_id
{% endmacro %}