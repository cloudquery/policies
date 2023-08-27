# ELB.2
ELBV1_CERT_PROVIDED_BY_ACM = """
insert into aws_policy_results
with listeners as (
  select
      lb.account_id as account_id,
      lb.arn as resource_id,
      li.value:Listener:Protocol as protocol,
      li.value:Listener:SSLCertificateId as ssl_certificate_id
  from
      aws_elbv1_load_balancers lb,
      lateral flatten(input => parse_json(lb.listener_descriptions), outer => TRUE) as li
)

select
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'Classic Load Balancers with SSL/HTTPS listeners should use a certificate provided by AWS Certificate Manager' as title,
  listeners.account_id,
  listeners.resource_id,
  case when
    listeners.protocol = 'HTTPS' and aws_acm_certificates.arn is null
    then 'fail'
    else 'pass'
  end as status
from listeners
left join aws_acm_certificates on aws_acm_certificates.arn = listeners.ssl_certificate_id
"""

# ELB.3
ELBV1_HTTPS_OR_TLS = """
insert into aws_policy_results
select
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'Classic Load Balancer listeners should be configured with HTTPS or TLS termination' as title,
  lb.account_id,
  lb.arn as resource_id,
  case when
    li.value:Listener:Protocol not in ('HTTPS', 'SSL')
    then 'fail'
    else 'pass'
  end as status
from aws_elbv1_load_balancers lb, lateral flatten(input => parse_json(lb.listener_descriptions)) as li
"""

#ELB.4
ALB_DROP_HTTP_HEADERS = """
insert into aws_policy_results
select
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'Application load balancers should be configured to drop HTTP headers' as title,
  lb.account_id,
  lb.arn as resource_id,
  case when
       lb.type = 'application' and (a.value)::boolean is distinct from true -- TODO check
    then 'fail'
    else 'pass'
  end as status
from aws_elbv2_load_balancers lb
inner join
    aws_elbv2_load_balancer_attributes a on
        a.load_balancer_arn = lb.arn and a.key='routing.http.drop_invalid_header_fields.enabled'
"""

#ELB.5
ALB_LOGGING_ENABLED = """
insert into aws_policy_results
(select
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'Application and Classic Load Balancers logging should be enabled' as title,
  lb.account_id,
  lb.arn as resource_id,
  case when
    lb.type = 'application' and (a.value)::boolean is distinct from true -- TODO check
    then 'fail'
    else 'pass'
  end as status
  from aws_elbv2_load_balancers lb
    inner join
        aws_elbv2_load_balancer_attributes a on
            a.load_balancer_arn = lb.arn AND a.key='access_logs.s3.enabled')
union
(
    select
      :1 as execution_time,
      :2 as framework,
      :3 as check_id,
      'Application and Classic Load Balancers logging should be enabled' as title,
      account_id,
      arn as resource_id,
      case when
        (attributes:AccessLog:Enabled)::boolean is distinct from true
        then 'fail'
        else 'pass'
      end as status
    from
        aws_elbv1_load_balancers
)
"""

#ELB.6
ALB_DELETION_PROTECTION_ENABLED = """
insert into aws_policy_results
select
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'Application Load Balancer deletion protection should be enabled' as title,
  lb.account_id,
  lb.arn as resource_id,
  case when
    lb.type = 'application' and (a.value)::boolean is distinct from true -- TODO check
   then 'fail'
   else 'pass'
  end as status
from aws_elbv2_load_balancers lb
         inner join
     aws_elbv2_load_balancer_attributes a on
                 a.load_balancer_arn = lb.arn AND a.key='deletion_protection.enabled'
"""

#ELB.7
ELBV1_CONN_DRAINING_ENABLED = """
insert into aws_policy_results
select
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'Classic Load Balancers should have connection draining enabled' as title,
  account_id,
  arn as resource_id,
  case when
    (attributes:ConnectionDraining:Enabled)::boolean is distinct from true
    then 'fail'
    else 'pass'
  end as status
from
    aws_elbv1_load_balancers
"""

#ELB.8
ELBV1_HTTPS_PREDEFINED_POLICY = """
insert into aws_policy_results
select
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'Classic Load Balancers with HTTPS/SSL listeners should use a predefined security policy that has strong configuration' as title,
  lb.account_id,
  lb.arn as resource_id,
  case when
    li.value:Listener:Protocol in ('HTTPS', 'SSL') and 'ELBSecurityPolicy-TLS-1-2-2017-01' NOT IN (po.value:OtherPolicies)
    then 'fail'
    else 'pass'
  end as status
from aws_elbv1_load_balancers lb, lateral flatten(input => parse_json(lb.listener_descriptions)) as li,
                                  lateral flatten(input => parse_json(lb.policies)) as po
"""

#ELB.9
ELBV1_HAVE_CROSS_ZONE_LOAD_BALANCING = """
insert into aws_policy_results
SELECT
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Classic Load Balancers should have cross-zone load balancing enabled' as title,
    account_id,
    arn as resource_id,
    case
        WHEN attributes:CrossZoneLoadBalancing:Enabled = 'true' THEN 'pass'
        ELSE 'fail'
    END as status
FROM
    aws_elbv1_load_balancers    
"""

#ELB.10
ELBV1_HAVE_MULTIPLE_AVAILABILITY_ZONES = """
insert into aws_policy_results
SELECT
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Classic Load Balancer should span multiple Availability Zones' as title,
    account_id,
    arn as resource_id,
    case
        WHEN array_size(availability_zones) > 1 THEN 'pass'
        ELSE 'fail'
    END as status
FROM
    aws_elbv1_load_balancers    
"""

#ELB.14
ELBV1_DESYNC_MIGRATION_MODE_DEFENSIVE_OR_STRICTEST = """
insert into aws_policy_results
SELECT
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Classic Load Balancer should be configured with defensive or strictest desync mitigation mode' as title,
    account_id,
    arn as resource_id,
    case
        WHEN aa.value:Value in ('defensive', 'strictest') THEN 'pass'
        ELSE 'fail'
    END as status
FROM
    aws_elbv1_load_balancers as lb,
    LATERAL FLATTEN(input => attributes:AdditionalAttributes) aa
WHERE
    aa.value:Key = 'elb.http.desyncmitigationmode'   
"""