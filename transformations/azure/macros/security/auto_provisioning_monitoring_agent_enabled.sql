{% macro security_auto_provisioning_monitoring_agent_enabled(framework, check_id) %}
  {{ return(adapter.dispatch('security_auto_provisioning_monitoring_agent_enabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__security_auto_provisioning_monitoring_agent_enabled(framework, check_id) %}{% endmacro %}

{% macro postgres__security_auto_provisioning_monitoring_agent_enabled(framework, check_id) %}
SELECT
  id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure that "Automatic provisioning of monitoring agent" is set to "On" (Automated)' as title,
  subscription_id,
  case
    when properties->>'autoProvision' = 'On'
    then 'pass' else 'fail'
  end
FROM azure_security_auto_provisioning_settings asaps
WHERE "name" = 'default'
{% endmacro %}

{% macro snowflake__security_auto_provisioning_monitoring_agent_enabled(framework, check_id) %}
SELECT
  id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure that "Automatic provisioning of monitoring agent" is set to "On" (Automated)' as title,
  subscription_id,
  case
    when properties:autoProvision = 'On'
    then 'pass' else 'fail'
  end
FROM azure_security_auto_provisioning_settings asaps
WHERE name = 'default'
{% endmacro %}

{% macro bigquery__security_auto_provisioning_monitoring_agent_enabled(framework, check_id) %}
SELECT
  id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure that "Automatic provisioning of monitoring agent" is set to "On" (Automated)' as title,
  subscription_id,
  case
    when JSON_VALUE(properties.autoProvision) = 'On'
    then 'pass' else 'fail'
  end
FROM {{ full_table_name("azure_security_auto_provisioning_settings") }} asaps
WHERE name = 'default'
{% endmacro %}