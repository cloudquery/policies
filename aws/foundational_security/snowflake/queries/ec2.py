
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
  %s as execution_time,
  %s as framework,
  %s as check_id,
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
  %s as execution_time,
  %s as framework,
  %s as check_id,
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
    %s as execution_time,
    %s as framework,
    %s as check_id,
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
  %s as execution_time,
  %s as framework,
  %s as check_id,
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
  %s as execution_time,
  %s as framework,
  %s as check_id,
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
  %s as execution_time,
  %s as framework,
  %s as check_id,
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
  %s as execution_time,
  %s as framework,
  %s as check_id,
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
    %s as execution_time,
    %s as framework,
    %s as check_id,
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
    %s as execution_time,
    %s as framework,
    %s as check_id,
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
    %s as execution_time,
    %s as framework,
    %s as check_id,
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
    %s as execution_time,
    %s as framework,
    %s as check_id,
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
    %s as execution_time,
    %s as framework,
    %s as check_id,
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
  %s as execution_time,
  %s as framework,
  %s as check_id,
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
    %s as execution_time,
    %s as framework,
    %s as check_id,
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