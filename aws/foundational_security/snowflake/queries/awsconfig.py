
ENABLED_ALL_REGIONS = """
insert into aws_policy_results
select
    %s as execution_time,
    %s as framework,
    %s as check_id,
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
"""