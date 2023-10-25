{% macro netfw_policy_rule_group_associated(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Network Firewall policies should have at least one rule group associated' as title,
  account_id,
  arn as resource_id,
  CASE 
    WHEN ARRAY_SIZE(stateful_rule_group_references) > 0 OR ARRAY_SIZE(stateless_rule_group_references) > 0 then 'pass'
    else 'fail'
  END AS status
FROM
  aws_networkfirewall_firewall_policies
{% endmacro %}