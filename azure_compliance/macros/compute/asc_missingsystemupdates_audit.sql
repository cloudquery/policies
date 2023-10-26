{% macro compute_asc_missingsystemupdates_audit(framework, check_id) %}

SELECT
  _cq_sync_time As sync_time,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'System updates should be installed on your machines',
    azure_compute_virtual_machines.subscription_id,
	azure_compute_virtual_machines.id AS vm_id,
  case
    when (properties -> 'osProfile'->'windowsConfiguration'->>'enableAutomaticUpdates')::boolean is distinct from true then 'fail' else 'pass' -- TODO check
  end
FROM
	azure_compute_virtual_machines
{% endmacro %}