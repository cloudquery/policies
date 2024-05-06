{% macro ec2_not_imdsv2_instances(framework, check_id) %}
  {{ return(adapter.dispatch('ec2_not_imdsv2_instances')(framework, check_id)) }}
{% endmacro %}

{% macro default__ec2_not_imdsv2_instances(framework, check_id) %}{% endmacro %}

{% macro postgres__ec2_not_imdsv2_instances(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'EC2 instances should use IMDSv2' as title,
  account_id,
  instance_id as resource_id,
  case when
    metadata_options->>'HttpTokens' is distinct from 'required'
    then 'fail'
    else 'pass'
  end as status
from aws_ec2_instances
where metadata_options->>'httpEndpoint' = 'enabled'
{% endmacro %}

{% macro bigquery__ec2_not_imdsv2_instances(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'EC2 instances should use IMDSv2' as title,
  account_id,
  instance_id as resource_id,
  case when
    JSON_VALUE(metadata_options.HttpTokens) is distinct from 'required'
    then 'fail'
    else 'pass'
  end as status
from {{ full_table_name("aws_ec2_instances") }}
where JSON_VALUE(metadata_options.httpEndpoint) = 'enabled'
{% endmacro %}

{% macro snowflake__ec2_not_imdsv2_instances(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'EC2 instances should use IMDSv2' as title,
  account_id,
  instance_id as resource_id,
  case when
    metadata_options:HttpTokens is distinct from 'required'
    then 'fail'
    else 'pass'
  end as status
from aws_ec2_instances
where metadata_options:httpEndpoint = 'enabled'
{% endmacro %}

{% macro athena__ec2_not_imdsv2_instances(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'EC2 instances should use IMDSv2' as title,
  account_id,
  instance_id as resource_id,
  case when
    json_extract_scalar(metadata_options, '$.HttpTokens') is distinct from 'required'
    then 'fail'
    else 'pass'
  end as status
from aws_ec2_instances
where json_extract_scalar(metadata_options, '$.httpEndpoint') = 'enabled'
{% endmacro %}