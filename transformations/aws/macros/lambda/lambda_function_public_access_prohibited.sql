{% macro lambda_function_public_access_prohibited(framework, check_id) %}
  {{ return(adapter.dispatch('lambda_function_public_access_prohibited')(framework, check_id)) }}
{% endmacro %}

{% macro default__lambda_function_public_access_prohibited(framework, check_id) %}{% endmacro %}

{% macro postgres__lambda_function_public_access_prohibited(framework, check_id) %}
with wildcards as 
(select
    arn  from
    aws_lambda_functions,
    jsonb_array_elements(policy_document -> 'Statement') as statement
  where
    statement ->> 'Effect' = 'Allow'
    and (
      (statement -> 'Principal' -> 'AWS') = '["*"]'
      or statement ->> 'Principal' = '*'
    )
	and statement -> 'Condition' is null)
select DISTINCT
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Lambda function policies should prohibit public access' AS title,
    alf.account_id,
    alf.arn AS resource_id,
	case when wildcards.arn is null then 'pass'
	else 'fail' end as status
from aws_lambda_functions alf
left join wildcards on alf.arn = wildcards.arn
{% endmacro %}

{% macro snowflake__lambda_function_public_access_prohibited(framework, check_id) %}
with wildcards as
(select
    arn,
    statements.*
from aws_lambda_functions,
LATERAL FLATTEN(INPUT => IFF(TYPEOF(policy_document:Statement) = 'STRING', 
                                              TO_ARRAY(policy_document:Statement), 
                                              policy_document:Statement)) AS statements
where
  statements.value:Effect = 'Allow'
  and
  (statements.value:Principal = '*' or (statements.value:Principal:AWS = '["*"]'))
  and statements.value:Condition is null
  )
select DISTINCT
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Lambda function policies should prohibit public access' AS title,
    alf.account_id,
    alf.arn AS resource_id,
	case when wildcards.arn is null then 'pass'
	else 'fail' end as status
from aws_lambda_functions alf
left join wildcards on alf.arn = wildcards.arn
{% endmacro %}

{% macro bigquery__lambda_function_public_access_prohibited(framework, check_id) %}
with wildcards as
  (
    SELECT
    arn
    FROM
    {{ full_table_name("aws_lambda_functions") }}
    LEFT JOIN UNNEST(JSON_QUERY_ARRAY(policy_document.Statement)) AS statement
    where
      JSON_VALUE(statement.Effect) = 'Allow'
      and
        (JSON_VALUE(statement.Principal) = '*'
        or
        (JSON_VALUE(statement.Principal.AWS) = '["*"]'))
      and
        json_query(statement, '$.Condition') is null  
      )
  select DISTINCT
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Lambda function policies should prohibit public access' AS title,
    alf.account_id,
    alf.arn AS resource_id,
    case when wildcards.arn is null then 'pass'
	  else 'fail' end as status
  from {{ full_table_name("aws_lambda_functions") }} alf
  left join wildcards on alf.arn = wildcards.arn
{% endmacro %}

{% macro athena__lambda_function_public_access_prohibited(framework, check_id) %}
with wildcards as
(select
    arn
from aws_lambda_functions,
unnest(cast(json_extract(policy_document, '$.Statement') as array(json))) as statements (statements)
where
  json_extract_scalar(statements, '$.Effect') = 'Allow'
  and
  (json_extract_scalar(statements, '$.Principal') = '*' or (json_extract_scalar(statements, '$.Principal') = '["*"]'))
  and json_extract_scalar(statements, '$.Condition') is null
  )
select DISTINCT
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Lambda function policies should prohibit public access' AS title,
    alf.account_id,
    alf.arn AS resource_id,
	case when wildcards.arn is null then 'pass'
	else 'fail' end as status
from aws_lambda_functions alf
left join wildcards on alf.arn = wildcards.arn
{% endmacro %}