{% macro functions_with_public_egress(framework, check_id) %}
  {{ return(adapter.dispatch('functions_with_public_egress')(framework, check_id)) }}
{% endmacro %}

{% macro default__functions_with_public_egress(framework, check_id) %}{% endmacro %}

{% macro postgres__functions_with_public_egress(framework, check_id) %}
select distinct
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Find all lambda functions that have unrestricted access to the internet' AS title,
    account_id,
    arn AS resource_id,
    'fail' AS status -- TODO FIXME
from aws_lambda_functions,
    JSONB_ARRAY_ELEMENTS_TEXT(configuration->'VpcConfig'->'SecurityGroupIds') as sgs,
     JSONB_ARRAY_ELEMENTS_TEXT(configuration->'VpcConfig'->' SubnetIds') as sns
where sns in
    --  Find all subnets that include a route table that inclues a catchall route
    (select a->>'SubnetId'
        from aws_ec2_route_tables, jsonb_array_elements(associations) a, jsonb_array_elements(routes) r
        where r->>'DestinationCidrBlock' = '0.0.0.0/0' OR r->>'DestinationIpv6CidrBlock' = '::/0'
    )
    and sgs in
    -- 	Find all functions that have egress rule that allows access to all ip addresses
    (select id from aws_compliance__security_group_egress_rules where ip = '0.0.0.0/0' or ip6 = '::/0')
union
-- Find all Lambda functions that do not run in a VPC
select distinct
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Find all lambda functions that have unrestricted access to the internet' AS title,
    account_id,
    arn AS resource_id,
    'fail' AS status -- TODO FIXME
from aws_lambda_functions
where configuration->'VpcConfig'->>'VpcId' is null

-- Note: We do not restrict the search to specific Runtimes
{% endmacro %}
