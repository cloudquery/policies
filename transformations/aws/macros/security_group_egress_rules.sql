{% macro security_group_egress_rules(framework, check_id) %}
  {{ return(adapter.dispatch('security_group_egress_rules')()) }}
{% endmacro %}

{% macro default__security_group_egress_rules() %}{% endmacro %}

{% macro postgres__security_group_egress_rules() %}
select
    account_id,
    region,
    group_name,
    arn,
    group_id as id,
    vpc_id,
    (i->>'FromPort')::integer AS from_port,
        (i->>'ToPort')::integer AS to_port,
        i->>'IpProtocol' AS ip_protocol,
    ip_ranges->>'CidrIp' AS ip,
    ip6_ranges->>'CidrIpv6' AS ip6
from aws_ec2_security_groups, JSONB_ARRAY_ELEMENTS(aws_ec2_security_groups.ip_permissions_egress) as i
    LEFT JOIN JSONB_ARRAY_ELEMENTS(i->'IpRanges') as ip_ranges ON true
    LEFT JOIN JSONB_ARRAY_ELEMENTS(i->'Ipv6Ranges') as ip6_ranges ON true
{% endmacro %}

{% macro bigquery__security_group_egress_rules() %}
select 
    account_id,
    region,
    group_name,
    arn,
    group_id as id,
    vpc_id,
    CAST(JSON_VALUE(i.FromPort) AS INT64) AS from_port,
    CAST(JSON_VALUE(i.ToPort) AS INT64) AS to_port,
    JSON_VALUE(i.IpProtocol) AS ip_protocol,
    JSON_VALUE(ip_ranges.CidrIp) AS ip,
    JSON_VALUE(ip6_ranges.CidrIpv6) AS ip6
    from {{ full_table_name("aws_ec2_security_groups") }},
    UNNEST(JSON_QUERY_ARRAY(ip_permissions_egress)) AS i
    LEFT JOIN 
    UNNEST(JSON_QUERY_ARRAY(i.IpRanges)) AS ip_ranges ON true
    LEFT JOIN 
    UNNEST(JSON_QUERY_ARRAY(i.Ipv6Ranges)) AS ip6_ranges ON true
{% endmacro %}

{% macro snowflake__security_group_egress_rules() %}
select
    account_id,
    region,
    group_name,
    arn,
    group_id as id,
    vpc_id,
    i.value:FromPort::number AS from_port,
    i.value:ToPort::number AS to_port,
    i.value:IpProtocol AS ip_protocol,
    ip_ranges.value:CidrIp AS ip,
    ip6_ranges.value:CidrIpv6 AS ip6
from aws_ec2_security_groups, lateral flatten(input => parse_json(aws_ec2_security_groups.ip_permissions_egress)) as i,
    lateral flatten(input => i.value:IpRanges, OUTER => TRUE) as ip_ranges,
    lateral flatten(input => i.value:Ipv6Ranges, OUTER => TRUE) as ip6_ranges
{% endmacro %}

{% macro athena__security_group_egress_rules() %}
SELECT
    sg.account_id,
    sg.region,
    sg.group_name,
    sg.arn,
    sg.group_id AS id,
    sg.vpc_id,
    cast(json_extract(ip_permission, '$.FromPort') as int) AS from_port,
    cast(json_extract(ip_permission, '$.ToPort') as int) AS to_port,
    json_extract_scalar(ip_permission, '$.IpProtocol') AS ip_protocol,
    json_extract_scalar(ip_range, '$') AS ip,
    json_extract_scalar(ip6_range, '$') AS ip6
FROM
    aws_ec2_security_groups sg
    cross JOIN UNNEST(cast(json_extract(sg.ip_permissions_egress, '$') as array(json))) as t(ip_permission)
    LEFT JOIN UNNEST(cast(json_extract(ip_permission, '$.IpRanges') as array(json))) as t2(ip_range) ON true
    LEFT JOIN UNNEST(cast(json_extract(ip_permission, '$.Ipv6Ranges') as array(json))) as t3(ip6_range) ON true
{% endmacro %}