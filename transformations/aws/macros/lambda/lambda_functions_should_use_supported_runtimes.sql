{% macro lambda_functions_should_use_supported_runtimes(framework, check_id) %}
  {{ return(adapter.dispatch('lambda_functions_should_use_supported_runtimes')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__lambda_functions_should_use_supported_runtimes(framework, check_id) %}
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

{% macro postgres__lambda_functions_should_use_supported_runtimes(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Lambda functions should use supported runtimes' as title,
    f.account_id,
    f.arn AS resource_id,
    case when r.name is null then 'fail'
    else 'pass' end AS status
from aws_lambda_functions f
left join aws_lambda_runtimes r on r.name=f.configuration->>'Runtime'
where f.configuration->>'PackageType' != 'Image'
{% endmacro %}

{% macro default__lambda_functions_should_use_supported_runtimes(framework, check_id) %}{% endmacro %}

{% macro bigquery__lambda_functions_should_use_supported_runtimes(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Lambda functions should use supported runtimes' AS title,
    f.account_id,
    f.arn AS resource_id,
    CASE WHEN r.name IS NULL THEN 'fail'
    ELSE 'pass' END AS status
FROM {{ full_table_name("aws_lambda_functions") }} f
LEFT JOIN {{ full_table_name("aws_lambda_runtimes") }} r ON r.name = CAST( JSON_VALUE(f.configuration.Runtime) AS STRING)
WHERE  CAST( JSON_VALUE(f.configuration.PackageType) AS STRING) != 'Image'
{% endmacro %}

{% macro athena__lambda_functions_should_use_supported_runtimes(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Lambda functions should use supported runtimes' AS title,
    f.account_id,
    f.arn AS resource_id,
    CASE WHEN r.name IS NULL THEN 'fail'
    ELSE 'pass' END AS status
FROM aws_lambda_functions f
LEFT JOIN aws_lambda_runtimes r ON r.name = json_extract_scalar(f.configuration, '$.Runtime')
WHERE json_extract_scalar(f.configuration, '$.PackageType') != 'Image'
{% endmacro %}