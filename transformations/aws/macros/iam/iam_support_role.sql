{% macro iam_support_role(framework, check_id) %}
  {{ return(adapter.dispatch('iam_support_role')(framework, check_id)) }}
{% endmacro %}

{% macro default__iam_support_role(framework, check_id) %}{% endmacro %}

{% macro postgres__iam_support_role(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure a support role has been created to manage incidents with AWS Support' as title,
  a.account_id,
  r.arn AS resource_id,
  CASE
    WHEN a.policy_arn LIKE '%AWSSupportAccess%' AND a.role_arn IS NOT NULL THEN 'pass'
    ELSE 'fail'
  END AS status
FROM
  aws_iam_role_attached_policies a
  JOIN aws_iam_roles r ON a._cq_parent_id = r._cq_id
{% endmacro %}

{% macro snowflake__iam_support_role(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure a support role has been created to manage incidents with AWS Support' as title,
  a.account_id,
  r.arn AS resource_id,
  CASE
    WHEN a.policy_arn LIKE '%AWSSupportAccess%' AND a.role_arn IS NOT NULL THEN 'pass'
    ELSE 'fail'
  END AS status
FROM
  aws_iam_role_attached_policies a
  JOIN aws_iam_roles r ON a._cq_parent_id = r._cq_id
{% endmacro %}

{% macro bigquery__iam_support_role(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure a support role has been created to manage incidents with AWS Support' as title,
  a.account_id,
  r.arn AS resource_id,
  CASE
    WHEN a.policy_arn LIKE '%AWSSupportAccess%' AND a.role_arn IS NOT NULL THEN 'pass'
    ELSE 'fail'
  END AS status
FROM
  {{ full_table_name("aws_iam_role_attached_policies") }} a
  JOIN {{ full_table_name("aws_iam_roles") }} r ON a._cq_parent_id = r._cq_id
{% endmacro %}

{% macro athena__iam_support_role(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure a support role has been created to manage incidents with AWS Support' as title,
  a.account_id,
  r.arn AS resource_id,
  CASE
    WHEN a.policy_arn LIKE '%AWSSupportAccess%' AND a.role_arn IS NOT NULL THEN 'pass'
    ELSE 'fail'
  END AS status
FROM
  aws_iam_role_attached_policies a
  JOIN aws_iam_roles r ON a._cq_parent_id = r._cq_id
{% endmacro %}