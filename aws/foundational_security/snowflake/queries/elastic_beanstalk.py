ADVANCED_HEALTH_REPORTING_ENABLED = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Elastic Beanstalk environments should have enhanced health reporting enabled' as title,
    account_id,
    arn as resource_id,
    case when
        health_status is null
        or health is null
        then 'fail'
        else 'pass'
    end as status
from aws_elasticbeanstalk_environments
"""

ELASTIC_BEANSTALK_MANAGED_UPDATES_ENABLED = """
insert into aws_policy_results
SELECT
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'Elastic Beanstalk managed platform updates should be enabled' as title,
  account_id,
  application_arn as resource_id,
  case when
    s.value:OptionName = 'ManagedActionsEnabled' AND s.value:Value::boolean = true is distinct from true
    then 'fail'
    else 'pass'
  end as status
from aws_elasticbeanstalk_configuration_settings, lateral flatten(input => parse_json(aws_elasticbeanstalk_configuration_settings.option_settings)) as s
"""