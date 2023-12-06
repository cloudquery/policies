{% macro network_gateway_subnets_should_not_be_configured_with_a_network_security_group(framework, check_id) %}
WITH subs AS (
    SELECT subscription_id, jsonb_array_elements(properties->'subnets') AS subnet
    FROM azure_network_virtual_networks
)

SELECT
  subnet->>'id',
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Gateway subnets should not be configured with a network security group',
  subscription_id,
  case
    when subnet->>'name' = 'GatewaySubnet' AND subnet->'networkSecurityGroup'->>'id' IS NOT NULL
    then 'fail' else 'pass'
  end
FROM subs

{% endmacro %}