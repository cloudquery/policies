{% macro sql_atp_on_sql_server_disabled(framework, check_id) %}
  {{ return(adapter.dispatch('sql_atp_on_sql_server_disabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__sql_atp_on_sql_server_disabled(framework, check_id) %}{% endmacro %}

{% macro postgres__sql_atp_on_sql_server_disabled(framework, check_id) %}
SELECT
  s.id AS server_id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure that Advanced Threat Protection (ATP) on a SQL server is set to "Enabled" (Automated)' as title,
  s.subscription_id,
  case
    when atp.properties->>'state' is distinct from 'Enabled'
    then 'fail' else 'pass'
  end
FROM azure_sql_servers s
    JOIN azure_sql_server_advanced_threat_protection_settings atp ON s._cq_id = atp._cq_parent_id
{% endmacro %}

{% macro snowflake__sql_atp_on_sql_server_disabled(framework, check_id) %}
SELECT
  s.id AS server_id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure that Advanced Threat Protection (ATP) on a SQL server is set to "Enabled" (Automated)' as title,
  s.subscription_id,
  case
    when atp.properties:state is distinct from 'Enabled'
    then 'fail' else 'pass'
  end
FROM azure_sql_servers s
    JOIN azure_sql_server_advanced_threat_protection_settings atp ON s._cq_id = atp._cq_parent_id
{% endmacro %}