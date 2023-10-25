{% macro policies_attached_to_groups_roles(framework, check_id) %}
select distinct
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'IAM users should not have IAM policies attached' as title,
    aws_iam_users.account_id,
    arn AS resource_id,
    case when
        aws_iam_user_attached_policies.user_arn is not null
    then 'fail' else 'pass' end as status
from aws_iam_users
left join aws_iam_user_attached_policies on aws_iam_users.arn = aws_iam_user_attached_policies.user_arn
{% endmacro %}