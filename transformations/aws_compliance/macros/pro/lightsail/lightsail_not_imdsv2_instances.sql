{% macro lightsail_not_imdsv2_instances(framework, check_id) %}
  {{ return(adapter.dispatch('lightsail_not_imdsv2_instances')(framework, check_id)) }}
{% endmacro %}

{% macro default__lightsail_not_imdsv2_instances(framework, check_id) %}{% endmacro %}

{% macro postgres__lightsail_not_imdsv2_instances(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Lightsail instances should use IMDSv2' as title,
  account_id,
  arn as resource_id,
  case when
    metadata_options->>'HttpTokens' is distinct from 'required'
    then 'fail'
    else 'pass'
  end as status
from aws_lightsail_instances
{% endmacro %}
