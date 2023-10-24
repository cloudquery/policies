{% macro waf_regional_webacl_not_empty(framework, check_id) %}
insert into aws_policy_results
SELECT
	'{{framework}}' As framework,
    '{{check_id}}' As check_id,
	'A WAF Regional web ACL should have at least one rule or rule group' as title,
	account_id,
	arn as resource_id,
	case  
		WHEN ARRAY_SIZE(rules) = 0 THEN 'fail'
		else 'pass'
        end as status
from
  aws_wafregional_web_acls
{% endmacro %}