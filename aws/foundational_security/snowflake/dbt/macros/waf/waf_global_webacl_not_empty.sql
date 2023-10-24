{% macro waf_global_webacl_not_empty(framework, check_id) %}
insert into aws_policy_results
SELECT
	'{{framework}}' As framework,
    '{{check_id}}' As check_id,
	'A WAF global web ACL should have at least one rule or rule group' as title,
	account_id,
	arn,
	CASE
        WHEN 
        ARRAY_SIZE(rules) = 0 THEN 'fail'
        ELSE 'pass'
        END AS rule_status
FROM
  aws_waf_web_acls;
{% endmacro %}