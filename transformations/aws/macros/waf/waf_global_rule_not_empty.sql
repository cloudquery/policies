{% macro waf_global_rule_not_empty(framework, check_id) %}
  {{ return(adapter.dispatch('waf_global_rule_not_empty')(framework, check_id)) }}
{% endmacro %}

{% macro default__waf_global_rule_not_empty(framework, check_id) %}{% endmacro %}

{% macro postgres__waf_global_rule_not_empty(framework, check_id) %}
SELECT
	'{{framework}}' As framework,
    '{{check_id}}' As check_id,
	'A WAF global rule should have at least one condition' as title,
	account_id,
	arn as resource_id,
	case 
		WHEN 
        predicates is null 
        or jsonb_array_length(predicates) = 0 then 'fail'
		else 'pass'
        end as status
from
  aws_waf_rules
{% endmacro %}

{% macro snowflake__waf_global_rule_not_empty(framework, check_id) %}
SELECT
	'{{framework}}' As framework,
    '{{check_id}}' As check_id,
	'A WAF global rule should have at least one condition' as title,
	account_id,
	arn as resource_id,
	case 
		WHEN 
        predicates is null 
        or ARRAY_SIZE(predicates) = 0 then 'fail'
		else 'pass'
        end as status
from
  aws_waf_rules
{% endmacro %}

{% macro bigquery__waf_global_rule_not_empty(framework, check_id) %}
SELECT
	'{{framework}}' As framework,
    '{{check_id}}' As check_id,
	'A WAF global rule should have at least one condition' as title,
	account_id,
	arn as resource_id,
	case 
		WHEN 
        predicates is null 
        or ARRAY_LENGTH(JSON_QUERY_ARRAY(predicates)) = 0 then 'fail'
		else 'pass'
        end as status
from
  {{ full_table_name("aws_waf_rules") }}
{% endmacro %}