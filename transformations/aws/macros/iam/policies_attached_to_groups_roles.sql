{% macro policies_attached_to_groups_roles(framework, check_id) %}
  {{ return(adapter.dispatch('policies_attached_to_groups_roles')(framework, check_id)) }}
{% endmacro %}

{% macro default__policies_attached_to_groups_roles(framework, check_id) %}{% endmacro %}

{% macro snowflake__policies_attached_to_groups_roles(framework, check_id) %}
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

{% macro postgres__policies_attached_to_groups_roles(framework, check_id) %}
select distinct
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'IAM users should not have IAM policies attached' as title,
    aws_iam_users.account_id,
    arn AS resource_id,
    case 
        when
            aws_iam_user_attached_policies.user_arn is not null
            or aws_iam_user_policies.user_arn is not null
        then 'fail' 
        else 'pass' 
    end as status
from aws_iam_users
left join aws_iam_user_attached_policies on aws_iam_users.arn = aws_iam_user_attached_policies.user_arn
left join aws_iam_user_policies on aws_iam_users.arn = aws_iam_user_policies.user_arn
{% endmacro %}

{% macro bigquery__policies_attached_to_groups_roles(framework, check_id) %}
select distinct
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'IAM users should not have IAM policies attached' as title,
    aws_iam_users.account_id,
    arn AS resource_id,
    case 
        when
            aws_iam_user_attached_policies.user_arn is not null
            or aws_iam_user_policies.user_arn is not null
        then 'fail' 
        else 'pass' 
    end as status
from {{ full_table_name("aws_iam_users") }}
left join {{ full_table_name("aws_iam_user_attached_policies") }} on aws_iam_users.arn = aws_iam_user_attached_policies.user_arn
left join {{ full_table_name("aws_iam_user_policies") }} on aws_iam_users.arn = aws_iam_user_policies.user_arn
{% endmacro %}

{% macro athena__policies_attached_to_groups_roles(framework, check_id) %}
SELECT DISTINCT
    '{{framework}}' AS framework,
    '{{check_id}}' AS check_id,
    'IAM users should not have IAM policies attached' as title,
    aws_iam_users.account_id,
    aws_iam_users.arn AS resource_id,
    CASE 
        WHEN aws_iam_user_attached_policies.user_arn IS NOT NULL
            OR aws_iam_user_policies.user_arn IS NOT NULL
        THEN 'fail' 
        ELSE 'pass' 
    END AS status
FROM aws_iam_users
LEFT JOIN aws_iam_user_attached_policies ON aws_iam_users.arn = aws_iam_user_attached_policies.user_arn
LEFT JOIN aws_iam_user_policies ON aws_iam_users.arn = aws_iam_user_policies.user_arn
{% endmacro %}