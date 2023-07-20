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

API_GATEWAY_METHOD_SETTINGS = """
CREATE OR REPLACE VIEW view_aws_apigateway_method_settings AS
SELECT
    s.arn,
    s.rest_api_arn,
    s.stage_name,
    s.tracing_enabled AS stage_data_trace_enabled,
    s.cache_cluster_enabled AS stage_caching_enabled,
    s.web_acl_arn AS waf,
    s.client_certificate_id AS cert,
    key AS method,
    CASE WHEN PARSE_JSON(value):DataTraceEnabled::STRING = 'true' THEN 1 ELSE 0 END AS data_trace_enabled,
    CASE WHEN PARSE_JSON(value):CachingEnabled::STRING = 'true' THEN 1 ELSE 0 END AS caching_enabled,
    CASE WHEN PARSE_JSON(value):CacheDataEncrypted::STRING = 'true' THEN 1 ELSE 0 END AS cache_data_encrypted,
    PARSE_JSON(value):LoggingLevel::STRING AS logging_level,
    r.account_id
FROM aws_apigateway_rest_api_stages s
JOIN aws_apigateway_rest_apis r ON s.rest_api_arn=r.arn,
LATERAL FLATTEN(input=>PARSE_JSON(s.method_settings))
"""