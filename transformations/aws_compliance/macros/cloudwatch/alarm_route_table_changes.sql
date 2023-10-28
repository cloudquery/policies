{% macro alarm_route_table_changes(framework, check_id) %}
  {{ return(adapter.dispatch('alarm_route_table_changes')(framework, check_id)) }}
{% endmacro %}

{% macro default__alarm_route_table_changes(framework, check_id) %}{% endmacro %}

{% macro postgres__alarm_route_table_changes(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure a log metric filter and alarm exist for route table changes (Scored)' as title,
  account_id,
  cloud_watch_logs_log_group_arn,
    case when  pattern NOT LIKE '%NOT%'
         AND pattern LIKE '%($.eventName = CreateRoute)%'
         AND pattern LIKE '%($.eventName = CreateRouteTable)%'
         AND pattern LIKE '%($.eventName = ReplaceRoute)%'
         AND pattern LIKE '%($.eventName = ReplaceRouteTableAssociation)%'
         AND pattern LIKE '%($.eventName = DeleteRouteTable)%'
         AND pattern LIKE '%($.eventName = DeleteRoute)%'
         AND pattern LIKE '%(($.eventName = DisassociateRouteTable)%' then 'pass'
        else 'fail'
    end as status
from aws_compliance__log_metric_filter_and_alarm
{% endmacro %}
