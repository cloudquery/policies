{% macro lambda_function_public_access_prohibited(framework, check_id) %}
select DISTINCT
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Lambda function policies should prohibit public access' AS title,
    account_id,
    arn AS resource_id,
    'fail' AS status
FROM (
  SELECT
    account_id,
    arn
  FROM
  aws_lambda_functions,
  table(flatten(policy_document, 'Statement')) as statement
where
  statement.value:Effect = 'Allow'
  and
    statement.value:Principal = '*'
    or
    statement.value:Principal:AWS = '*'
  )
{% endmacro %}