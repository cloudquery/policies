{% macro lambda_function_prohibit_public_access(framework, check_id) %}
  {{ return(adapter.dispatch('lambda_function_prohibit_public_access')(framework, check_id)) }}
{% endmacro %}

{% macro default__lambda_function_prohibit_public_access(framework, check_id) %}{% endmacro %}

{% macro postgres__lambda_function_prohibit_public_access(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Lambda functions should prohibit public access' as title,
    account_id,
    arn as resource_id,
    'fail' as status -- TODO FIXME
from aws_lambda_functions,
    jsonb_array_elements(
        case jsonb_typeof(policy_document -> 'Statement')
            when
                'string' then jsonb_build_array(policy_document ->> 'Statement')
            when 'array' then policy_document -> 'Statement'
        end
    ) as statement
where statement ->> 'Effect' = 'Allow'
    and (
        statement ->> 'Principal' = '*'
        or statement -> 'Principal' ->> 'AWS' = '*'
         or ( case jsonb_typeof(statement -> 'Principal' -> 'AWS')
            when 'string' then jsonb_build_array(statement -> 'Principal' ->> 'AWS')
            when 'array' then (statement -> 'Principal' ->> 'AWS')::JSONB
	     end)::JSONB ? '*'
    )
{% endmacro %}
{% macro snowflake__lambda_function_prohibit_public_access(framework, check_id) %}
SELECT
    '{{framework}}' AS framework,
    '{{check_id}}' AS check_id,
    'Lambda functions should prohibit public access' AS title,
    account_id,
    arn AS resource_id,
    'fail' AS status -- TODO FIXME
FROM aws_lambda_functions,
LATERAL FLATTEN(
    CASE 
        WHEN TYPEOF(PARSE_JSON(policy_document):Statement) = 'string'
        THEN ARRAY_CONSTRUCT(PARSE_JSON(policy_document):Statement)
        WHEN TYPEOF(PARSE_JSON(policy_document):Statement) = 'array'
        THEN PARSE_JSON(policy_document):Statement
    END
) AS statement
WHERE statement.value:Effect = 'Allow'
    AND (
        statement.value:Principal = '*'
        OR statement.value:Principal:AWS = '*'
        OR (
            CASE
                WHEN TYPEOF(statement.value:Principal:AWS) = 'string' 
                THEN ARRAY_CONSTRUCT(statement.value:Principal:AWS)
                WHEN TYPEOF(statement.value:Principal:AWS) = 'array'
                THEN PARSE_JSON(statement.value:Principal:AWS)
            END
        )::VARIANT:AWS LIKE '%*%'
    )
{% endmacro %}

{% macro bigquery__lambda_function_prohibit_public_access(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Lambda functions should prohibit public access' as title,
    account_id,
    arn as resource_id,
    'fail' as status -- TODO FIXME
from {{ full_table_name("aws_lambda_functions") }},
        UNNEST(JSON_QUERY_ARRAY(policy_document.Statement)) AS statement
where   JSON_VALUE(statement.Effect) = 'Allow'
        and (
            JSON_VALUE(statement.Principal) = '*'
            or JSON_VALUE(statement.Principal.AWS) = '*'
            
            or ( '*' IN UNNEST(JSON_EXTRACT_STRING_ARRAY(statement.Principal.AWS)) )
        )
{% endmacro %}

{% macro athena__lambda_function_prohibit_public_access(framework, check_id) %}
select * from (
with fixed_statement as (
SELECT
    account_id,
    arn,
    CASE 
        WHEN json_array_length(json_extract(policy_document, '$.Statement')) IS NULL 
            THEN json_parse('[' || json_extract_scalar(policy_document, '$.Statement') || ']')
        ELSE json_extract(policy_document, '$.Statement')
    END AS statement_fix
FROM aws_lambda_functions 
)

SELECT
    '{{framework}}' AS framework,
    '{{check_id}}' AS check_id,
    'Lambda functions should prohibit public access' AS title,
    account_id,
    arn as resource_id,
    'fail' as status
FROM fixed_statement,
    UNNEST(CAST(statement_fix as array(json))) as t(statement) 
WHERE  
    JSON_EXTRACT_SCALAR(statement, '$.Effect') = 'Allow'
        and (
            JSON_EXTRACT_SCALAR(statement, '$.Principal') = '*'
            or JSON_EXTRACT_SCALAR(statement, '$.Principal.AWS') = '*'
            or JSON_ARRAY_CONTAINS(JSON_EXTRACT(statement, '$.Principal.AWS'), '*')
        )
)
{% endmacro %}