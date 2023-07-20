# unused, not in foundational. accidentally converted
SECURITYHUB_ENABLED = """
insert into aws_policy_results
with enabled_securityhub_regions as (select account_id, region from aws_securityhub_hubs)
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'SecurityHub should be enabled' AS title,
    r.account_id,
    r.region AS resource_id,
    case when
        r.enabled = TRUE AND e.region IS NULL
    then 'fail'
    else 'pass' end AS status
from aws_regions r
left join enabled_securityhub_regions e on e.region = r.region AND e.account_id = r.account_id
"""