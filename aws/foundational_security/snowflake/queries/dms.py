
REPLICATION_NOT_PUBLIC = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'AWS Database Migration Service replication instances should not be public' as title,
    account_id,
    arn as resource_id,
    case when
        publicly_accessible is true
        then 'fail'
        else 'pass'
    end as status
from aws_dms_replication_instances
"""