
EBS_SNAPSHOT_PERMISSIONS_CHECK = """
insert into aws_policy_results
WITH snapshot_access_groups AS (
    SELECT account_id,
           region,
           snapshot_id,
           create_volume_permissions.value:Group AS "group",
           create_volume_permissions.value:UserId AS user_id
    FROM aws_ec2_ebs_snapshot_attributes, lateral flatten(input => parse_json(aws_ec2_ebs_snapshot_attributes.create_volume_permissions)) as create_volume_permissions
)
SELECT DISTINCT
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'Amazon EBS snapshots should not be public, determined by the ability to be restorable by anyone' as title,
  account_id,
  snapshot_id as resource_id,
  case when
    "group" = 'all'
    -- this is under question because
    -- trusted accounts(user_id) do not violate this control
        OR user_id IS DISTINCT FROM ''
    then 'fail'
    else 'pass'
  end as status
FROM snapshot_access_groups
"""

DEFAULT_SG_NO_ACCESS = """
insert into aws_policy_results
select
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'The VPC default security group should not allow inbound and outbound traffic' AS title,
  account_id,
  arn,
  case when
      group_name='default'
      and (array_size(parse_json(ip_permissions)) > 0 or array_size(parse_json(ip_permissions_egress)) > 0)
      then 'fail'
      else 'pass'
  end
FROM
    aws_ec2_security_groups;
"""

UNENCRYPTED_EBS_VOLUMES = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Attached EBS volumes should be encrypted at rest' as title,
    account_id,
    arn as resource_id,
    case when
        encrypted = FALSE
        then 'fail'
        else 'pass'
    end as status
from aws_ec2_ebs_volumes;
"""

STOPPED_MORE_THAN_30_DAYS_AGO_INSTANCES = """
insert into aws_policy_results
select
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'Stopped EC2 instances should be removed after a specified time period' as title,
  account_id,
  instance_id as resource_id,
  case when
      state:Name = 'stopped'
      and TIMESTAMPDIFF('day', CURRENT_TIMESTAMP(), state_transition_reason_time) > 30
      then 'fail'
      else 'pass'
  end AS status
from aws_ec2_instances;
"""

FLOW_LOGS_ENABLED_IN_ALL_VPCS = """
insert into aws_policy_results
select
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'VPC flow logging should be enabled in all VPCs' as title,
  aws_ec2_vpcs.account_id,
  aws_ec2_vpcs.arn,
  case when
      aws_ec2_flow_logs.resource_id is null
      then 'fail'
      else 'pass'
  end
from aws_ec2_vpcs
left join aws_ec2_flow_logs on
        aws_ec2_vpcs.vpc_id = aws_ec2_flow_logs.resource_id
"""

EBS_ENCRYPTION_BY_DEFAULT_DISABLED = """
insert into aws_policy_results
select
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'EBS default encryption should be enabled' as title,
  account_id,
  concat(account_id,':',region) as resource_id,
  case when
    ebs_encryption_enabled_by_default is distinct from true
    then 'fail'
    else 'pass'
  end as status
from aws_ec2_regional_configs
"""

NOT_IMDSV2_INSTANCES = """
insert into aws_policy_results
select
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'EC2 instances should use IMDSv2' as title,
  account_id,
  instance_id as resource_id,
  case when
    metadata_options:HttpTokens is distinct from 'required'
    then 'fail'
    else 'pass'
  end as status
from aws_ec2_instances
"""

INSTANCES_WITH_PUBLIC_IP = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'EC2 instances should not have a public IP address' as title,
    account_id,
    instance_id as resource_id,
    case when
        public_ip_address is not null
        then 'fail'
        else 'pass'
    end as status
from aws_ec2_instances
"""

VPCS_WITHOUT_EC2_ENDPOINT = """
insert into aws_policy_results
with endpoints as (
    select vpc_endpoint_id
    from aws_ec2_vpc_endpoints
    where vpc_endpoint_type = 'Interface'
        and service_name like CONCAT(
            'com.amazonaws.', region, '.ec2'
        )
)

select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Amazon EC2 should be configured to use VPC endpoints that are created for the Amazon EC2 service' as title,
    account_id,
    vpc_id as resource_id,
    case when
        endpoints.vpc_endpoint_id is null
        then 'fail'
        else 'pass'
    end as status
from aws_ec2_vpcs
left join endpoints
    on aws_ec2_vpcs.vpc_id = endpoints.vpc_endpoint_id
"""

SUBNETS_THAT_ASSIGN_PUBLIC_IPS = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'EC2 subnets should not automatically assign public IP addresses' as title,
    owner_id as account_id,
    arn as resource_id,
    case when
        map_public_ip_on_launch = TRUE
        then 'fail'
        else 'pass'
    end
