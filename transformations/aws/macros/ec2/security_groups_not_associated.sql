{% macro security_groups_not_associated(framework, check_id) %}
  {{ return(adapter.dispatch('security_groups_not_associated')(framework, check_id)) }}
{% endmacro %}

{% macro default__security_groups_not_associated(framework, check_id) %}{% endmacro %}

{% macro postgres__security_groups_not_associated(framework, check_id) %}
WITH used_security_groups AS (
    -- Security groups associated with EC2 instances
    SELECT sg ->> 'GroupId' as security_group_id
      FROM aws_ec2_instances,
			JSONB_ARRAY_ELEMENTS(security_groups) as sg 
    UNION
    -- Security groups associated with network interfaces
      SELECT sg ->> 'GroupId' as security_group_id
      FROM aws_ec2_network_interfaces,
		JSONB_ARRAY_ELEMENTS(groups) as sg 
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

{% macro snowflake__security_groups_not_associated(framework, check_id) %}
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

{% macro bigquery__security_groups_not_associated(framework, check_id) %}
WITH used_security_groups AS (
    -- Security groups associated with EC2 instances
    SELECT CAST(JSON_VALUE(sg.GroupId) AS STRING) as security_group_id
      FROM {{ full_table_name("aws_ec2_instances") }},
      UNNEST(JSON_QUERY_ARRAY(security_groups)) AS sg
    UNION ALL
    -- Security groups associated with network interfaces
      SELECT CAST(JSON_VALUE(sg.GroupId) AS STRING) as security_group_id
      FROM {{ full_table_name("aws_ec2_network_interfaces") }},
      UNNEST(JSON_QUERY_ARRAY(`groups`)) AS sg
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
FROM {{ full_table_name("aws_ec2_security_groups") }}
{% endmacro %}

{% macro athena__security_groups_not_associated(framework, check_id) %}
select * from (
WITH used_security_groups AS (
    -- Security groups associated with EC2 instances
    SELECT JSON_EXTRACT_SCALAR(sg, '$.GroupId') as security_group_id
    FROM aws_ec2_instances
    CROSS JOIN UNNEST(CAST(json_parse(security_groups) AS array(json))) AS t (sg)
    UNION
    -- Security groups associated with network interfaces
    SELECT JSON_EXTRACT_SCALAR(sg, '$.GroupId') as security_group_id
    FROM aws_ec2_network_interfaces
    CROSS JOIN UNNEST(CAST(json_parse(groups) AS array(json))) AS t (sg)
)
SELECT 
    '{{framework}}' AS framework,
    '{{check_id}}' AS check_id,
    'Unused Amazon EC2 security groups should be removed' AS title,
    account_id,
    arn AS resource_id,
    CASE
        WHEN group_id IN (SELECT DISTINCT security_group_id FROM used_security_groups) THEN 'pass'
        ELSE 'fail'
    END AS status
FROM aws_ec2_security_groups
)
{% endmacro %}
