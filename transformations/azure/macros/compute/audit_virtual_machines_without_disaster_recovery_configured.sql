{% macro compute_audit_virtual_machines_without_disaster_recovery_configured(framework, check_id) %}
WITH asr_protect AS (
    SELECT properties ->> 'sourceId' as source_id
    FROM azure_resources_links
    WHERE name LIKE 'ASR-Protect-%'
)

SELECT
    id As resource_id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Audit virtual machines without disaster recovery configured.',
  subscription_id,
  
  case
    when p.source_id is null then 'fail' else 'pass'
  end
FROM
    azure_compute_virtual_machines vm
    LEFT OUTER JOIN asr_protect p
    ON LOWER(vm.id) = LOWER(p.source_id)
{% endmacro %}