{% macro keyvault_vaults_with_no_service_endpoint(framework, check_id) %}
WITH subs AS (
    SELECT subscription_id, jsonb_array_elements(properties->'subnets') AS subnet, properties->>'provisioningState' as provisioning_state
    FROM azure_network_virtual_networks
),
secured_vaults AS (SELECT v._cq_id, nvr->>'id' AS subnet_id
                        FROM azure_keyvault_keyvaults  v,
                             jsonb_array_elements(v.properties->'networkAcls'->'virtualNetworkRules') AS nvr
                                 LEFT JOIN subs
                                           ON nvr->>'id' = subs.subnet->>'id'
                        WHERE v.properties->'networkAcls'->>'defaultAction' = 'Deny'
                          AND subs.provisioning_state = 'Succeeded')
-- TODO check

SELECT
  id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Key Vault should use a virtual network service endpoint',
  subscription_id,
  case
    when sv._cq_id IS NULL then 'fail' else 'pass'
  end
FROM azure_keyvault_keyvaults v
  LEFT JOIN secured_vaults sv ON v._cq_id = sv._cq_id
{% endmacro %}