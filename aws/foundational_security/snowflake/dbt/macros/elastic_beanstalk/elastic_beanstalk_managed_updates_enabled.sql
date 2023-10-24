{% macro elastic_beanstalk_managed_updates_enabled(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Elastic Beanstalk managed platform updates should be enabled' as title,
  account_id,
  application_arn as resource_id,
  case when
    s.value:OptionName = 'ManagedActionsEnabled' AND s.value:Value::boolean = true is distinct from true
    then 'fail'
    else 'pass'
  end as status
from aws_elasticbeanstalk_configuration_settings, lateral flatten(input => parse_json(aws_elasticbeanstalk_configuration_settings.option_settings)) as s
{% endmacro %}