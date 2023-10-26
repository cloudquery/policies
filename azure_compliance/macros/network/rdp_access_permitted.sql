{% macro network_rdp_access_permitted(framework, check_id) %}

SELECT
  _cq_sync_time As sync_time,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Windows machines should meet requirements for ''User Rights Assignment''',
  subscription_id,
  nsg_id,
  case
    when source_address_prefix in ('0.0.0.0', '0.0.0.0/0', 'any', 'internet', '<nw>/0', '/0', '*')
      AND (single_port = '3389' OR 3389 BETWEEN range_start AND range_end)
      AND protocol = 'Tcp'
      AND "access" = 'Allow'
      AND direction = 'Inbound'
    then 'fail' else 'pass'
  end
FROM view_azure_nsg_rules{% endmacro %}