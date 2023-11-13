{% macro logs_file_validation_enabled(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure CloudTrail log file validation is enabled' as title,
    account_id,
    arn as resource_id,
    case
      when log_file_validation_enabled = false then 'fail'
      else 'pass'
    end as status
from aws_cloudtrail_trails
{% endmacro %}