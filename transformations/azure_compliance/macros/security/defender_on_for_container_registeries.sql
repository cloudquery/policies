{% macro security_defender_on_for_container_registeries(framework, check_id) %}

SELECT
  _cq_sync_time As sync_time,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure that Azure Defender is set to On for Container Registries (Automatic)' as title,
  subscription_id,
  id,
  case
    when properties ->> 'pricingTier' = 'Standard'
    then 'pass' else 'fail'
  end
FROM azure_security_pricings asp
WHERE "name" = 'ContainerRegistry'
{% endmacro %}