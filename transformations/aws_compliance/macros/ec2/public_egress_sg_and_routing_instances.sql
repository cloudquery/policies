{% macro public_egress_sg_and_routing_instances(framework, check_id) %}
  {{ return(adapter.dispatch('public_egress_sg_and_routing_instances')(framework, check_id)) }}
{% endmacro %}

{% macro default__public_egress_sg_and_routing_instances(framework, check_id) %}{% endmacro %}

{% macro postgres__public_egress_sg_and_routing_instances(framework, check_id) %}
-- Find all AWS instances that are in a subnet that includes a catchall route
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Find all ec2 instances that have unrestricted access to the internet with a wide open security group and routing' as title,
    account_id,
    instance_id as resource_id,
    'fail' as status -- TODO FIXME
from aws_ec2_instances
where subnet_id in
    --  Find all subnets that include a route table that inclues a catchall route
    (select a->>'SubnetId'
        from aws_ec2_route_tables t, jsonb_array_elements(t.associations) a, jsonb_array_elements(t.routes) r
        --  Find all routes in any route table that contains a route to 0.0.0.0/0 or ::/0
        where r->>'DestinationCidrBlock' = '0.0.0.0/0' OR r->>'DestinationIpv6CidrBlock' = '::/0'
    )
    and instance_id in
    -- 	Find all instances that have egress rule that allows access to all ip addresses
    (select instance_id
        from aws_ec2_instances, jsonb_array_elements(security_groups) sg
        inner join {{ ref('aws_compliance__security_group_egress_rules') }} on id = sg->>'GroupId'
        where (ip = '0.0.0.0/0' or ip6 = '::/0'))
{% endmacro %}
