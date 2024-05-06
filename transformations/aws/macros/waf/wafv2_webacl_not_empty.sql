{% macro wafv2_webacl_not_empty(framework, check_id) %}
  {{ return(adapter.dispatch('wafv2_webacl_not_empty')(framework, check_id)) }}
{% endmacro %}

{% macro default__wafv2_webacl_not_empty(framework, check_id) %}{% endmacro %}

{% macro postgres__wafv2_webacl_not_empty(framework, check_id) %}
select
	'{{framework}}' As framework,
    '{{check_id}}' As check_id,
	'A WAFv2 web ACL should have at least one rule or rule group' as title,
	account_id,
	arn,
	CASE
	WHEN jsonb_array_length(rules) > 0 or jsonb_array_length(POST_PROCESS_FIREWALL_MANAGER_RULE_GROUPS) > 0 or jsonb_array_length(PRE_PROCESS_FIREWALL_MANAGER_RULE_GROUPS) > 0 THEN 'pass'
    ELSE 'fail'
	END AS rule_status
FROM
  aws_wafv2_web_acls
{% endmacro %}

{% macro snowflake__wafv2_webacl_not_empty(framework, check_id) %}
select
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

{% macro bigquery__wafv2_webacl_not_empty(framework, check_id) %}
select
	'{{framework}}' As framework,
    '{{check_id}}' As check_id,
	'A WAFv2 web ACL should have at least one rule or rule group' as title,
	account_id,
	arn,
	CASE
	WHEN ARRAY_LENGTH(JSON_QUERY_ARRAY(rules)) > 0 or ARRAY_LENGTH(JSON_QUERY_ARRAY(POST_PROCESS_FIREWALL_MANAGER_RULE_GROUPS)) > 0 or ARRAY_LENGTH(JSON_QUERY_ARRAY(PRE_PROCESS_FIREWALL_MANAGER_RULE_GROUPS)) > 0 THEN 'pass'
    ELSE 'fail'
	END AS rule_status
FROM
  {{ full_table_name("aws_wafv2_web_acls") }}
{% endmacro %}

{% macro athena__wafv2_webacl_not_empty(framework, check_id) %}
select
	'{{framework}}' As framework,
    '{{check_id}}' As check_id,
	'A WAFv2 web ACL should have at least one rule or rule group' as title,
	account_id,
	arn,
	CASE
	WHEN json_array_length(rules) > 0 or json_array_length(POST_PROCESS_FIREWALL_MANAGER_RULE_GROUPS) > 0 or json_array_length(PRE_PROCESS_FIREWALL_MANAGER_RULE_GROUPS) > 0 THEN 'pass'
    ELSE 'fail'
	END AS rule_status
FROM
  aws_wafv2_web_acls
{% endmacro %}