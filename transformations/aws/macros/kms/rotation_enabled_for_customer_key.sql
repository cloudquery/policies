{% macro rotation_enabled_for_customer_key(framework, check_id) %}
  {{ return(adapter.dispatch('rotation_enabled_for_customer_key')(framework, check_id)) }}
{% endmacro %}

{% macro default__rotation_enabled_for_customer_key(framework, check_id) %}{% endmacro %}

{% macro postgres__rotation_enabled_for_customer_key(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure rotation for customer created custom master keys is enabled (Scored)' as title,
  account_id,
  arn,
  case when
    rotation_enabled is FALSE and key_manager = 'CUSTOMER'
    then 'fail'
    else 'pass'
  end
from aws_kms_keys
{% endmacro %}

{% macro bigquery__rotation_enabled_for_customer_key(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure rotation for customer created custom master keys is enabled (Scored)' as title,
  account_id,
  arn,
  case when
    rotation_enabled is FALSE and key_manager = 'CUSTOMER'
    then 'fail'
    else 'pass'
  end
from {{ full_table_name("aws_kms_keys") }}
{% endmacro %}
