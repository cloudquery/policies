{% macro netfw_policy_default_action_full_packets(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'The default stateless action for Network Firewall policies should be drop or forward for full packets' as title,
  account_id,
  arn as resource_id,
  CASE 
  WHEN
  stateless_default_actions[0] = 'aws:drop' or stateless_default_actions[0] = 'aws:forward_to_sfe' then 'pass'
  else 'fail'
  END AS status
FROM
  aws_networkfirewall_firewall_policies
{% endmacro %}