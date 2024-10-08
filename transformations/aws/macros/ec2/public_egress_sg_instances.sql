{% macro public_egress_sg_instances(framework, check_id) %}
  {{ return(adapter.dispatch('public_egress_sg_instances')(framework, check_id)) }}
{% endmacro %}

{% macro default__public_egress_sg_instances(framework, check_id) %}{% endmacro %}

{% macro postgres__public_egress_sg_instances(framework, check_id) %}
-- Find all AWS instances that have a security group that allows unrestricted egress
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'All ec2 instances that have unrestricted access to the internet via a security group' as title,
    aws_ec2_instances.account_id,
    instance_id as resource_id,
    'fail' as status -- TODO FIXME
from aws_ec2_instances, jsonb_array_elements(security_groups) sg
    -- 	Find all instances that have egress rule that allows access to all ip addresses
    inner join {{ ref('aws_compliance__security_group_egress_rules') }} on id = sg->>'GroupId'
where (ip = '0.0.0.0/0' or ip6 = '::/0')
{% endmacro %}

{% macro bigquery__public_egress_sg_instances(framework, check_id) %}
-- Find all AWS instances that have a security group that allows unrestricted egress
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'All ec2 instances that have unrestricted access to the internet via a security group' as title,
    aws_ec2_instances.account_id,
    instance_id as resource_id,
    'fail' as status -- TODO FIXME
from {{ full_table_name("aws_ec2_instances") }},
    UNNEST(JSON_QUERY_ARRAY(security_groups)) AS sg
    -- 	Find all instances that have egress rule that allows access to all ip addresses
    inner join {{ ref('aws_compliance__security_group_egress_rules') }} on id = JSON_VALUE(sg.GroupId)
where (ip = '0.0.0.0/0' or ip6 = '::/0')
{% endmacro %}

{% macro snowflake__public_egress_sg_instances(framework, check_id) %}
-- Find all AWS instances that have a security group that allows unrestricted egress
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'All ec2 instances that have unrestricted access to the internet via a security group' as title,
    aws_ec2_instances.account_id,
    instance_id as resource_id,
    'fail' as status -- TODO FIXME
from aws_ec2_instances, 
    LATERAL FLATTEN(security_groups) sg
    -- 	Find all instances that have egress rule that allows access to all ip addresses
    inner join {{ ref('aws_compliance__security_group_egress_rules') }} on id = sg.value:GroupId
where (ip = '0.0.0.0/0' or ip6 = '::/0')
{% endmacro %}

{% macro athena__public_egress_sg_instances(framework, check_id) %}
select * from (
    WITH SecurityGroupIds AS (
    SELECT 
        account_id,
        instance_id,
        json_extract_scalar(sg, '$.GroupId') AS group_id
    FROM 
        aws_ec2_instances,
        UNNEST(cast(json_extract(security_groups, '$') as array(json))) AS t(sg)
)
-- Find all AWS instances that have a security group that allows unrestricted egress
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'All ec2 instances that have unrestricted access to the internet via a security group' as title,
    sgi.account_id,
    instance_id as resource_id,
    'fail' as status -- TODO FIXME
from SecurityGroupIds sgi
    -- 	Find all instances that have egress rule that allows access to all ip addresses
    inner join {{ ref('aws_compliance__security_group_egress_rules') }} on id = group_id
where (ip = '0.0.0.0/0' or ip6 = '::/0')
)
{% endmacro %}