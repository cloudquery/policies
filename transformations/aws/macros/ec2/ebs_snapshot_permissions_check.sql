{% macro ebs_snapshot_permissions_check(framework, check_id) %}
  {{ return(adapter.dispatch('ebs_snapshot_permissions_check')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__ebs_snapshot_permissions_check(framework, check_id) %}
wITH snapshot_access_groups AS (
    SELECT account_id,
           region,
           snapshot_id,
           create_volume_permissions.value:Group AS "group",
           create_volume_permissions.value:UserId AS user_id
    FROM aws_ec2_ebs_snapshot_attributes, lateral flatten(input => parse_json(aws_ec2_ebs_snapshot_attributes.create_volume_permissions)) as create_volume_permissions
)
SELECT DISTINCT
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Amazon EBS snapshots should not be public, determined by the ability to be restorable by anyone' as title,
  account_id,
  snapshot_id as resource_id,
  case when
    "group" = 'all'
    then 'fail'
    else 'pass'
  end as status
FROM snapshot_access_groups
{% endmacro %}

{% macro postgres__ebs_snapshot_permissions_check(framework, check_id) %}
WITH snapshot_access_groups AS (
    SELECT account_id,
           region,
           snapshot_id,
           JSONB_ARRAY_ELEMENTS(create_volume_permissions) ->> 'Group' AS "group",
           JSONB_ARRAY_ELEMENTS(create_volume_permissions) ->> 'UserId' AS user_id
    FROM aws_ec2_ebs_snapshot_attributes
)
SELECT DISTINCT
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Amazon EBS snapshots should not be public, determined by the ability to be restorable by anyone' as title,
  account_id,
  snapshot_id as resource_id,
  case when
    "group" = 'all'
    then 'fail'
    else 'pass'
  end as status
FROM snapshot_access_groups
{% endmacro %}

{% macro default__ebs_snapshot_permissions_check(framework, check_id) %}{% endmacro %}
{% macro bigquery__ebs_snapshot_permissions_check(framework, check_id) %}
WITH snapshot_access_groups AS (
    SELECT account_id,
           region,
           snapshot_id,
           groupa,
           user_id
    FROM {{ full_table_name("aws_ec2_ebs_snapshot_attributes") }},
    UNNEST(JSON_QUERY_ARRAY(create_volume_permissions.Group)) AS groupa,
    UNNEST(JSON_QUERY_ARRAY(create_volume_permissions.UserId)) AS user_id
)
SELECT DISTINCT
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Amazon EBS snapshots should not be public, determined by the ability to be restorable by anyone' as title,
  account_id,
  snapshot_id as resource_id,
  case when
    JSON_VALUE(groupa) = 'all'
    then 'fail'
    else 'pass'
  end as status
FROM snapshot_access_groups
{% endmacro %}                    

{% macro athena__ebs_snapshot_permissions_check(framework, check_id) %}
select * from (
WITH snapshot_access_groups AS (
    SELECT account_id,
           region,
           snapshot_id,
           json_extract_scalar(create_volume_permission, '$.Group') AS "group",
           json_extract_scalar(create_volume_permission, '$.UserId') AS user_id
    FROM aws_ec2_ebs_snapshot_attributes
    CROSS JOIN UNNEST(cast(json_parse(create_volume_permissions) as array(json))) AS t (create_volume_permission)
)
SELECT DISTINCT
    '{{framework}}' AS framework,
    '{{check_id}}' AS check_id,
    'Amazon EBS snapshots should not be public, determined by the ability to be restorable by anyone' AS title,
    account_id,
    snapshot_id AS resource_id,
    CASE WHEN
        "group" = 'all'
    THEN 'fail'
    ELSE 'pass'
    END AS status
FROM snapshot_access_groups
)
{% endmacro %}  