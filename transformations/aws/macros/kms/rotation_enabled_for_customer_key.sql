{% macro rotation_enabled_for_customer_key(framework, check_id) %}
  {{ return(adapter.dispatch('rotation_enabled_for_customer_key')(framework, check_id)) }}
{% endmacro %}

{% macro default__rotation_enabled_for_customer_key(framework, check_id) %}{% endmacro %}

{% macro postgres__rotation_enabled_for_customer_key(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure rotation for customer created custom master keys is enabled (Scored)' as title,
  akk.account_id,
  akk.arn,
  case when
    akkrs.key_rotation_enabled = FALSE and akk.key_manager = 'CUSTOMER'
    then 'fail'
    else 'pass'
  end as status
from aws_kms_keys akk
left join aws_kms_key_rotation_statuses akkrs on akk.arn = akkrs.key_arn
{% endmacro %}

{% macro bigquery__rotation_enabled_for_customer_key(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure rotation for customer created custom master keys is enabled (Scored)' as title,
  akk.account_id,
  akk.arn,
  case when
    akkrs.key_rotation_enabled is FALSE and akk.key_manager = 'CUSTOMER'
    then 'fail'
    else 'pass'
  end as status
from {{ full_table_name("aws_kms_keys") }} akk
left join {{ full_table_name("aws_kms_key_rotation_statuses") }} akkrs on akk.arn = akkrs.key_arn

{% endmacro %}

{% macro snowflake__rotation_enabled_for_customer_key(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure rotation for customer created custom master keys is enabled (Scored)' as title,
  akk.account_id,
  akk.arn,
  case when
    not akkrs.key_rotation_enabled and akk.key_manager = 'CUSTOMER'
    then 'fail'
    else 'pass'
  end as status
from aws_kms_keys akk
left join aws_kms_key_rotation_statuses akkrs on akk.arn = akkrs.key_arn
{% endmacro %}