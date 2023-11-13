{% macro monitor_activitylog_administrativeoperations_audit(framework, check_id) %}
WITH alert_condition AS (
    SELECT
        subscription_id
    FROM
        azure_monitor_activity_log_alerts,
        jsonb_array_elements_text ( to_jsonb ( properties -> 'scopes' ) ) SCOPE
    WHERE
            location = 'Global'
      AND (properties ->> 'enabled')::boolean
    AND SCOPE = '/subscriptions/' || subscription_id
    AND _cq_id IN (
    SELECT op._cq_id
    FROM
    azure_monitor_activity_log_alerts op, jsonb_array_elements(op.properties -> 'condition') AS opcond,
    azure_monitor_activity_log_alerts cat, jsonb_array_elements(cat.properties -> 'condition') AS catcond
    WHERE
			    -- TODO check
			catcond->>'equals' = 'Administrative'
			AND catcond->>'field' = 'category'
			AND opcond->>'field' = 'operationName'
			AND opcond->>'equals' IN ( 'Microsoft.Sql/servers/firewallRules/write', 'Microsoft.Sql/servers/firewallRules/delete', 'Microsoft.Network/networkSecurityGroups/write', 'Microsoft.Network/networkSecurityGroups/delete', 'Microsoft.ClassicNetwork/networkSecurityGroups/write', 'Microsoft.ClassicNetwork/networkSecurityGroups/delete', 'Microsoft.Network/networkSecurityGroups/securityRules/write', 'Microsoft.Network/networkSecurityGroups/securityRules/delete', 'Microsoft.ClassicNetwork/networkSecurityGroups/securityRules/write', 'Microsoft.ClassicNetwork/networkSecurityGroups/securityRules/delete' )
		)
	GROUP BY
		subscription_id
	)

SELECT
  sub._cq_sync_time As sync_time,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'An activity log alert should exist for specific Administrative operations',
  sub.id,
  sub.id,
  'fail' as status
FROM
    azure_subscription_subscriptions sub
	LEFT JOIN alert_condition A ON sub.id = A.subscription_id
WHERE
	A.subscription_id IS NULL
GROUP BY
    sub.id,
	display_name
{% endmacro %}