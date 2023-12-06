{% macro compute_monitor_missing_endpoint_protection_in_azure_security_center(framework, check_id) %}
SELECT
  vm.id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  '',
  vm.subscription_id,
  case
    when a.name IS NULL OR (
      a.properties -> 'status' ->>'code' IS DISTINCT FROM 'NotApplicable'
      AND  a.properties -> 'status' ->>'code' IS DISTINCT FROM 'Healthy')
    then 'fail'
    else 'pass'
  end
FROM
  azure_compute_virtual_machines vm
  LEFT OUTER JOIN azure_security_assessments a
  ON a.name = '83f577bd-a1b6-b7e1-0891-12ca19d1e6df' AND starts_with(a.id, vm.id || '/') 
{% endmacro %}