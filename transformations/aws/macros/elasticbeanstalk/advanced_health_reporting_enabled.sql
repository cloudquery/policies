{% macro advanced_health_reporting_enabled(framework, check_id) %}
  {{ return(adapter.dispatch('advanced_health_reporting_enabled')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__advanced_health_reporting_enabled(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
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
{% endmacro %}

{% macro postgres__advanced_health_reporting_enabled(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Elastic Beanstalk environments should have enhanced health reporting enabled' as title,
    account_id,
    arn as resource_id,
    case when
        health_status is null
        or health_status = ''
        or health is null
        then 'fail'
        else 'pass'
    end as status
from aws_elasticbeanstalk_environments
{% endmacro %}
