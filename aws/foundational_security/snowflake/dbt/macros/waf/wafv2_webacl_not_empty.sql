{% macro wafv2_webacl_not_empty(framework, check_id) %}
insert into aws_policy_results
SELECT
	'{{framework}}' As framework,
    '{{check_id}}' As check_id,
	'A WAFv2 web ACL should have at least one rule or rule group' as title,
	account_id,
	arn,
	CASE
	WHEN ARRAY_SIZE(rules) > 0 or ARRAY_SIZE(POST_PROCESS_FIREWALL_MANAGER_RULE_GROUPS) > 0 or ARRAY_SIZE(PRE_PROCESS_FIREWALL_MANAGER_RULE_GROUPS) > 0 THEN 'pass'
    ELSE 'fail'
	END AS rule_status
FROM
  aws_wafv2_web_acls
{% endmacro %}