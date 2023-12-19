{% macro eventhub_event_hub_should_use_a_virtual_network_service_endpoint(framework, check_id) %}
WITH valid_namespaces AS (
  SELECT n.id
  FROM azure_eventhub_namespaces n
    LEFT JOIN azure_eventhub_namespace_network_rule_sets r ON r._cq_parent_id = n._cq_id
  WHERE r.id IS NOT NULL
)

SELECT
  n.id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Event Hub should use a virtual network service endpoint',
  n.subscription_id,
  case
    when v.id IS NULL then 'fail' else 'pass'
  end
FROM
  azure_eventhub_namespaces n
  LEFT OUTER JOIN valid_namespaces v
  ON n.id = v.id

{% endmacro %}