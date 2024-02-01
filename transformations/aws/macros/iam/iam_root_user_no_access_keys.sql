{% macro iam_root_user_no_access_keys(framework, check_id) %}
  {{ return(adapter.dispatch('iam_root_user_no_access_keys')(framework, check_id)) }}
{% endmacro %}

{% macro default__iam_root_user_no_access_keys(framework, check_id) %}{% endmacro %}

{% macro postgres__iam_root_user_no_access_keys(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure no ''root'' user account access key exists (Automated)' as title,
  account_id,
  account_id as resource_id,
  case when
    account_access_keys_present is true
    then 'fail'
    else 'pass'
  end as status
from aws_iam_accounts
{% endmacro %}

{% macro snowflake__iam_root_user_no_access_keys(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure no ''root'' user account access key exists (Automated)' as title,
  account_id,
  account_id as resource_id,
  case when
    account_access_keys_present = true
    then 'fail'
    else 'pass'
  end as status
from aws_iam_accounts
{% endmacro %}

{% macro bigquery__iam_root_user_no_access_keys(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure no "root" user account access key exists (Automated)' as title,
  account_id,
  account_id as resource_id,
  case when
    account_access_keys_present is true
    then 'fail'
    else 'pass'
  end as status
from {{ full_table_name("aws_iam_accounts") }}
{% endmacro %}

