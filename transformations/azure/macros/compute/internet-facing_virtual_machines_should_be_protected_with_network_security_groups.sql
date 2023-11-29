{% macro compute_internet_facing_virtual_machines_should_be_protected_with_network_security_groups(framework, check_id) %}

SELECT
  vm.id AS resource_id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Internet-facing virtual machines should be protected with network security groups',
  vm.subscription_id,
  case
    when a.name IS NULL
      OR (
        a.properties -> 'status' ->>'code' IS DISTINCT FROM 'NotApplicable'
        AND a.properties -> 'status' ->>'code' IS DISTINCT FROM 'Healthy'
      )
    then 'fail'
    else 'pass'
  end
FROM
  azure_compute_virtual_machines vm
  LEFT OUTER JOIN azure_security_assessments a
  ON a.name = '483f12ed-ae23-447e-a2de-a67a10db4353' AND a.id like (vm.id || '/' || '%')
  

{% endmacro %}