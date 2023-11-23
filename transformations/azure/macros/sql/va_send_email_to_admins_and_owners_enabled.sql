{% macro sql_va_send_email_to_admins_and_owners_enabled(framework, check_id) %}
  {{ return(adapter.dispatch('sql_va_send_email_to_admins_and_owners_enabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__sql_va_send_email_to_admins_and_owners_enabled(framework, check_id) %}{% endmacro %}

{% macro postgres__sql_va_send_email_to_admins_and_owners_enabled(framework, check_id) %}
SELECT
  s._cq_sync_time As sync_time,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure that VA setting "Also send email notifications to admins and subscription owners" is set for a SQL server (Automated)' as title,
  s.subscription_id,
  s.id AS server_id,
  case
    when (a.properties->'recurringScans'->>'emailSubscriptionAdmins')::boolean IS DISTINCT FROM TRUE
      then 'fail' else 'pass'
  end
FROM azure_sql_servers s
    LEFT JOIN azure_sql_server_vulnerability_assessments a ON
        s._cq_id = a._cq_parent_id
{% endmacro %}

{% macro snowflake__sql_va_send_email_to_admins_and_owners_enabled(framework, check_id) %}
SELECT
  s._cq_sync_time As sync_time,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure that VA setting "Also send email notifications to admins and subscription owners" is set for a SQL server (Automated)' as title,
  s.subscription_id,
  s.id AS server_id,
  case
    when (a.properties:recurringScans:emailSubscriptionAdmins)::boolean IS DISTINCT FROM TRUE
      then 'fail' else 'pass'
  end
FROM azure_sql_servers s
    LEFT JOIN azure_sql_server_vulnerability_assessments a ON
        s._cq_id = a._cq_parent_id
{% endmacro %}