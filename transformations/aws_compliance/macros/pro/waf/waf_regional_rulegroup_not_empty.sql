{% macro waf_regional_rulegroup_not_empty(framework, check_id) %}
select
	'{{framework}}' As framework,
    '{{check_id}}' As check_id,
	'A WAF Regional rule group should have at least one rule' as title,
	account_id,
	arn as resource_id,
	case 
		WHEN 
		rule_ids is null then 'fail'
		else 'pass'
        end as status
from
  aws_wafregional_rule_groups
{% endmacro %}