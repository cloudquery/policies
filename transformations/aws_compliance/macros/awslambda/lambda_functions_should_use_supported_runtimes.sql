{% macro lambda_functions_should_use_supported_runtimes(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Lambda functions should use supported runtimes' AS title,
    f.account_id,
    f.arn AS resource_id,
    CASE WHEN r.name IS NULL THEN 'fail'
    ELSE 'pass' END AS status
FROM aws_lambda_functions f
LEFT JOIN aws_lambda_runtimes r ON r.name = f.configuration:Runtime::STRING
WHERE f.configuration:PackageType::STRING != 'Image'
{% endmacro %}