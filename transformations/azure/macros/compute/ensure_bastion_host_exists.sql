{% macro compute_ensure_bastion_host_exists(framework, check_id) %}
 {{ return(adapter.dispatch('compute_ensure_bastion_host_exists')(framework, check_id)) }}
{% endmacro %}

{% macro default__compute_ensure_bastion_host_exists(framework, check_id) %}{% endmacro %}

{% macro postgres__compute_ensure_bastion_host_exists(framework, check_id) %}


SELECT
    sub.id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure an Azure Bastion Host Exists (Automated)' AS title,
  bast.subscription_id,
  case
    when bast.subscription_id is NULL
    then 'fail'
    else 'pass'
    end as status
  from azure_subscription_subscriptions sub
  left join azure_network_bastion_hosts bast on sub.subscription_id = bast.subscription_id
	
{% endmacro %}

{% macro snowflake__compute_ensure_bastion_host_exists(framework, check_id) %}

SELECT
	SELECT
    sub.id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure an Azure Bastion Host Exists (Automated)' AS title,
  bast.subscription_id,
  case
    when bast.subscription_id is NULL
    then 'fail'
    else 'pass'
    end as status
  from azure_subscription_subscriptions sub
  left join azure_network_bastion_hosts bast on sub.subscription_id = bast.subscription_id
	
{% endmacro %}

{% macro bigquery__compute_ensure_bastion_host_exists(framework, check_id) %}

SELECT
	SELECT
    sub.id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure an Azure Bastion Host Exists (Automated)' AS title,
  bast.subscription_id,
  case
    when bast.subscription_id is NULL
    then 'fail'
    else 'pass'
    end as status
  from {{ full_table_name('azure_subscription_subscriptions')}} sub
  left join {{full_table_name('azure_network_bastion_hosts')}} bast on sub.subscription_id = bast.subscription_id
	
{% endmacro %}