#autoscaling.1
AUTOSCALING_GROUP_ELB_HEALTHCHECK_REQUIRED = """
INSERT INTO aws_policy_results
SELECT
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'Auto Scaling groups associated with a Classic Load Balancer should use load balancer health checks' AS "title",
  account_id,
  arn AS resource_id,
  case
  when ARRAY_SIZE(load_balancer_names) = 0 and ARRAY_SIZE(target_group_arns) = 0 then 'fail'
  when health_check_type not like '%ELB%' then 'fail'
  else 'pass'
  END
    AS status
FROM
  aws_autoscaling_groups;
"""

#autoscaling.2
AUTOSCALING_MULTIPLE_AZ = """
INSERT INTO aws_policy_results
SELECT
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'Amazon EC2 Auto Scaling group should cover multiple Availability Zones' AS "title",
  account_id,
  arn AS resource_id,
  case
  when ARRAY_SIZE(availability_zones) > 1 then 'pass'
  else 'fail'
  END
    AS status
FROM
  aws_autoscaling_groups;
"""

#autoscaling.3
AUTOSCALING_LAUNCHCONFIG_REQUIRES_IMDSV2 = """
INSERT INTO aws_policy_results
SELECT
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'Auto Scaling group launch configurations should configure EC2 instances to require Instance Metadata Service Version 2' AS "title",
  account_id,
  arn AS resource_id,
  case
  when METADATA_OPTIONS:HttpTokens = 'required' then 'pass'
    else 'fail'
  END
    AS status
FROM
  aws_autoscaling_launch_configurations;
"""

#autoscaling.4
AUTOSCALING_LAUNCH_CONFIG_HOP_LIMIT = """
INSERT INTO aws_policy_results
SELECT
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'Auto Scaling group launch configuration should not have a metadata response hop limit greater than 1' AS "title",
  account_id,
  arn AS resource_id,
  case
  when METADATA_OPTIONS:HttpPutResponseHopLimit > 1 then 'fail'
    else 'pass'
  END
    AS status
FROM
  aws_autoscaling_launch_configurations;
"""

#autoscaling.5
AUTOSCALING_LAUNCH_CONFIG_PUBLIC_IP_DISABLED = """
INSERT INTO aws_policy_results
SELECT
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'Amazon EC2 instances launched using Auto Scaling group launch configurations should not have Public IP addresses' AS "title",
  account_id,
  arn AS resource_id,
  case
  when associate_public_ip_address = true then 'fail'
    else 'pass'
  END
    AS status
FROM
  aws_autoscaling_launch_configurations;
"""
#autoscaling.6
AUTOSCALING_MULTIPLE_INSTANCE_TYPES = """
INSERT INTO aws_policy_results
SELECT
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'Auto Scaling groups should use multiple instance types in multiple Availability Zones' AS "title",
  aag.account_id,
  ditc.arn AS resource_id,
  ditc.status
FROM aws_autoscaling_groups as aag
JOIN (
  SELECT
    arn,
    CASE
      WHEN COUNT(DISTINCT instance.value:InstanceType) > 1 THEN 'pass'
      ELSE 'fail'
    END AS status
  FROM
    aws_autoscaling_groups AS aag,
    LATERAL FLATTEN(input => aag.INSTANCES) instance
  GROUP BY arn
) AS ditc ON aag.arn = ditc.arn;
"""

#autoscaling.9
AUTOSCALING_LAUNCH_TEMPLATE = """
INSERT INTO aws_policy_results
SELECT
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'Amazon EC2 Auto Scaling groups should use Amazon EC2 launch templates' AS "title",
  account_id,
  arn AS resource_id,
  case
  when LAUNCH_TEMPLATE::String is null then 'fail'
    else 'pass'
  END
    AS status
FROM
  aws_autoscaling_groups;
"""