{% macro not_imdsv2_instances(framework, check_id) %}
  {{ return(adapter.dispatch('not_imdsv2_instances')(framework, check_id)) }}
{% endmacro %}

{% macro default__not_imdsv2_instances(framework, check_id) %}{% endmacro %}

{% macro postgres__not_imdsv2_instances(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'EC2 instances should use IMDSv2' as title,
  account_id,
  instance_id as resource_id,
  case when
    metadata_options ->> 'HttpTokens' is distinct from 'required'
    then 'fail'
    else 'pass'
  end as status
from aws_ec2_instances
{% endmacro %}

{% macro snowflake__not_imdsv2_instances(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'EC2 instances should use IMDSv2' as title,
  account_id,
  instance_id as resource_id,
  case when
    metadata_options:HttpTokens is distinct from 'required'
    then 'fail'
    else 'pass'
  end as status
from aws_ec2_instances
{% endmacro %}

{% macro bigquery__not_imdsv2_instances(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'EC2 instances should use IMDSv2' as title,
  account_id,
  instance_id as resource_id,
  case when
    JSON_VALUE(metadata_options.HttpTokens) is distinct from 'required'
    then 'fail'
    else 'pass'
  end as status
from {{ full_table_name("aws_ec2_instances") }}
{% endmacro %}

{% macro athena__not_imdsv2_instances(framework, check_id) %}
SELECT
  '{{framework}}' AS framework,
  '{{check_id}}' AS check_id,
  'EC2 instances should use IMDSv2' AS title,
  account_id,
  instance_id AS resource_id,
  CASE
    WHEN json_extract_scalar(metadata_options, '$.HttpTokens') = 'required'
    THEN 'pass'
    ELSE 'fail'
  END AS status
FROM
  aws_ec2_instances
{% endmacro %}