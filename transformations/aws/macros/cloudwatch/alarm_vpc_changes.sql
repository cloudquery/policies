{% macro alarm_vpc_changes(framework, check_id) %}
  {{ return(adapter.dispatch('alarm_vpc_changes')(framework, check_id)) }}
{% endmacro %}

{% macro default__alarm_vpc_changes(framework, check_id) %}{% endmacro %}

{% macro postgres__alarm_vpc_changes(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure a log metric filter and alarm exist for VPC changes (Scored)' as title,
  account_id,
  cloud_watch_logs_log_group_arn as resource_id,
  case when pattern NOT LIKE '%NOT%'
           AND pattern LIKE '%($.eventName = CreateVpc)%'
           AND pattern LIKE '%($.eventName = DeleteVpc)%'
           AND pattern LIKE '%($.eventName = ModifyVpcAttribute)%'
           AND pattern LIKE '%($.eventName = AcceptVpcPeeringConnection)%'
           AND pattern LIKE '%($.eventName = CreateVpcPeeringConnection)%'
           AND pattern LIKE '%($.eventName = DeleteVpcPeeringConnection)%'
           AND pattern LIKE '%($.eventName = RejectVpcPeeringConnection)%'
           AND pattern LIKE '%($.eventName = AttachClassicLinkVpc)%'
           AND pattern LIKE '%($.eventName = DetachClassicLinkVpc)%'
           AND pattern LIKE '%($.eventName = DisableVpcClassicLink)%'
           AND pattern LIKE '%($.eventName = EnableVpcClassicLink)%'
      then 'pass'
      else 'fail'
  end as status
from {{ ref('aws_compliance__log_metric_filter_and_alarm') }}
{% endmacro %}

{% macro postgres__bigquery(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure a log metric filter and alarm exist for VPC changes (Scored)' as title,
  account_id,
  cloud_watch_logs_log_group_arn as resource_id,
  case when pattern NOT LIKE '%NOT%'
           AND pattern LIKE '%($.eventName = CreateVpc)%'
           AND pattern LIKE '%($.eventName = DeleteVpc)%'
           AND pattern LIKE '%($.eventName = ModifyVpcAttribute)%'
           AND pattern LIKE '%($.eventName = AcceptVpcPeeringConnection)%'
           AND pattern LIKE '%($.eventName = CreateVpcPeeringConnection)%'
           AND pattern LIKE '%($.eventName = DeleteVpcPeeringConnection)%'
           AND pattern LIKE '%($.eventName = RejectVpcPeeringConnection)%'
           AND pattern LIKE '%($.eventName = AttachClassicLinkVpc)%'
           AND pattern LIKE '%($.eventName = DetachClassicLinkVpc)%'
           AND pattern LIKE '%($.eventName = DisableVpcClassicLink)%'
           AND pattern LIKE '%($.eventName = EnableVpcClassicLink)%'
      then 'pass'
      else 'fail'
  end as status
from {{ ref('aws_compliance__log_metric_filter_and_alarm') }}
{% endmacro %}
