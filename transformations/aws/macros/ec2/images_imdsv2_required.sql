{% macro images_imdsv2_required(framework, check_id) %}
  {{ return(adapter.dispatch('images_imdsv2_required')(framework, check_id)) }}
{% endmacro %}

{% macro default__images_imdsv2_required(framework, check_id) %}{% endmacro %}

{% macro postgres__images_imdsv2_required(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'AMIs should require IMDSv2' as title,
  account_id,
  arn              as resource_id,
  case when
    imds_support is distinct from 'v2.0'
    then 'fail'
    else 'pass'
  end as status
from aws_ec2_images
{% endmacro %}

{% macro bigquery__images_imdsv2_required(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'AMIs should require IMDSv2' as title,
  account_id,
  arn              as resource_id,
  case when
    imds_support is distinct from 'v2.0'
    then 'fail'
    else 'pass'
  end as status
from {{ full_table_name("aws_ec2_images") }}
{% endmacro %}