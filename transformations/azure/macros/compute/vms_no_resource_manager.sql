{% macro compute_vms_no_resource_manager(framework, check_id) %}
--vms created using old manager have type 'Microsoft.ClassicCompute/virtualMachines'

SELECT
  id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Virtual machines should be migrated to new Azure Resource Manager resources',
  subscription_id,
  case
    when type IS DISTINCT FROM 'Microsoft.Compute/virtualMachines'
    then 'fail' else 'pass'
  end
FROM azure_compute_virtual_machines
{% endmacro %}