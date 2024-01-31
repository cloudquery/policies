{% macro use_iam_roles_for_instances(framework, check_id) %}
  {{ return(adapter.dispatch('use_iam_roles_for_instances')(framework, check_id)) }}
{% endmacro %}

{% macro default__use_iam_roles_for_instances(framework, check_id) %}{% endmacro %}

{% macro postgres__use_iam_roles_for_instances(framework, check_id) %}
SELECT
  '{{framework}}' AS framework,
  '{{check_id}}' AS check_id,
  'Ensure IAM instance roles are used for AWS resource access from instances (Automated)' AS title,
  ec2.account_id,
  ec2.arn AS resource_id,
  CASE
    WHEN 
      iip.roles IS NULL OR jsonb_array_length(iip.roles) = 0
    THEN 'fail'
    ELSE 'pass'
  END AS status
FROM
  aws_ec2_instances ec2
JOIN
  aws_iam_instance_profiles iip ON iip.arn = ec2.iam_instance_profile ->> 'arn'
{% endmacro %}

{% macro snowflake__use_iam_roles_for_instances(framework, check_id) %}
SELECT
  '{{framework}}' AS framework,
  '{{check_id}}' AS check_id,
  'Ensure IAM instance roles are used for AWS resource access from instances (Automated)' AS title,
  ec2.account_id,
  ec2.arn AS resource_id,
  CASE
    WHEN 
      iip.roles IS NULL OR ARRAY_SIZE(iip.roles) = 0
    THEN 'fail'
    ELSE 'pass'
  END AS status
FROM
  aws_ec2_instances ec2
JOIN
  aws_iam_instance_profiles iip ON iip.arn = ec2.iam_instance_profile:arn
{% endmacro %}

{% macro bigquery__use_iam_roles_for_instances(framework, check_id) %}
SELECT
  '{{framework}}' AS framework,
  '{{check_id}}' AS check_id,
  'Ensure IAM instance roles are used for AWS resource access from instances (Automated)' AS title,
  ec2.account_id,
  ec2.arn AS resource_id,
  CASE
    WHEN 
      iip.roles IS NULL OR ARRAY_LENGTH(JSON_QUERY_ARRAY(iip.roles)) = 0
    THEN 'fail'
    ELSE 'pass'
  END AS status
FROM
  {{ full_table_name("aws_ec2_instances") }} ec2
JOIN
  {{ full_table_name("aws_iam_instance_profiles") }} iip ON iip.arn = JSON_VALUE(ec2.iam_instance_profile.arn)
{% endmacro %}


