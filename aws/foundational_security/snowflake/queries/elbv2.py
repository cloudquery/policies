# ELB.1
ELBV2_REDIRECT_HTTP_TO_HTTPS = """
insert into aws_policy_results
select
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'Application Load Balancer should be configured to redirect all HTTP requests to HTTPS' as title,
  account_id,
  arn as resource_id,
  case when
   protocol = 'HTTP' and (da.value:Type != 'REDIRECT' or da.value:RedirectConfig:Protocol != 'HTTPS')
   then 'fail'
   else 'pass'
  end as status
from aws_elbv2_listeners, lateral flatten(input => parse_json(default_actions)) AS da
"""

#ELB.12
ELBV2_DESYNC_MIGRATION_MODE_DEFENSIVE_OR_STRICTEST = """
insert into aws_policy_results
select
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
'Application Load Balancer should be configured with defensive or strictest desync mitigation mode' as title,
  account_id,
  load_balancer_arn as resource_id,
  case
        WHEN value in ('defensive', 'strictest') THEN 'pass'
        ELSE 'fail'
  END as status
from aws_elbv2_load_balancer_attributes
where key = 'routing.http.desync_mitigation_mode'
"""

#ELB.13
ELBV2_HAVE_MULTIPLE_AVAILABILITY_ZONES = """
insert into aws_policy_results
SELECT
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Application, Network and Gateway Load Balancers should span multiple Availability Zones' as title,
    account_id,
    arn as resource_id,
    case
        WHEN array_size(availability_zones) > 1 THEN 'pass'
        ELSE 'fail'
    END as status
FROM
    aws_elbv2_load_balancers    
"""
