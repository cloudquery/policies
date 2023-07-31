
ENABLED_ALL_REGIONS = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'AWS Config should be enabled' as title,
    account_id,
    arn as resource_id,
    CASE 
        WHEN ((recording_group:IncludeGlobalResourceTypes::BOOLEAN != TRUE) OR (recording_group:AllSupported::BOOLEAN != TRUE) OR (status_recording != TRUE OR status_last_status != 'SUCCESS'))
    THEN 'fail'
    ELSE 'pass'
    END AS status
FROM
    aws_config_configuration_recorders
WHERE $where$
"""