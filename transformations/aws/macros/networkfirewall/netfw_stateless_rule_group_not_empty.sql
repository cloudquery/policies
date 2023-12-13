{% macro netfw_stateless_rule_group_not_empty(framework, check_id) %}
  {{ return(adapter.dispatch('netfw_stateless_rule_group_not_empty')(framework, check_id)) }}
{% endmacro %}

{% macro default__netfw_stateless_rule_group_not_empty(framework, check_id) %}{% endmacro %}

{% macro postgres__netfw_stateless_rule_group_not_empty(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Stateless Network Firewall rule group should not be empty' as title,
  account_id,
  arn as resource_id,
  CASE 
  WHEN
  RULES_SOURCE -> 'StatelessRulesAndCustomActions' ->> 'StatelessRules' is NULL and type = 'STATELESS'
  then 'fail'
  WHEN
  jsonb_array_length(RULES_SOURCE -> 'StatelessRulesAndCustomActions' -> 'StatelessRules') = 0 and type = 'STATELESS'
  then 'fail'
  else 'pass'
  END AS status
FROM
  aws_networkfirewall_rule_groups
{% endmacro %}

{% macro snowflake__netfw_stateless_rule_group_not_empty(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
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
{% endmacro %}