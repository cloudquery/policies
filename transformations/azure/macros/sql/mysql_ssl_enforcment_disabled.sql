{% macro sql_mysql_ssl_enforcment_disabled(framework, check_id) %}
  {{ return(adapter.dispatch('sql_mysql_ssl_enforcment_disabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__sql_mysql_ssl_enforcment_disabled(framework, check_id) %}{% endmacro %}

{% macro postgres__sql_mysql_ssl_enforcment_disabled(framework, check_id) %}
SELECT
  id AS server_id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure "Enforce SSL connection" is set to "ENABLED" for MySQL Database Server (Automated)' as title,
  subscription_id,
  case
    when properties->>'sslEnforcement'  is distinct from 'Enabled'
    then 'fail' else 'pass'
  end
FROM azure_mysql_servers
{% endmacro %}

{% macro snowflake__sql_mysql_ssl_enforcment_disabled(framework, check_id) %}
SELECT
  id AS server_id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure "Enforce SSL connection" is set to "ENABLED" for MySQL Database Server (Automated)' as title,
  subscription_id,
  case
    when properties:sslEnforcement is distinct from 'Enabled'
    then 'fail' else 'pass'
  end
FROM azure_mysql_servers
{% endmacro %}