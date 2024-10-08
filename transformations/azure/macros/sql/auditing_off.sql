{% macro sql_auditing_off(framework, check_id) %}
  {{ return(adapter.dispatch('sql_auditing_off')(framework, check_id)) }}
{% endmacro %}

{% macro default__sql_auditing_off(framework, check_id) %}{% endmacro %}

{% macro postgres__sql_auditing_off(framework, check_id) %}
SELECT
  s.id AS server_id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure that "Auditing" is set to "On" (Automated)' as title,
  s.subscription_id,
  case
    when assdbap.properties->>'state' != 'Enabled'
      then 'fail'
      else 'pass'
  end
FROM azure_sql_servers s
    LEFT JOIN azure_sql_server_databases assd ON
        s._cq_id = assd._cq_parent_id
    LEFT JOIN azure_sql_server_database_blob_auditing_policies assdbap ON
        assd._cq_id = assdbap._cq_parent_id
{% endmacro %}

{% macro snowflake__sql_auditing_off(framework, check_id) %}
SELECT
  s.id AS server_id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure that "Auditing" is set to "On" (Automated)' as title,
  s.subscription_id,
  case
    when assdbap.properties:state != 'Enabled'
      then 'fail'
      else 'pass'
  end
FROM azure_sql_servers s
    LEFT JOIN azure_sql_server_databases assd ON
        s._cq_id = assd._cq_parent_id
    LEFT JOIN azure_sql_server_database_blob_auditing_policies assdbap ON
        assd._cq_id = assdbap._cq_parent_id
{% endmacro %}

{% macro bigquery__sql_auditing_off(framework, check_id) %}
SELECT
  s.id AS server_id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure that "Auditing" is set to "On" (Automated)' as title,
  s.subscription_id,
  case
    when JSON_VALUE(assdbap.properties.state) != 'Enabled'
      then 'fail'
      else 'pass'
  end
FROM {{ full_table_name("azure_sql_servers") }} s
    LEFT JOIN {{ full_table_name("azure_sql_server_databases") }} assd ON
        s._cq_id = assd._cq_parent_id
    LEFT JOIN {{ full_table_name("azure_sql_server_database_blob_auditing_policies") }} assdbap ON
        assd._cq_id = assdbap._cq_parent_id
{% endmacro %}