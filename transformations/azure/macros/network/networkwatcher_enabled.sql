{% macro network_networkwatcher_enabled(framework, check_id) %}
 {{ return(adapter.dispatch('network_networkwatcher_enabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__network_networkwatcher_enabled(framework, check_id) %}{% endmacro %}

{% macro postgres__network_networkwatcher_enabled(framework, check_id) %}

SELECT
	azure_network_virtual_networks.id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure that HTTP(S) access from the Internet is evaluated and restricted (Automated)' AS title,
  sub.id AS subscription_id,
	case
    when azure_network_watchers.location IS NULL
	    OR LOWER ( split_part( azure_network_watchers.id, '/', 5 ) ) != 'networkwatcherrg'
      and (azure_network_watchers.properties ->> 'provisioningState') != 'Succeeded'
    then 'fail' else 'pass'
  end as status
FROM
	azure_network_virtual_networks
	LEFT JOIN azure_network_watchers ON azure_network_virtual_networks.location = azure_network_watchers.location
	JOIN azure_subscription_subscriptions sub ON sub.subscription_id = azure_network_virtual_networks.subscription_id
{% endmacro %}

{% macro snowflake__network_networkwatcher_enabled(framework, check_id) %}

SELECT
	azure_network_virtual_networks.id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure that HTTP(S) access from the Internet is evaluated and restricted (Automated)' AS title,
  sub.id AS subscription_id,
	case
    when azure_network_watchers.location IS NULL
	    OR LOWER ( split_part( azure_network_watchers.id, '/', 5 ) ) != 'networkwatcherrg'
      and azure_network_watchers.properties:provisioningState != 'Succeeded'
    then 'fail' else 'pass'
  end as status
FROM
	azure_network_virtual_networks
	LEFT JOIN azure_network_watchers ON azure_network_virtual_networks.location = azure_network_watchers.location
	JOIN azure_subscription_subscriptions sub ON sub.subscription_id = azure_network_virtual_networks.subscription_id
{% endmacro %}

{% macro bigquery__network_networkwatcher_enabled(framework, check_id) %}

SELECT
	azure_network_virtual_networks.id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure that HTTP(S) access from the Internet is evaluated and restricted (Automated)' AS title,
  sub.id AS subscription_id,
	case
    when azure_network_watchers.location IS NULL
	    OR LOWER ( split_part( azure_network_watchers.id, '/', 5 ) ) != 'networkwatcherrg'
      and azure_network_watchers.properties.provisioningState != 'Succeeded'
    then 'fail' else 'pass'
  end as status
FROM
  {{ full_table_name("azure_network_virtual_networks") }} azure_network_virtual_networks
	LEFT JOIN {{ full_table_name("azure_network_watchers") }} azure_network_watchers ON azure_network_virtual_networks.location = azure_network_watchers.location
	JOIN {{ full_table_name("azure_subscription_subscriptions") }} sub ON sub.subscription_id = azure_network_virtual_networks.subscription_id
{% endmacro %}