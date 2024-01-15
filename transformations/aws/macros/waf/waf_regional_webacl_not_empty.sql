{% macro waf_regional_webacl_not_empty(framework, check_id) %}
  {{ return(adapter.dispatch('waf_regional_webacl_not_empty')(framework, check_id)) }}
{% endmacro %}

{% macro default__waf_regional_webacl_not_empty(framework, check_id) %}{% endmacro %}

{% macro postgres__waf_regional_webacl_not_empty(framework, check_id) %}
select
	'{{framework}}' As framework,
    '{{check_id}}' As check_id,
	'A WAF Regional web ACL should have at least one rule or rule group' as title,
	account_id,
	arn as resource_id,
	case  
		WHEN jsonb_array_length(rules) = 0 THEN 'fail'
		else 'pass'
        end as status
from
  aws_wafregional_web_acls
{% endmacro %}

{% macro snowflake__waf_regional_webacl_not_empty(framework, check_id) %}
select
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

{% macro bigquery__waf_regional_webacl_not_empty(framework, check_id) %}
select
	'{{framework}}' As framework,
    '{{check_id}}' As check_id,
	'A WAF Regional web ACL should have at least one rule or rule group' as title,
	account_id,
	arn as resource_id,
	case  
		WHEN ARRAY_LENGTH(JSON_QUERY_ARRAY(rules)) = 0 THEN 'fail'
		else 'pass'
        end as status
from
  {{ full_table_name("aws_wafregional_web_acls") }}
{% endmacro %}