from aws_ec2_subnets
"""

UNUSED_ACLS = """
insert into aws_policy_results
with results as (
select distinct
    account_id,
    network_acl_id as resource_id,
    case when
        association.value:NetworkAclAssociationId is null
        then 'pass'
        else 'fail'
    end as status
from aws_ec2_network_acls, lateral flatten(input => parse_json(aws_ec2_network_acls.associations), OUTER => TRUE) as association
)

select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Unused network access control lists should be removed' as title,
    account_id,
    resource_id,
    status
from results
"""

INSTANCES_WITH_MORE_THAN_2_NETWORK_INTERFACES = """
insert into aws_policy_results
with data as (
    select account_id, instance_id, COUNT(nics.value:Status) as cnt
    from aws_ec2_instances, lateral flatten(input => parse_json(aws_ec2_instances.network_interfaces), OUTER => TRUE) as nics
    group by account_id, instance_id
)
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'EC2 instances should not use multiple ENIs' as title,
    account_id,
    instance_id as resource_id,
    case when cnt > 1 then 'fail' else 'pass' end as status
from data
"""

SECURITY_GROUPS_WITH_ACCESS_TO_UNAUTHORIZED_PORTS = """
-- uses view which uses aws_security_group_ingress_rules.sql query
insert into aws_policy_results
SELECT
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'Aggregates rules of security groups with ports and IPs including ipv6' as title,
  account_id,
  id as resource_id,
  case when
    (ip = '0.0.0.0/0' OR ip = '::/0')
    AND (from_port IS NULL AND to_port IS NULL) -- all prots
    OR from_port IS DISTINCT FROM 80
    OR to_port IS DISTINCT FROM 80
    OR from_port IS DISTINCT FROM 443
    OR to_port IS DISTINCT FROM 443
    then 'fail'
    else 'pass'
  end
FROM view_aws_security_group_ingress_rules
"""

SECURITY_GROUPS_WITH_OPEN_CRITICAL_PORTS = """
-- uses view which uses aws_security_group_ingress_rules.sql query
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Security groups should not allow unrestricted access to ports with high risk' as title,
    account_id,
    id as resource_id,
    case when
        (ip = '0.0.0.0/0' or ip = '::/0')
        and ((from_port is null and to_port is null) -- all ports
        or 20 between from_port and to_port
        or 21 between from_port and to_port
        or 22 between from_port and to_port
        or 23 between from_port and to_port
        or 25 between from_port and to_port
        or 110 between from_port and to_port
        or 135 between from_port and to_port
        or 143 between from_port and to_port
        or 445 between from_port and to_port
        or 1433 between from_port and to_port
        or 1434 between from_port and to_port
        or 3000 between from_port and to_port
        or 3306 between from_port and to_port
        or 3389 between from_port and to_port
        or 4333 between from_port and to_port
        or 5000 between from_port and to_port
        or 5432 between from_port and to_port
        or 5500 between from_port and to_port
        or 5601 between from_port and to_port
        or 8080 between from_port and to_port
        or 8088 between from_port and to_port
        or 8888 between from_port and to_port
        or 9200 between from_port and to_port
        or 9300 between from_port and to_port)
        then 'fail'
        else 'pass'
    end
from view_aws_security_group_ingress_rules
"""

#EC2.20
BOTH_VPN_CHANNELS_SHOULD_BE_UP = """
insert into aws_policy_results
WITH TunnelStatus AS (
    SELECT
        distinct c.vpn_connection_id,
        COUNT_IF(t.value:Status::text = 'UP') OVER(PARTITION BY c.vpn_connection_id) as up_count
    FROM
        aws_ec2_vpn_connections c,
        LATERAL FLATTEN(input => c.vgw_telemetry) t
)

SELECT
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Both VPN tunnels for an AWS Site-to-Site VPN connection should be up' as title,
    c.account_id,
    'arn:aws:ec2:' || c.region || ':' || c.account_id || ':vpn-connection/' || c.vpn_connection_id AS resource_id,
    CASE
        WHEN t.up_count >= 2 THEN 'pass'
        ELSE 'fail'
    END as status
FROM
    aws_ec2_vpn_connections c
