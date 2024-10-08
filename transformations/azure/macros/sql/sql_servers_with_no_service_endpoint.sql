{% macro sql_sql_servers_with_no_service_endpoint(framework, check_id) %}
WITH subs AS (
    SELECT subscription_id, jsonb_array_elements(properties->'subnets') AS subnet, properties->>'provisioningState' as provisioning_state
    FROM azure_network_virtual_networks
), secured_servers AS (SELECT s._cq_id
                         FROM azure_sql_servers s
                                  LEFT JOIN azure_sql_server_virtual_network_rules r
                                            ON s._cq_id = r._cq_parent_id
                                  LEFT JOIN subs
                                            ON r.properties ->> 'virtualNetworkSubnetId' = subs.subnet->>'id'
                         WHERE r.properties -> 'virtualNetworkSubnetId' IS NOT NULL
                           AND subs.provisioning_state = 'Succeeded')

SELECT
  id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'SQL Server should use a virtual network service endpoint' as title,
  subscription_id,
  case
    when ss._cq_id IS NULL
      then 'fail' else 'pass'
  end
FROM azure_sql_servers s
     LEFT JOIN secured_servers ss ON s._cq_id = ss._cq_id
     {% endmacro %}