
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