{% macro waf_global_webacl_not_empty(framework, check_id) %}
  {{ return(adapter.dispatch('waf_global_webacl_not_empty')(framework, check_id)) }}
{% endmacro %}

{% macro default__waf_global_webacl_not_empty(framework, check_id) %}{% endmacro %}

{% macro postgres__waf_global_webacl_not_empty(framework, check_id) %}
select
	'{{framework}}' As framework,
    '{{check_id}}' As check_id,
	'A WAF global web ACL should have at least one rule or rule group' as title,
	account_id,
	arn,
	CASE
        WHEN 
        jsonb_array_length(rules) = 0 THEN 'fail'
        ELSE 'pass'
        END AS rule_status
FROM
  aws_waf_web_acls
{% endmacro %}

{% macro snowflake__waf_global_webacl_not_empty(framework, check_id) %}
select
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
  aws_waf_web_acls
{% endmacro %}