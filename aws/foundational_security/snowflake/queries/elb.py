ELBV1_CERT_PROVIDED_BY_ACM = """
insert into aws_policy_results
select
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'Classic Load Balancers with SSL/HTTPS listeners should use a certificate provided by AWS Certificate Manager' as title,
  lb.account_id,
  lb.arn as resource_id,
  case when
    li.value:Listener:Protocol = 'HTTPS' and aws_acm_certificates.arn is null
    then 'fail'
    else 'pass'
  end as status
from aws_elbv1_load_balancers lb,
table(flatten(input => parse_json(lb.listener_descriptions), outer => TRUE)) as li
left join aws_acm_certificates on aws_acm_certificates.arn = li.value:Listener:SSLCertificateId
"""

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