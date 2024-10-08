{% macro compute_endpoint_protection_solution_should_be_installed_on_virtual_machine_scale_sets(framework, check_id) %}

SELECT
  s.id As resource_id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Endpoint protection solution should be installed on virtual machine scale sets',
  s.subscription_id,
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
  azure_compute_virtual_machine_scale_sets s
  LEFT OUTER JOIN azure_security_assessments a
  ON a.name = 'e71020c2-860c-3235-cd39-04f3f8c936d2' AND a.id like (s.id || '/' || '%')
{% endmacro %}