{% macro security_defender_on_for_sql_servers_on_machines(framework, check_id) %}

SELECT
  _cq_sync_time As sync_time,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure that Azure Defender is set to On for SQL servers on machines (Automatic)' as title,
  subscription_id,
  id,
  case
    when properties ->> 'pricingTier' = 'Standard'
    then 'pass' else 'fail'
  end
FROM azure_security_pricings asp
WHERE "name" = 'SqlserverVirtualMachines'
{% endmacro %}