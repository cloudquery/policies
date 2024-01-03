{% macro waf_global_rulegroup_not_empty(framework, check_id) %}
  {{ return(adapter.dispatch('waf_global_rulegroup_not_empty')(framework, check_id)) }}
{% endmacro %}

{% macro default__waf_global_rulegroup_not_empty(framework, check_id) %}{% endmacro %}

{% macro postgres__waf_global_rulegroup_not_empty(framework, check_id) %}
SELECT
	'{{framework}}' As framework,
    '{{check_id}}' As check_id,
	'A WAF global rule group should have at least one rule' as title,
	account_id,
	arn as resource_id,
	case 
		WHEN 
		rule_ids is null then 'fail'
		else 'pass'
        end as status
from
  aws_waf_rule_groups
{% endmacro %}

{% macro snowflake__waf_global_rulegroup_not_empty(framework, check_id) %}
SELECT
	'{{framework}}' As framework,
    '{{check_id}}' As check_id,
	'A WAF global rule group should have at least one rule' as title,
	account_id,
	arn as resource_id,
	case 
		WHEN 
		rule_ids is null then 'fail'
		else 'pass'
        end as status
from
  aws_waf_rule_groups
{% endmacro %}