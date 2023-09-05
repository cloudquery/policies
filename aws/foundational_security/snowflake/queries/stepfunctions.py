#stepfunctions.1
STEP_FUNCTIONS_STATE_MACHINE_LOGGING_ENABLED = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Step Functions state machines should have logging turned on' as title,
    account_id,
    arn as resource_id,
    case when
     LOGGING_CONFIGURATION:Level is null or LOGGING_CONFIGURATION:Level = 'OFF' 
     or (LOGGING_CONFIGURATION:Level != 'OFF' and LOGGING_CONFIGURATION:destinations is null) then 'fail'
     else 'pass'
     end as status
from 
    aws_stepfunctions_state_machines
"""