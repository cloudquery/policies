#NetworkFirewall.3
NETFW_POLICY_RULE_GROUP_ASSOCIATED = """
insert into aws_policy_results
select
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'Network Firewall policies should have at least one rule group associated' as title,
  account_id,
  arn as resource_id,
  CASE 
    WHEN ARRAY_SIZE(stateful_rule_group_references) > 0 OR ARRAY_SIZE(stateless_rule_group_references) > 0 then 'pass'
    else 'fail'
  END AS status
FROM
  aws_networkfirewall_firewall_policies;
"""

#NetworkFirewall.4
NETFW_POLICY_DEFAULT_ACTION_FULL_PACKETS = """
insert into aws_policy_results
select
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'The default stateless action for Network Firewall policies should be drop or forward for full packets' as title,
  account_id,
  arn as resource_id,
  CASE 
  WHEN
  stateless_default_actions[0] = 'aws:drop' or stateless_default_actions[0] = 'aws:forward_to_sfe' then 'pass'
  else 'fail'
  END AS status
FROM
  aws_networkfirewall_firewall_policies;
"""

#NetworkFirewall.5
NETFW_POLICY_DEFAULT_ACTION_FRAGMENT_PACKETS = """
insert into aws_policy_results
select
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'The default stateless action for Network Firewall policies should be drop or forward for fragmented packets' as title,
  account_id,
  arn as resource_id,
  CASE 
  WHEN
  stateless_fragment_default_actions[0] = 'aws:drop' or stateless_fragment_default_actions[0] = 'aws:forward_to_sfe' then 'pass'
  else 'fail'
  END AS status
FROM
  aws_networkfirewall_firewall_policies;
"""

#NetworkFirewall.6
NETFW_STATELESS_RULE_GROUP_NOT_EMPTY = """
insert into aws_policy_results
select
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'Stateless Network Firewall rule group should not be empty' as title,
  account_id,
  arn as resource_id,
  CASE 
  WHEN
  RULES_SOURCE:StatelessRulesAndCustomActions:StatelessRules is NULL and type = 'STATELESS'
  then 'fail'
  WHEN
  ARRAY_SIZE(RULES_SOURCE:StatelessRulesAndCustomActions:StatelessRules) = 0 and type = 'STATELESS'
  then 'fail'
  else 'pass'
  END AS status
FROM
  aws_networkfirewall_rule_groups 
"""