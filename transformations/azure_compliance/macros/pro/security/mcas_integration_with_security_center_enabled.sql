{% macro security_mcas_integration_with_security_center_enabled(framework, check_id) %}

SELECT 
  _cq_sync_time As sync_time,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure that Microsoft Cloud App Security (MCAS) integration with Security Center is selected (Automatic)' as title,
  subscription_id,
  id,
  case
    when enabled = TRUE
    then 'pass' else 'fail'
  end
FROM azure_security_settings ass
WHERE "name" = 'MCAS'
{% endmacro %}