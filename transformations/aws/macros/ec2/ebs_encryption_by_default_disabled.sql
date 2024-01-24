{% macro ebs_encryption_by_default_disabled(framework, check_id) %}
  {{ return(adapter.dispatch('ebs_encryption_by_default_disabled')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__ebs_encryption_by_default_disabled(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'EBS default encryption should be enabled' as title,
  account_id,
  concat(account_id,':',region) as resource_id,
  case when
    ebs_encryption_enabled_by_default is distinct from true
    then 'fail'
    else 'pass'
  end as status
from aws_ec2_regional_configs
{% endmacro %}

{% macro postgres__ebs_encryption_by_default_disabled(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'EBS default encryption should be enabled' as title,
  account_id,
  concat(account_id,':',region) as resource_id,
  case when
    ebs_encryption_enabled_by_default is distinct from true
    then 'fail'
    else 'pass'
  end as status
from aws_ec2_regional_configs
{% endmacro %}

{% macro default__ebs_encryption_by_default_disabled(framework, check_id) %}{% endmacro %}

{% macro bigquery__ebs_encryption_by_default_disabled(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'EBS default encryption should be enabled' as title,
  account_id,
  concat(account_id,':',region) as resource_id,
  case when
    ebs_encryption_enabled_by_default is distinct from true
    then 'fail'
    else 'pass'
  end as status
from {{ full_table_name("aws_ec2_regional_configs") }}
{% endmacro %}