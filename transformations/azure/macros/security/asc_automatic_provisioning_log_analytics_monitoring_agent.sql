{% macro security_asc_automatic_provisioning_log_analytics_monitoring_agent(framework, check_id) %}

SELECT
	azure_security_auto_provisioning_settings.id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Auto provisioning of the Log Analytics agent should be enabled on your subscription' as title,
  azure_subscription_subscriptions.id AS subscription_id,
  case
    when properties->>'autoProvision' IS DISTINCT FROM 'On'
    then 'fail' else 'pass'
  end
FROM
	azure_security_auto_provisioning_settings
	RIGHT JOIN azure_subscription_subscriptions ON azure_security_auto_provisioning_settings.subscription_id = azure_subscription_subscriptions.id

--TODO: Seems similar to auto_provisioning_monitoring_agent_enabled.sql where that setting is for Monitoring Agent.  This query should be checked for accuracy.
-- confirmed this does the same as auto_provisioning_monitoring_agent_enabled.sql
{% endmacro %}