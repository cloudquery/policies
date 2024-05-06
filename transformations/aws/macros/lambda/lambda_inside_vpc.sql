{% macro lambda_inside_vpc(framework, check_id) %}
  {{ return(adapter.dispatch('lambda_inside_vpc')(framework, check_id)) }}
{% endmacro %}

{% macro default__lambda_inside_vpc(framework, check_id) %}{% endmacro %}

{% macro postgres__lambda_inside_vpc(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
  'Lambda functions should be in a VPC' AS title,
  account_id,
  arn AS resource_id,
  CASE
  WHEN (configuration -> 'VpcConfig' ->> 'VpcId') IS NULL
  OR configuration -> 'VpcConfig' ->> 'VpcId' = ''
  THEN 'fail'
  ELSE 'pass'
  END
    AS status
FROM
  aws_lambda_functions
{% endmacro %}

{% macro snowflake__lambda_inside_vpc(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
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
{% endmacro %}

{% macro bigquery__lambda_inside_vpc(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
  'Lambda functions should be in a VPC' AS title,
  account_id,
  arn AS resource_id,
  CASE
  WHEN (configuration.VpcConfig.VpcId) IS NULL
  OR JSON_VALUE(configuration.VpcConfig.VpcId) = ''
  THEN 'fail'
  ELSE 'pass'
  END
    AS status
FROM
  {{ full_table_name("aws_lambda_functions") }}
{% endmacro %}

{% macro athena__lambda_inside_vpc(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
  'Lambda functions should be in a VPC' AS title,
  account_id,
  arn AS resource_id,
  CASE
  WHEN json_extract_scalar(configuration, '$.VpcConfig.VpcId') IS NULL
  OR json_extract_scalar(configuration, '$.VpcConfig.VpcId') = ''
  THEN 'fail'
  ELSE 'pass'
  END
    AS status
FROM
  aws_lambda_functions
{% endmacro %}