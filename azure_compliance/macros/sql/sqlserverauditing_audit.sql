{% macro sql_sqlserverauditing_audit(framework, check_id) %}

SELECT
  sub._cq_sync_time As sync_time,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Auditing on SQL server should be enabled' as title,
  sub.id,
  sub.display_name AS subscription_name,
	case
    when azure_sql_server_blob_auditing_policies._cq_parent_id = azure_sql_servers._cq_id
	    AND sub.id = azure_sql_servers.subscription_id
	    AND azure_sql_server_blob_auditing_policies.properties ->> 'state' = 'Disabled'
    then 'fail' else 'pass'
  end
FROM
    azure_sql_server_blob_auditing_policies,
	azure_sql_servers,
    azure_subscription_subscriptions sub
{% endmacro %}