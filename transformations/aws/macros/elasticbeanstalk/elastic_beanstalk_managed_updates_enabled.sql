{% macro elastic_beanstalk_managed_updates_enabled(framework, check_id) %}
  {{ return(adapter.dispatch('elastic_beanstalk_managed_updates_enabled')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__elastic_beanstalk_managed_updates_enabled(framework, check_id) %}
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

{% macro postgres__elastic_beanstalk_managed_updates_enabled(framework, check_id) %}
SELECT
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Elastic Beanstalk managed platform updates should be enabled' as title,
  account_id,
  application_arn as resource_id,
  case when
    s->>'OptionName' = 'ManagedActionsEnabled' AND (s->>'Value')::boolean = true is distinct from true
    then 'fail'
    else 'pass'
  end as status
from aws_elasticbeanstalk_configuration_settings, jsonb_array_elements(aws_elasticbeanstalk_configuration_settings.option_settings) as s
{% endmacro %}

{% macro default__elastic_beanstalk_managed_updates_enabled(framework, check_id) %}{% endmacro %}

{% macro bigquery__elastic_beanstalk_managed_updates_enabled(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Elastic Beanstalk managed platform updates should be enabled' as title,
  account_id,
  application_arn as resource_id,
  case when
    JSON_VALUE(s.OptionName) = 'ManagedActionsEnabled' AND CAST( JSON_VALUE(s.Value) AS BOOL) is distinct from true
    then 'fail'
    else 'pass'
  end as status
from {{ full_table_name("aws_elasticbeanstalk_configuration_settings") }},
UNNEST(JSON_QUERY_ARRAY(option_settings)) AS s{% endmacro %}

{% macro athena__elastic_beanstalk_managed_updates_enabled(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Elastic Beanstalk managed platform updates should be enabled' as title,
  account_id,
  application_arn as resource_id,
  case when
    json_extract_scalar(s, '$.OptionName') = 'ManagedActionsEnabled' AND cast(json_extract_scalar(s, '$.Value') as boolean) is distinct from true
    then 'fail'
    else 'pass'
  end as status
from aws_elasticbeanstalk_configuration_settings,
unnest(cast(json_parse(aws_elasticbeanstalk_configuration_settings.option_settings) as array(json))) as t(s)
{% endmacro %}