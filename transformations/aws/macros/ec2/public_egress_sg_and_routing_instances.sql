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

{% macro bigquery__public_egress_sg_and_routing_instances(framework, check_id) %}
-- Find all AWS instances that are in a subnet that includes a catchall route
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Find all ec2 instances that have unrestricted access to the internet with a wide open security group and routing' as title,
    account_id,
    instance_id as resource_id,
    'fail' as status -- TODO FIXME
from {{ full_table_name("aws_ec2_instances") }}
where subnet_id in
    --  Find all subnets that include a route table that inclues a catchall route
    (select JSON_VALUE(a.SubnetId)
        from {{ full_table_name("aws_ec2_route_tables") }} t, UNNEST(JSON_QUERY_ARRAY(t.associations)) AS a, UNNEST(JSON_QUERY_ARRAY(t.routes)) AS r
        --  Find all routes in any route table that contains a route to 0.0.0.0/0 or ::/0
        where JSON_VALUE(r.DestinationCidrBlock) = '0.0.0.0/0' OR JSON_VALUE(r.DestinationIpv6CidrBlock) = '::/0'
    )
    and instance_id in
    -- 	Find all instances that have egress rule that allows access to all ip addresses
    (select instance_id
        from {{ full_table_name("aws_ec2_instances") }}, UNNEST(JSON_QUERY_ARRAY(security_groups)) AS sg
        inner join {{ ref('aws_compliance__security_group_egress_rules') }} on id = JSON_VALUE(sg.GroupId)
        where (ip = '0.0.0.0/0' or ip6 = '::/0'))
{% endmacro %}

{% macro snowflake__public_egress_sg_and_routing_instances(framework, check_id) %}
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
    (select a.value:SubnetId
        from aws_ec2_route_tables t,
        LATERAL FLATTEN(t.associations) a,
        LATERAL FLATTEN(t.routes) r
        --  Find all routes in any route table that contains a route to 0.0.0.0/0 or ::/0
        where r.value:DestinationCidrBlock = '0.0.0.0/0' OR r.value:DestinationIpv6CidrBlock = '::/0'
    )
    and instance_id in
    -- 	Find all instances that have egress rule that allows access to all ip addresses
    (select instance_id
        from aws_ec2_instances, 
                LATERAL FLATTEN(security_groups) sg
        inner join {{ ref('aws_compliance__security_group_egress_rules') }} on id = sg.value:GroupId
        where (ip = '0.0.0.0/0' or ip6 = '::/0'))
{% endmacro %}

{% macro athena__public_egress_sg_and_routing_instances(framework, check_id) %}
select * from (
WITH SecurityGroupIds AS (
    SELECT 
        instance_id,
        json_extract_scalar(sg, '$.GroupId') AS group_id
    FROM 
        aws_ec2_instances,
        UNNEST(cast(json_extract(security_groups, '$') as array(json))) AS t(sg)
),
InstancesWithUnrestrictedAccess AS (
    SELECT 
        s.instance_id
    FROM 
        SecurityGroupIds s
        INNER JOIN {{ ref('aws_compliance__security_group_egress_rules') }} e ON s.group_id = e.id
        WHERE (ip = '0.0.0.0/0' OR ip6 = '::/0')
)
-- Find all AWS instances that are in a subnet that includes a catchall route
SELECT
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Find all EC2 instances that have unrestricted access to the internet with a wide open security group and routing' as title,
    account_id,
    instance_id as resource_id,
    'fail' as status -- TODO FIXME
FROM aws_ec2_instances
WHERE subnet_id IN
    --  Find all subnets that include a route table that includes a catchall route
    (SELECT 
        json_extract_scalar(a, '$.SubnetId')
    FROM aws_ec2_route_tables t,
        UNNEST(cast(json_extract(t.associations, '$') as array(json))) as t(a),
        UNNEST(cast(json_extract(t.routes, '$') as array(json))) as t1(r)
        --  Find all routes in any route table that contains a route to 0.0.0.0/0 or ::/0
        WHERE json_extract_scalar(r, '$.DestinationCidrBlock') = '0.0.0.0/0' OR
        json_extract_scalar(r, '$.DestinationIpv6CidrBlock') = '::/0'
    )
    AND instance_id IN (SELECT instance_id FROM InstancesWithUnrestrictedAccess)
)
{% endmacro %}