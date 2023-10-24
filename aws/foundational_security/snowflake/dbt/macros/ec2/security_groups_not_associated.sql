{% macro security_groups_not_associated(framework, check_id) %}
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
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Unused Amazon EC2 security groups should be removed' as title,
   account_id,
   arn as resource_id,
CASE
when group_id IN (SELECT DISTINCT security_group_id FROM used_security_groups) THEN 'pass'
ELSE 'fail'
END as status
FROM aws_ec2_security_groups
{% endmacro %}