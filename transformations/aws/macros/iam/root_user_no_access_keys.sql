{% macro root_user_no_access_keys(framework, check_id) %}
  {{ return(adapter.dispatch('root_user_no_access_keys')(framework, check_id)) }}
{% endmacro %}

{% macro default__root_user_no_access_keys(framework, check_id) %}{% endmacro %}

{% macro snowflake__root_user_no_access_keys(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure no root account access key exists (Scored)' as title,
  account_id,
  user_arn AS resource_id,
  case when
    user_name IN ('<root>', '<root_account>')
    then 'fail'
    else 'pass'
  end
from aws_iam_user_access_keys
{% endmacro %}

{% macro postgres__root_user_no_access_keys(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure no root account access key exists (Scored)' as title,
  account_id,
  user_arn AS resource_id,
  case when
    user_name IN ('<root>', '<root_account>')
    then 'fail'
    else 'pass'
  end
from aws_iam_user_access_keys
{% endmacro %}

{% macro bigquery__root_user_no_access_keys(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure no root account access key exists (Scored)' as title,
  account_id,
  user_arn AS resource_id,
  case when
    user_name IN ('<root>', '<root_account>')
    then 'fail'
    else 'pass'
  end
from {{ full_table_name("aws_iam_user_access_keys") }}
{% endmacro %}

{% macro athena__root_user_no_access_keys(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure no root account access key exists (Scored)' as title,
  account_id,
  user_arn AS resource_id,
  case when
    user_name IN ('<root>', '<root_account>')
    then 'fail'
    else 'pass'
  end
from aws_iam_user_access_keys
{% endmacro %}