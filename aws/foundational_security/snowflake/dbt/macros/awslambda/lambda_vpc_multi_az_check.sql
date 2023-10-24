{% macro lambda_vpc_multi_az_check(framework, check_id) %}
INSERT INTO aws_policy_results
SELECT
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
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
{% endmacro %}