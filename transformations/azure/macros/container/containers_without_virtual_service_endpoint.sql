{% macro container_containers_without_virtual_service_endpoint(framework, check_id) %}

SELECT
  r.id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  '[Preview]: Container Registry should use a virtual network service endpoint',
  r.subscription_id,
  case
    when r.properties -> 'networkRuleSet'->>'defaultAction' IS DISTINCT FROM 'Deny'
      OR vrr->>'id' IS NULL
      OR anvns._cq_id IS NULL
    then 'fail' else 'pass'
  end
FROM azure_containerregistry_registries r LEFT JOIN JSONB_ARRAY_ELEMENTS(r.properties -> 'networkRuleSet'->'virtualNetworkRules') AS vrr ON TRUE
         LEFT JOIN azure_network_virtual_networks anvns ON anvns.id = vrr->>'id'
{% endmacro %}