{% macro ec2_security_group_ingress_rules() %}
  {{ return(adapter.dispatch('ec2_security_group_ingress_rules')()) }}
{% endmacro %}

{% macro default__ec2_security_group_ingress_rules() %}{% endmacro %}

{% macro postgres__ec2_security_group_ingress_rules() %}
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
    from aws_ec2_security_groups, JSONB_ARRAY_ELEMENTS(aws_ec2_security_groups.ip_permissions) as i
    LEFT JOIN JSONB_ARRAY_ELEMENTS(i->'IpRanges') as ip_ranges ON true
    LEFT JOIN JSONB_ARRAY_ELEMENTS(i->'Ipv6Ranges') as ip6_ranges ON true
{% endmacro %}


{% macro snowflake__ec2_security_group_ingress_rules() %}
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
    lateral flatten(input => ip_permissions.value:Ipv6Ranges, OUTER => TRUE) as ip6_ranges
{% endmacro %}

{% macro bigquery__ec2_security_group_ingress_rules() %}
    WITH 
    ip_permissions as (
      select
      i as value,
      account_id,
        region,
        group_name,
        arn,
        group_id ,
        vpc_id, 
      from {{ full_table_name("aws_ec2_security_groups") }},
    UNNEST(JSON_QUERY_ARRAY(aws_ec2_security_groups.ip_permissions)) as i
    ),
    ip_ranges as (
    select
      ip_ranges as value          
    FROM ip_permissions,
    UNNEST(JSON_QUERY_ARRAY(value.IpRanges)) as ip_ranges
      ),
    ip6_ranges as (
    select
      ip6_ranges as value          
    FROM ip_permissions,
    UNNEST(JSON_QUERY_ARRAY(value.Ipv6Ranges)) as ip6_ranges
    )    
select
        account_id,
        region,
        group_name,
        arn,
        group_id as id,
        vpc_id,
        CAST(JSON_VALUE(i.value.FromPort) AS INT64) AS from_port,
        CAST(JSON_VALUE(i.value.ToPort) AS INT64) AS to_port,
        JSON_VALUE(i.value.IpProtocol) AS ip_protocol,
        JSON_VALUE(ip_ranges.value.CidrIp) AS ip,
        JSON_VALUE(ip6_ranges.value.CidrIpv6) AS ip6
    from ip_permissions as i 
    LEFT JOIN ip_ranges ON TRUE
    LEFT JOIN ip6_ranges ON TRUE
{% endmacro %}