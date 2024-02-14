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