{% macro compute_asc_missingsystemupdates_audit(framework, check_id) %}

SELECT
	azure_compute_virtual_machines.id AS resource_id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'System updates should be installed on your machines',
    azure_compute_virtual_machines.subscription_id,
  case
    when (properties -> 'osProfile'->'windowsConfiguration'->>'enableAutomaticUpdates')::boolean is distinct from true then 'fail' else 'pass' -- TODO check
  end
FROM
	azure_compute_virtual_machines
{% endmacro %}