LEFT JOIN TunnelStatus t ON c.vpn_connection_id = t.vpn_connection_id
"""

#EC2.21
NETWORK_ACLS_SHOULD_NOT_ALLOW_INGRESS_FOR_SSH_RDP_PORTS = """
insert into aws_policy_results
WITH bad_entries as (
SELECT
    DISTINCT
    arn
FROM 
    aws_ec2_network_acls,
    LATERAL FLATTEN(input => entries) AS entry
WHERE 
    entry.value:Egress::STRING = 'false'
    AND entry.value:Protocol::STRING = '6'
    AND entry.value:RuleAction::STRING = 'allow'
    AND (
        entry.value:PortRange:From::INTEGER IN (22, 3389) 
        OR entry.value:PortRange:To::INTEGER IN (22, 3389)
    )
    AND (
        entry.value:CidrBlock::STRING = '0.0.0.0/0' 
        OR entry.value:Ipv6CidrBlock::STRING = '::/0'
)
)
SELECT
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Network ACLs should not allow ingress from 0.0.0.0/0 to port 22 or port 3389' as title,
    a.account_id,
    a.arn as resource_id,
    CASE
        WHEN b.arn is not null THEN 'fail'
        ELSE 'pass'
    END as status
FROM
    aws_ec2_network_acls a
LEFT JOIN bad_entries b
    ON a.arn = b.arn
"""

#EC2.22
SECURITY_GROUPS_NOT_ASSOCIATED ="""
insert into aws_policy_results
WITH used_security_groups AS (
    -- Security groups associated with EC2 instances
    SELECT sg.value:GroupId::text as security_group_id
      FROM aws_ec2_instances
      JOIN LATERAL FLATTEN(input => security_groups) as sg
    UNION
    -- Security groups associated with network interfaces
      SELECT sg.value:GroupId::text as security_group_id
      FROM aws_ec2_network_interfaces
      JOIN LATERAL FLATTEN(input => groups) as sg
)
SELECT 
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'Unused Amazon EC2 security groups should be removed' as title,
   account_id,
   arn as resource_id,
CASE
when group_id IN (SELECT DISTINCT security_group_id FROM used_security_groups) THEN 'pass'
ELSE 'fail'
END as status
FROM aws_ec2_security_groups
"""

#EC2.23
TRANSIT_GATEWAYS_SHOULD_NOT_AUTO_ACCEPT_VPC_ATTACHMENTS = """
insert into aws_policy_results
SELECT
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Amazon EC2 Transit Gateways should not automatically accept VPC attachment requests' as title,
    account_id,
    arn as resource_id,
    CASE
    WHEN options:AutoAcceptSharedAttachments = 'enable' THEN 'fail'
    ELSE 'pass'
    END as status
FROM aws_ec2_transit_gateways
"""

#EC2.24
PARAVIRTUAL_INSTANCES_SHOULD_NOT_BE_USED = """
insert into aws_policy_results
SELECT
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Amazon EC2 paravirtual instance types should not be used' as title,
    account_id,
    arn as resource_id,
    CASE
    WHEN virtualization_type = 'paravirtual' THEN 'fail'
    ELSE 'pass'
    END as status
FROM aws_ec2_instances
"""

#EC2.25
LAUNCH_TEMPLATES_SHOULD_NOT_ASSIGN_PUBLIC_IP = """
insert into aws_policy_results
WITH FlattenedData AS (
    SELECT
        account_id,
        arn,
        flat_interfaces.value as interface
    FROM
        aws_ec2_launch_template_versions
   JOIN LATERAL FLATTEN(input => launch_template_data:networkInterfaceSet) as flat_interfaces
   WHERE default_version
)

SELECT
    DISTINCT
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Amazon EC2 launch templates should not assign public IPs to network interfaces' as title,
    FlattenedData.account_id,
    FlattenedData.arn as resource_id,
    CASE
    WHEN association:publicIp is not null
        OR interface:associatePublicIpAddress::BOOLEAN = TRUE THEN 'fail'
    ELSE 'pass'
    END as status 
FROM
    FlattenedData
LEFT JOIN
    aws_ec2_network_interfaces
        ON interface:networkInterfaceId = aws_ec2_network_interfaces.network_interface_id;
"""

####### A slightly more optimized version of LAUNCH_TEMPLATES_SHOULD_NOT_ASSIGN_PUBLIC_IP
# SELECT DISTINCT
#     :1 as execution_time,
#     :2 as framework,
#     :3 as check_id,
#     aws_ec2_launch_template_versions.account_id,
#     aws_ec2_launch_template_versions.arn as resource_id,
#     CASE
#     WHEN association:publicIp is not null
#     OR flat_interfaces.value:associatePublicIpAddress::BOOLEAN = TRUE THEN 'fail'
#     ELSE 'pass'
#     END as status 


# FROM
#     aws_ec2_launch_template_versions
# JOIN LATERAL FLATTEN(input => launch_template_data:networkInterfaceSet) as flat_interfaces
# LEFT JOIN
#   aws_ec2_network_interfaces
#       ON flat_interfaces.value:networkInterfaceId = aws_ec2_network_interfaces.network_interface_id;