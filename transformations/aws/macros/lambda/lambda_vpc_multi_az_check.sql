{% macro lambda_vpc_multi_az_check(framework, check_id) %}
  {{ return(adapter.dispatch('lambda_vpc_multi_az_check')(framework, check_id)) }}
{% endmacro %}

{% macro default__lambda_vpc_multi_az_check(framework, check_id) %}{% endmacro %}

{% macro postgres__lambda_vpc_multi_az_check(framework, check_id) %}
SELECT
    '{{framework}}' AS framework,
    '{{check_id}}' AS check_id,
    'VPC Lambda functions should operate in more than one Availability Zone' AS title,
    l.account_id,
    l.arn AS resource_id,
    CASE
        WHEN COUNT(DISTINCT s.availability_zone_id) > 1 THEN 'pass'
        ELSE 'fail'
    END AS status
FROM
    aws_lambda_functions AS l
INNER JOIN
    JSONB_ARRAY_ELEMENTS(l.configuration->'VpcConfig'->'SubnetIds') AS a ON TRUE
LEFT JOIN
    aws_ec2_subnets AS s ON a.value::text = s.subnet_id
GROUP BY
    l.arn, l.account_id
{% endmacro %}

{% macro snowflake__lambda_vpc_multi_az_check(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
  'VPC Lambda functions should operate in more than one Availability Zone' AS title,
    l.account_id, 
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
group by l.arn, l.account_id
{% endmacro %}

{% macro bigquery__lambda_vpc_multi_az_check(framework, check_id) %}
select
    'foundational_security' As framework,
    'lambda.5' As check_id,
  'VPC Lambda functions should operate in more than one Availability Zone' AS title,
    l.account_id, 
    l.arn AS resource_id,
    CASE WHEN
    count (distinct s.availability_zone_id) > 1 THEN 'pass'
    ELSE 'fail'
    end as status
FROM
    {{ full_table_name("aws_lambda_functions") }} as l,
    UNNEST(JSON_QUERY_ARRAY(configuration.VpcConfig.SubnetIds)) AS a
LEFT JOIN
    {{ full_table_name("aws_ec2_subnets") }} s
ON
    JSON_VALUE(a.value) = s.subnet_id
group by l.arn, l.account_id
{% endmacro %}

{% macro athena__lambda_vpc_multi_az_check(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
  'VPC Lambda functions should operate in more than one Availability Zone' AS title,
    l.account_id, 
    l.arn AS resource_id,
    CASE WHEN
    count (distinct s.availability_zone_id) > 1 THEN 'pass'
    ELSE 'fail'
    end as status
FROM
    aws_lambda_functions as l
LEFT JOIN
    aws_ec2_subnets s
ON
    json_extract_scalar(l.configuration, '$.VpcConfig.SubnetIds') = s.subnet_id
group by l.arn, l.account_id
{% endmacro %}