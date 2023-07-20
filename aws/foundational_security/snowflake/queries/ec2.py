
EBS_SNAPSHOT_PERMISSIONS_CHECK = """
insert into aws_policy_results
WITH snapshot_access_groups AS (
    SELECT account_id,
           region,
           snapshot_id,
           create_volume_permissions.value:Group AS "group",
           create_volume_permissions.value:UserId AS user_id
    FROM aws_ec2_ebs_snapshot_attributes, lateral flatten(input => parse_json(aws_ec2_ebs_snapshot_attributes.create_volume_permissions)) as create_volume_permissions
)
SELECT DISTINCT
  %s as execution_time,
  %s as framework,
  %s as check_id,
  'Amazon EBS snapshots should not be public, determined by the ability to be restorable by anyone' as title,
  account_id,
  snapshot_id as resource_id,
  case when
    "group" = 'all'
    -- this is under question because
    -- trusted accounts(user_id) do not violate this control
        OR user_id IS DISTINCT FROM ''
    then 'fail'
    else 'pass'
  end as status
FROM snapshot_access_groups
"""