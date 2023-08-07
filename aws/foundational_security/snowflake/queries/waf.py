
WAF_WEB_ACL_LOGGING_SHOULD_BE_ENABLED = """
insert into aws_policy_results
-- WAF Classic
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'AWS WAF Classic global web ACL logging should be enabled' as title,
    account_id,
    arn as resource_id,
    case when
        logging_configuration is null or logging_configuration = '{}'
    then 'fail' else 'pass' end as status
from aws_waf_web_acls
"""

WAFV2_WEBACL_NOT_EMPTY = """
insert into aws_policy_results
SELECT
	:1 as execution_time,
    :2 as framework,
    :3 as check_id,
	'A WAFv2 web ACL should have at least one rule or rule group' as title,
	account_id,
	arn,
	CASE
	WHEN ARRAY_SIZE(rules) > 0 or ARRAY_SIZE(POST_PROCESS_FIREWALL_MANAGER_RULE_GROUPS) > 0 or ARRAY_SIZE(PRE_PROCESS_FIREWALL_MANAGER_RULE_GROUPS) > 0 THEN 'pass'
    ELSE 'fail'
	END AS rule_status
FROM
  aws_wafv2_web_acls;
"""


WAF_GLOBAL_WEBACL_NOT_EMPTY = """
insert into aws_policy_results
SELECT
	:1 as execution_time,
    :2 as framework,
    :3 as check_id,
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
"""

WAF_GLOBAL_RULEGROUP_NOT_EMPTY = """
-- Insert statement to add the result into aws_policy_results table
insert into aws_policy_results
SELECT
	:1 as execution_time,
    :2 as framework,
    :3 as check_id,
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
"""

WAF_GLOBAL_RULE_NOT_EMPTY = """
-- Insert statement to add the result into aws_policy_results table
insert into aws_policy_results
SELECT
	:1 as execution_time,
    :2 as framework,
    :3 as check_id,
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
"""

WAF_REGIONAL_WEBACL_NOT_EMPTY = """
insert into aws_policy_results
SELECT
	:1 as execution_time,
    :2 as framework,
    :3 as check_id,
	'A WAF Regional web ACL should have at least one rule or rule group' as title,
	account_id,
	arn as resource_id,
	case  
		WHEN ARRAY_SIZE(rules) = 0 THEN 'fail'
		else 'pass'
        end as status
from
  aws_wafregional_web_acls
"""

WAF_REGIONAL_RULEGROUP_NOT_EMPTY = """
insert into aws_policy_results
SELECT
	:1 as execution_time,
    :2 as framework,
    :3 as check_id,
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
"""

WAF_REGIONAL_RULE_NOT_EMPTY = """
insert into aws_policy_results
SELECT
	:1 as execution_time,
    :2 as framework,
    :3 as check_id,
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
"""