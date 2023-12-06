{% macro account_locations_without_network_watchers(framework, check_id) %}

select
  l.id as resource_id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Network Watcher should be enable' as title,
  l.subscription_id,
  case
    when anw._cq_id is null then 'fail' else 'pass'
  end
from azure_subscription_subscription_locations l
  left join azure_network_watchers anw on l.name = anw.location
{% endmacro %}