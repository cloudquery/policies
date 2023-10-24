{% macro instances_should_be_deployed_in_a_vpc(framework, check_id) %}
insert into aws_policy_results
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'RDS instances should be deployed in a VPC' as title,
    account_id,
    arn AS resource_id,
    case when db_subnet_group:VpcId is null then 'fail' else 'pass' end as status
from aws_rds_instances
{% endmacro %}