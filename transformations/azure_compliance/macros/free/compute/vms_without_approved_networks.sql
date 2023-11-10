{% macro compute_vms_without_approved_networks(framework, check_id) %}
WITH vms_with_interfaces AS (SELECT _cq_sync_time,
                                    subscription_id,
                                    id,
                                    jsonb_array_elements(properties->'networkProfile'->'networkInterfaces') AS nics
                             FROM azure_compute_virtual_machines vm),
nics_with_subnets AS (
    SELECT id, jsonb_array_elements(properties -> 'ipConfigurations') AS ip_config FROM azure_network_interfaces
    )
-- TODO check

SELECT
  v._cq_sync_time As sync_time,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Virtual machines should be connected to an approved virtual network',
  v.subscription_id,
  v.id,
  case
    when i.ip_config->>'subnet_id' IS NULL then 'fail' else 'pass'
  end
FROM vms_with_interfaces v
         LEFT JOIN nics_with_subnets i ON v.nics->>'id' = i.id
{% endmacro %}