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