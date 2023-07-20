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