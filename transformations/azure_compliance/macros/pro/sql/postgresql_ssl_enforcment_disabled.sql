{% macro sql_postgresql_ssl_enforcment_disabled(framework, check_id) %}
  {{ return(adapter.dispatch('sql_postgresql_ssl_enforcment_disabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__sql_postgresql_ssl_enforcment_disabled(framework, check_id) %}{% endmacro %}

{% macro postgres__sql_postgresql_ssl_enforcment_disabled(framework, check_id) %}
SELECT
  _cq_sync_time As sync_time,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure "Enforce SSL connection" is set to "ENABLED" for PostgreSQL Database Server (Automated)' as title,
  subscription_id,
  id AS server_id,
  case
    when properties->>'sslEnforcement'  is distinct from 'Enabled'
      then 'fail' else 'pass'
  end
FROM azure_postgresql_servers
{% endmacro %}

{% macro snowflake__sql_postgresql_ssl_enforcment_disabled(framework, check_id) %}
SELECT
  _cq_sync_time As sync_time,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure "Enforce SSL connection" is set to "ENABLED" for PostgreSQL Database Server (Automated)' as title,
  subscription_id,
  id AS server_id,
  case
    when properties:sslEnforcement is distinct from 'Enabled'
      then 'fail' else 'pass'
  end as status
FROM azure_postgresql_servers
{% endmacro %}