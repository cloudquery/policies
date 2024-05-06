{% macro instances_should_be_deployed_in_a_vpc(framework, check_id) %}
  {{ return(adapter.dispatch('instances_should_be_deployed_in_a_vpc')(framework, check_id)) }}
{% endmacro %}

{% macro default__instances_should_be_deployed_in_a_vpc(framework, check_id) %}{% endmacro %}

{% macro postgres__instances_should_be_deployed_in_a_vpc(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'RDS instances should be deployed in a VPC' as title,
    account_id,
    arn AS resource_id,
    case when db_subnet_group ->> 'VpcId' is null then 'fail' else 'pass' end as status
from aws_rds_instances
{% endmacro %}

{% macro snowflake__instances_should_be_deployed_in_a_vpc(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'RDS instances should be deployed in a VPC' as title,
    account_id,
    arn AS resource_id,
    case when db_subnet_group:VpcId is null then 'fail' else 'pass' end as status
from aws_rds_instances
{% endmacro %}

{% macro bigquery__instances_should_be_deployed_in_a_vpc(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'RDS instances should be deployed in a VPC' as title,
    account_id,
    arn AS resource_id,
    case when JSON_VALUE(db_subnet_group.VpcId) is null then 'fail' else 'pass' end as status
from {{ full_table_name("aws_rds_instances") }}
{% endmacro %}

{% macro athena__instances_should_be_deployed_in_a_vpc(framework, check_id) %}
SELECT
    '{{framework}}' AS framework,
    '{{check_id}}' AS check_id,
    'RDS instances should be deployed in a VPC' AS title,
    account_id,
    arn AS resource_id,
    CASE 
        WHEN json_extract(db_subnet_group, '$.VpcId') IS NULL THEN 'fail'
        ELSE 'pass'
    END AS status
FROM aws_rds_instances
{% endmacro %}