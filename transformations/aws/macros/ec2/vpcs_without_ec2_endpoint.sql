{% macro vpcs_without_ec2_endpoint(framework, check_id) %}
  {{ return(adapter.dispatch('vpcs_without_ec2_endpoint')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__vpcs_without_ec2_endpoint(framework, check_id) %}
with endpoints as (
    select vpc_endpoint_id
    from aws_ec2_vpc_endpoints
    where vpc_endpoint_type = 'Interface'
        and service_name like CONCAT(
            'com.amazonaws.', region, '.ec2'
        )
)

select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Amazon EC2 should be configured to use VPC endpoints that are created for the Amazon EC2 service' as title,
    account_id,
    vpc_id as resource_id,
    case when
        endpoints.vpc_endpoint_id is null
        then 'fail'
        else 'pass'
    end as status
from aws_ec2_vpcs
left join endpoints
    on aws_ec2_vpcs.vpc_id = endpoints.vpc_endpoint_id
{% endmacro %}

{% macro postgres__vpcs_without_ec2_endpoint(framework, check_id) %}
with endpoints as (
    select vpc_endpoint_id
    from aws_ec2_vpc_endpoints
    where vpc_endpoint_type = 'Interface'
        and service_name ~ CONCAT(
            'com.amazonaws.', region, '.ec2'
        )
)

select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Amazon EC2 should be configured to use VPC endpoints that are created for the Amazon EC2 service' as title,
    account_id,
    vpc_id as resource_id,
    case when
        endpoints.vpc_endpoint_id is null
        then 'fail'
        else 'pass'
    end as status
from aws_ec2_vpcs
left join endpoints
    on aws_ec2_vpcs.vpc_id = endpoints.vpc_endpoint_id
{% endmacro %}

{% macro default__vpcs_without_ec2_endpoint(framework, check_id) %}{% endmacro %}
                    