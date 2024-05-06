{% macro lambda_function_in_vpc(framework, check_id) %}
  {{ return(adapter.dispatch('lambda_function_in_vpc')(framework, check_id)) }}
{% endmacro %}

{% macro default__lambda_function_in_vpc(framework, check_id) %}{% endmacro %}

{% macro postgres__lambda_function_in_vpc(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Lambda functions should be in a VPC' AS title,
    account_id,
    arn as resource_id,
    case when configuration->'VpcConfig'->>'VpcId' is null or configuration->'VpcConfig'->>'VpcId' = '' then 'fail' else 'pass' end as status
from aws_lambda_functions
{% endmacro %}
{% macro snowflake__lambda_function_in_vpc(framework, check_id) %}
SELECT
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Lambda functions should be in a VPC' AS title,
    account_id,
    arn AS resource_id,
    CASE
        WHEN JSON_EXTRACT_PATH_TEXT(configuration, 'VpcConfig.VpcId') IS NULL
             OR JSON_EXTRACT_PATH_TEXT(configuration, 'VpcConfig.VpcId') = '' 
        THEN 'fail'
        ELSE 'pass'
    END AS status
FROM aws_lambda_functions
{% endmacro %}

{% macro bigquery__lambda_function_in_vpc(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Lambda functions should be in a VPC' AS title,
    account_id,
    arn as resource_id,
    case when configuration.VpcConfig.VpcId is null or JSON_VALUE(configuration.VpcConfig.VpcId) = '' then 'fail' else 'pass' end as status
from {{ full_table_name("aws_lambda_functions") }}
{% endmacro %}

{% macro athena__lambda_function_in_vpc(framework, check_id) %}
SELECT
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Lambda functions should be in a VPC' AS title,
    account_id,
    arn AS resource_id,
    CASE
        WHEN json_extract_scalar(configuration, '$.VpcConfig.VpcId') IS NULL
             OR json_extract_scalar(configuration, '$.VpcConfig.VpcId') = '' 
        THEN 'fail'
        ELSE 'pass'
    END AS status
FROM aws_lambda_functions
{% endmacro %}