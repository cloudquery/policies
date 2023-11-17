{% macro security_defender_on_for_sql_servers(framework, check_id) %}
  {{ return(adapter.dispatch('security_defender_on_for_sql_servers')(framework, check_id)) }}
{% endmacro %}

{% macro default__security_defender_on_for_sql_servers(framework, check_id) %}{% endmacro %}

{% macro postgres__security_defender_on_for_sql_servers(framework, check_id) %}
SELECT
  _cq_sync_time As sync_time,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure that Azure Defender is set to On for Azure SQL database servers (Automatic)' as title,
  subscription_id,
  id,
  case
    when properties ->> 'pricingTier' = 'Standard'
    then 'pass' else 'fail'
  end
FROM azure_security_pricings asp
WHERE "name" = 'SqlServers'
{% endmacro %}

{% macro snowflake__security_defender_on_for_sql_servers(framework, check_id) %}
SELECT
  _cq_sync_time As sync_time,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
	'Ensure that Azure Defender is set to On for Azure SQL database servers (Automatic)' as title,
  subscription_id,
  id,
  case
    when properties:pricingTier = 'Standard'
    then 'pass' else 'fail'
  end
FROM azure_security_pricings asp
WHERE name = 'SqlServers'
{% endmacro %}
