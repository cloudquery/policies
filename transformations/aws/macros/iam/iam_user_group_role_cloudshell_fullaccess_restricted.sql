{% macro iam_user_group_role_cloudshell_fullaccess_restricted(framework, check_id) %}
  {{ return(adapter.dispatch('iam_user_group_role_cloudshell_fullaccess_restricted')(framework, check_id)) }}
{% endmacro %}

{% macro default__iam_user_group_role_cloudshell_fullaccess_restricted(framework, check_id) %}{% endmacro %}

{% macro postgres__iam_user_group_role_cloudshell_fullaccess_restricted(framework, check_id) %}
SELECT
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure access to AWSCloudShellFullAccess is restricted' as title,
  account_id,
  group_arn AS resource_id,
  CASE
    WHEN policy_arn LIKE '%AWSCloudShellFullAccess%' THEN 'fail'
    ELSE 'pass'
  END AS status
FROM
  aws_iam_group_attached_policies
  
UNION

SELECT
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure access to AWSCloudShellFullAccess is restricted' as title,
  account_id,
  role_arn AS resource_id,
  CASE
    WHEN policy_arn LIKE '%AWSCloudShellFullAccess%' THEN 'fail'
    ELSE 'pass'
  END AS status
FROM
  aws_iam_role_attached_policies
  
UNION

SELECT
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure access to AWSCloudShellFullAccess is restricted' as title,
  account_id,
  user_arn AS resource_id,
  CASE
    WHEN policy_arn LIKE '%AWSCloudShellFullAccess%' THEN 'fail'
    ELSE 'pass'
  END AS status
FROM
  aws_iam_user_attached_policies
{% endmacro %}

{% macro snowflake__iam_user_group_role_cloudshell_fullaccess_restricted(framework, check_id) %}
SELECT
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure access to AWSCloudShellFullAccess is restricted' as title,
  account_id,
  group_arn AS resource_id,
  CASE
    WHEN policy_arn LIKE '%AWSCloudShellFullAccess%' THEN 'fail'
    ELSE 'pass'
  END AS status
FROM
  aws_iam_group_attached_policies
  
UNION

SELECT
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure access to AWSCloudShellFullAccess is restricted' as title,
  account_id,
  role_arn AS resource_id,
  CASE
    WHEN policy_arn LIKE '%AWSCloudShellFullAccess%' THEN 'fail'
    ELSE 'pass'
  END AS status
FROM
  aws_iam_role_attached_policies
  
UNION

SELECT
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure access to AWSCloudShellFullAccess is restricted' as title,
  account_id,
  user_arn AS resource_id,
  CASE
    WHEN policy_arn LIKE '%AWSCloudShellFullAccess%' THEN 'fail'
    ELSE 'pass'
  END AS status
FROM
  aws_iam_user_attached_policies
{% endmacro %}

{% macro bigquery__iam_user_group_role_cloudshell_fullaccess_restricted(framework, check_id) %}
SELECT
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure access to AWSCloudShellFullAccess is restricted' as title,
  account_id,
  group_arn AS resource_id,
  CASE
    WHEN policy_arn LIKE '%AWSCloudShellFullAccess%' THEN 'fail'
    ELSE 'pass'
  END AS status
FROM
  {{ full_table_name("aws_iam_group_attached_policies") }}
UNION ALL
SELECT
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure access to AWSCloudShellFullAccess is restricted' as title,
  account_id,
  role_arn AS resource_id,
  CASE
    WHEN policy_arn LIKE '%AWSCloudShellFullAccess%' THEN 'fail'
    ELSE 'pass'
  END AS status
FROM
  {{ full_table_name("aws_iam_role_attached_policies") }}
UNION ALL
SELECT
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure access to AWSCloudShellFullAccess is restricted' as title,
  account_id,
  user_arn AS resource_id,
  CASE
    WHEN policy_arn LIKE '%AWSCloudShellFullAccess%' THEN 'fail'
    ELSE 'pass'
  END AS status
FROM
  {{ full_table_name("aws_iam_user_attached_policies") }}
{% endmacro %}

{% macro athena__iam_user_group_role_cloudshell_fullaccess_restricted(framework, check_id) %}
SELECT
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure access to AWSCloudShellFullAccess is restricted' as title,
  account_id,
  group_arn AS resource_id,
  CASE
    WHEN policy_arn LIKE '%AWSCloudShellFullAccess%' THEN 'fail'
    ELSE 'pass'
  END AS status
FROM
  aws_iam_group_attached_policies
  
UNION

SELECT
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure access to AWSCloudShellFullAccess is restricted' as title,
  account_id,
  role_arn AS resource_id,
  CASE
    WHEN policy_arn LIKE '%AWSCloudShellFullAccess%' THEN 'fail'
    ELSE 'pass'
  END AS status
FROM
  aws_iam_role_attached_policies
  
UNION

SELECT
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure access to AWSCloudShellFullAccess is restricted' as title,
  account_id,
  user_arn AS resource_id,
  CASE
    WHEN policy_arn LIKE '%AWSCloudShellFullAccess%' THEN 'fail'
    ELSE 'pass'
  END AS status
FROM
  aws_iam_user_attached_policies
{% endmacro %}