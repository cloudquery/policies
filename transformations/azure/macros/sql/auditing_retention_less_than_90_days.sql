{% macro sql_auditing_retention_less_than_90_days(framework, check_id) %}
  {{ return(adapter.dispatch('sql_auditing_retention_less_than_90_days')(framework, check_id)) }}
{% endmacro %}

{% macro default__sql_auditing_retention_less_than_90_days(framework, check_id) %}{% endmacro %}

{% macro postgres__sql_auditing_retention_less_than_90_days(framework, check_id) %}
SELECT
  s.id AS server_id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure that "Auditing" Retention is "greater than 90 days" (Automated)' as title,
  s.subscription_id,
  case
    when (assdbap.properties->'retentionDays')::int < 90
      then 'fail' else 'pass'
  end
FROM azure_sql_servers s
    LEFT JOIN azure_sql_server_blob_auditing_policies assdbap ON
        s._cq_id = assdbap._cq_parent_id
{% endmacro %}

{% macro snowflake__sql_auditing_retention_less_than_90_days(framework, check_id) %}
SELECT
  s.id AS server_id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure that "Auditing" Retention is "greater than 90 days" (Automated)' as title,
  s.subscription_id,
  case
    when (assdbap.properties:retentionDays)::int < 90
      then 'fail' else 'pass'
  end
FROM azure_sql_servers s
    LEFT JOIN azure_sql_server_blob_auditing_policies assdbap ON
        s._cq_id = assdbap._cq_parent_id
{% endmacro %}

{% macro bigquery__sql_auditing_retention_less_than_90_days(framework, check_id) %}
SELECT
  s.id AS server_id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure that "Auditing" Retention is "greater than 90 days" (Automated)' as title,
  s.subscription_id,
  case
    when CAST(JSON_VALUE(assdbap.properties.retentionDays) AS INT64) < 90
      then 'fail' else 'pass'
  end
FROM {{ full_table_name("azure_sql_servers") }} s
    LEFT JOIN {{ full_table_name("azure_sql_server_blob_auditing_policies") }} assdbap ON
        s._cq_id = assdbap._cq_parent_id
{% endmacro %}