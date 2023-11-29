{% macro network_subnets_without_nsg_associated(framework, check_id) %}
WITH subs AS (
    SELECT jsonb_array_elements(properties->'subnets') AS subnet FROM azure_network_virtual_networks
)

SELECT
  sg.id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Subnets should be associated with a Network Security Group',
  sg.subscription_id,
  case
    when subs.subnet->>'id' IS NULL then 'fail' else 'pass'
  end
FROM
	azure_network_security_groups AS sg
LEFT JOIN subs ON subs.subnet->'networkSecurityGroup'->>'id' = sg.id
{% endmacro %}