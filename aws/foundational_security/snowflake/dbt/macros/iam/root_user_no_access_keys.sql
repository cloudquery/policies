{% macro root_user_no_access_keys(framework, check_id) %}
insert into aws_policy_results
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
from aws_iam_user_access_keys;
{% endmacro %}