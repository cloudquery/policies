#lambda.2
LAMBDA_FUNCTIONS_SHOULD_USE_SUPPORTED_RUNTIMES = """
INSERT INTO aws_policy_results
SELECT
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Lambda functions should use supported runtimes' AS title,
    f.account_id,
    f.arn AS resource_id,
    CASE WHEN r.name IS NULL THEN 'fail'
    ELSE 'pass' END AS status
FROM aws_lambda_functions f
LEFT JOIN aws_lambda_runtimes r ON r.name = f.configuration:Runtime::STRING
WHERE f.configuration:PackageType::STRING != 'Image'
"""

#lambda.1
LAMBDA_FUNCTION_PUBLIC_ACCESS_PROHIBITED = """
INSERT INTO aws_policy_results
SELECT DISTINCT
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
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
"""

#lambda.3
LAMBDA_INSIDE_VPC = """
INSERT INTO aws_policy_results
SELECT
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
  'Lambda functions should be in a VPC' AS title,
  account_id,
  arn AS resource_id,
  CASE
  WHEN (configuration:VpcConfig:VpcId) IS NULL
  OR configuration:VpcConfig:VpcId = ''
  THEN 'fail'
  ELSE 'pass'
  END
    AS status
FROM
  aws_lambda_functions
"""

#lambda.5
LAMBDA_VPC_MULTI_AZ_CHECK = """
INSERT INTO aws_policy_results
SELECT
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
  'VPC Lambda functions should operate in more than one Availability Zone' AS title,
    account_id, 
    l.arn AS resource_id,
    CASE WHEN
    count (distinct s.availability_zone_id) > 1 THEN 'pass'
    ELSE 'fail'
    end as status
FROM
    aws_lambda_functions as l
INNER JOIN
    LATERAL FLATTEN(configuration:VpcConfig:SubnetIds) a
LEFT JOIN
    aws_ec2_subnets s
ON
    a.value = s.subnet_id
group by l.arn, account_id
"""