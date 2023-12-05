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

{% macro bigquery__functions_with_public_egress(framework, check_id) %}
select distinct
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Find all lambda functions that have unrestricted access to the internet' AS title,
    account_id,
    arn AS resource_id,
    'fail' AS status -- TODO FIXME
from {{ full_table_name("aws_lambda_functions") }},
        UNNEST(JSON_QUERY_ARRAY(configuration.VpcConfig.SecurityGroupIds)) AS sgs,
        UNNEST(JSON_QUERY_ARRAY(configuration.VpcConfig.SubnetIds)) AS sns
where JSON_VALUE(sns) in
    --  Find all subnets that include a route table that inclues a catchall route
    (select JSON_VALUE(a.SubnetId)
        from {{ full_table_name("aws_ec2_route_tables") }},
        UNNEST(JSON_QUERY_ARRAY(associations)) AS a,
        UNNEST(JSON_QUERY_ARRAY(routes)) AS r
        where JSON_VALUE(r.DestinationCidrBlock) = '0.0.0.0/0' OR JSON_VALUE(r.DestinationIpv6CidrBlock) = '::/0'
    )
    and JSON_VALUE(sgs) in
    -- 	Find all functions that have egress rule that allows access to all ip addresses
    (select id from {{ ref('aws_compliance__security_group_egress_rules') }} where ip = '0.0.0.0/0' or ip6 = '::/0')
union all
-- Find all Lambda functions that do not run in a VPC
select distinct
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Find all lambda functions that have unrestricted access to the internet' AS title,
    account_id,
    arn AS resource_id,
    'fail' AS status -- TODO FIXME
from {{ full_table_name("aws_lambda_functions") }}
where configuration.VpcConfig.VpcId is null

-- Note: We do not restrict the search to specific Runtimes
{% endmacro %}