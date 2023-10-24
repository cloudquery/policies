{% macro waf_regional_rule_not_empty(framework, check_id) %}
insert into aws_policy_results
SELECT
	'{{framework}}' As framework,
    '{{check_id}}' As check_id,
	'A WAF Regional rule should have at least one condition' as title,
	account_id,
	arn as resource_id,
	case 
		WHEN 
        predicates is null 
        or ARRAY_SIZE(predicates) = 0 then 'fail'
		else 'pass'
        end as status
from
  aws_wafregional_rules
{% endmacro %}