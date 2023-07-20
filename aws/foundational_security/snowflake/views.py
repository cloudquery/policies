CREATE_AWS_POLICY_RESULTS = """
create table if not exists aws_policy_results (
    execution_time timestamp with time zone,
    framework varchar(255),
    check_id varchar(255),
    title text,
    account_id varchar(1024),
    resource_id varchar(1024),
    status varchar(16)
)
"""

SECURITY_GROUP_INGRESS_RULES = """
create or replace view view_aws_security_group_ingress_rules as
    select
        account_id,
        region,
        group_name,
        arn,
        group_id as id,
        vpc_id,
        ip_permissions.value:FromPort::number AS from_port,
        ip_permissions.value:ToPort::number AS to_port,
        ip_permissions.value:IpProtocol AS ip_protocol,
        ip_ranges.value:CidrIp AS ip,
        ip6_ranges.value:CidrIpv6 AS ip6
    from aws_ec2_security_groups, lateral flatten(input => parse_json(aws_ec2_security_groups.ip_permissions)) as ip_permissions,
    lateral flatten(input => ip_permissions.value:IpRanges, OUTER => TRUE) as ip_ranges,
    lateral flatten(input => ip_permissions.value:Ipv6Ranges, OUTER => TRUE) as ip6_ranges;
"""