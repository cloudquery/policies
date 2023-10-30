{% macro rds_instances_should_be_deployed_in_a_vpc(framework, check_id) %}
  {{ return(adapter.dispatch('rds_instances_should_be_deployed_in_a_vpc')(framework, check_id)) }}
{% endmacro %}

{% macro default__rds_instances_should_be_deployed_in_a_vpc(framework, check_id) %}{% endmacro %}

{% macro postgres__rds_instances_should_be_deployed_in_a_vpc(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'RDS instances should be deployed in a VPC' as title,
    account_id,
    arn AS resource_id,
    case when db_subnet_group->>'VpcId' is null then 'fail' else 'pass' end as status
from aws_rds_instances
{% endmacro %}
