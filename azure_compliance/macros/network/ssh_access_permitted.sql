{% macro network_ssh_access_permitted(framework, check_id) %}

SELECT
  :'execution_time'
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  '',
  subnet_id,
  id,
  case
    when source_address_prefix in ('0.0.0.0', '0.0.0.0/0', 'any', 'internet', '<nw>/0', '/0', '*')
      AND protocol = 'Udp'
      AND "access" = 'Allow'
      AND direction = 'Inbound'
      AND (single_port = '22'
        OR 22 BETWEEN range_start AND range_end) then
    'fail' else 'pass'
  end
FROM azure_nsg_rules 
{% endmacro %}