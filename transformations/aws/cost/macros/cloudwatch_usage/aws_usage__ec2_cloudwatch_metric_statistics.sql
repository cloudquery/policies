{% macro ec2_cloudwatch_metric_statistics() %}
  {{ return(adapter.dispatch('ec2_cloudwatch_metric_statistics')()) }}
{% endmacro %}

{% macro default__ec2_cloudwatch_metric_statistics() %}{% endmacro %}
{% macro postgres__ec2_cloudwatch_metric_statistics() %}

select 
case when input_json -> 'Dimensions' -> 0 ->> 'Name' = 'InstanceId'
then input_json -> 'Dimensions' -> 0 ->> 'Value' 
else null end as instance_id,
unit,
label,
timestamp,
average,
maximum,
minimum
from aws_cloudwatch_metric_statistics
where input_json ->> 'Namespace' = 'AWS/EC2'