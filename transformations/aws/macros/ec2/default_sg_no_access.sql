{% macro default_sg_no_access(framework, check_id) %}
  {{ return(adapter.dispatch('default_sg_no_access')(framework, check_id)) }}
{% endmacro %}

{% macro default__default_sg_no_access(framework, check_id) %}{% endmacro %}

{% macro snowflake__default_sg_no_access(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'The VPC default security group should not allow inbound and outbound traffic' AS title,
  account_id,
  arn,
  case when
      group_name='default'
          AND (
          array_size(parse_json(ip_permissions)) = 0
              OR (
              array_size(parse_json(ip_permissions)) = 1
                  AND parse_json(ip_permissions[0]):FromPort IS NULL
                  AND parse_json(ip_permissions[0]):ToPort IS NULL
                  AND parse_json(ip_permissions[0]):IpProtocol = '-1'
                  AND array_size(parse_json(ip_permissions[0]):IpRanges) = 0
                  AND array_size(parse_json(ip_permissions[0]):Ipv6Ranges) = 0
                  AND array_size(parse_json(ip_permissions[0]):PrefixListIds) = 0
                  AND array_size(parse_json(ip_permissions[0]):UserIdGroupPairs) = 1
                  AND parse_json(ip_permissions[0]):UserIdGroupPairs[0]:GroupName IS NULL
              )
          )
          AND (
          array_size(parse_json(ip_permissions_egress)) = 0
              OR (
              array_size(parse_json(ip_permissions_egress)) = 1
                  AND parse_json(ip_permissions_egress[0]):FromPort IS NULL
                  AND parse_json(ip_permissions_egress[0]):ToPort IS NULL
                  AND array_size(parse_json(ip_permissions_egress[0]):IpRanges) = 1
                  AND parse_json(ip_permissions_egress[0]):IpRanges[0]:CidrIp = '0.0.0.0/0'
                  AND parse_json(ip_permissions_egress[0]):IpRanges[0]:Description IS NULL
                  AND array_size(parse_json(ip_permissions_egress[0]):Ipv6Ranges) = 0
                  AND array_size(parse_json(ip_permissions_egress[0]):PrefixListIds) = 0
                  AND array_size(parse_json(ip_permissions_egress[0]):UserIdGroupPairs) = 0
              )
          )
      then 'pass'
      else 'fail'
  end
FROM
    aws_ec2_security_groups
{% endmacro %}

{% macro postgres__default_sg_no_access(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'The VPC default security group should not allow inbound and outbound traffic' as title,
  account_id,
  arn,
  case when
    group_name='default'
    AND (
    jsonb_array_length(ip_permissions) = 0
        OR (
        jsonb_array_length(ip_permissions) = 1
            AND (ip_permissions->0->>'FromPort')::int IS NULL
            AND (ip_permissions->0->>'ToPort')::int IS NULL
            AND (ip_permissions->0->>'IpProtocol') = '-1'
            AND jsonb_array_length(ip_permissions->0->'IpRanges') = 0
            AND jsonb_array_length(ip_permissions->0->'Ipv6Ranges') = 0
            AND jsonb_array_length(ip_permissions->0->'PrefixListIds') = 0
            AND jsonb_array_length(ip_permissions->0->'UserIdGroupPairs') = 1
            AND (ip_permissions->0->'UserIdGroupPairs'->0->>'GroupName') IS NULL
        )
    )
    AND (
    jsonb_array_length(ip_permissions_egress) = 0
        OR (
        jsonb_array_length(ip_permissions_egress) = 1
            AND (ip_permissions_egress->0->>'FromPort')::int IS NULL
            AND (ip_permissions_egress->0->>'ToPort')::int IS NULL
            AND (ip_permissions_egress->0->>'IpProtocol') = '-1'
            AND jsonb_array_length(ip_permissions_egress->0->'IpRanges') = 1
            AND (ip_permissions_egress->0->'IpRanges'->0->>'CidrIp') = '0.0.0.0/0'
            AND (ip_permissions_egress->0->'IpRanges'->0->>'Description') IS NULL
            AND jsonb_array_length(ip_permissions_egress->0->'Ipv6Ranges') = 0
            AND jsonb_array_length(ip_permissions_egress->0->'PrefixListIds') = 0
            AND jsonb_array_length(ip_permissions_egress->0->'UserIdGroupPairs') = 0
        )
    )
    then 'pass'
   else 'fail'
  end as status
from
    aws_ec2_security_groups
{% endmacro %}

{% macro bigquery__default_sg_no_access(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'The VPC default security group should not allow inbound and outbound traffic' as title,
  account_id,
  arn,
  CASE
    WHEN group_name = 'default'
      AND (
        ARRAY_LENGTH(JSON_EXTRACT_ARRAY(ip_permissions)) = 0
          OR (
          ARRAY_LENGTH(JSON_EXTRACT_ARRAY(ip_permissions)) = 1
            AND JSON_EXTRACT_SCALAR(JSON_EXTRACT_ARRAY(ip_permissions)[OFFSET(0)], '$.FromPort') IS NULL
            AND JSON_EXTRACT_SCALAR(JSON_EXTRACT_ARRAY(ip_permissions)[OFFSET(0)], '$.ToPort') IS NULL
            AND JSON_EXTRACT_SCALAR(JSON_EXTRACT_ARRAY(ip_permissions)[OFFSET(0)], '$.IpProtocol') = '-1'
            AND ARRAY_LENGTH(JSON_EXTRACT_ARRAY(JSON_EXTRACT_ARRAY(ip_permissions)[OFFSET(0)], '$.IpRanges')) = 0
            AND ARRAY_LENGTH(JSON_EXTRACT_ARRAY(JSON_EXTRACT_ARRAY(ip_permissions)[OFFSET(0)], '$.Ipv6Ranges')) = 0
            AND ARRAY_LENGTH(JSON_EXTRACT_ARRAY(JSON_EXTRACT_ARRAY(ip_permissions)[OFFSET(0)], '$.PrefixListIds')) = 0
            AND ARRAY_LENGTH(JSON_EXTRACT_ARRAY(JSON_EXTRACT_ARRAY(ip_permissions)[OFFSET(0)], '$.UserIdGroupPairs')) = 1
            AND JSON_EXTRACT_SCALAR(JSON_EXTRACT_ARRAY(JSON_EXTRACT_ARRAY(ip_permissions)[OFFSET(0)], '$.UserIdGroupPairs')[OFFSET(0)], '$.GroupName') IS NULL
          )
        )
      AND (
        ARRAY_LENGTH(JSON_EXTRACT_ARRAY(ip_permissions_egress)) = 0
          OR (
          ARRAY_LENGTH(JSON_EXTRACT_ARRAY(ip_permissions_egress)) = 1
            AND JSON_EXTRACT_SCALAR(JSON_EXTRACT_ARRAY(ip_permissions_egress)[OFFSET(0)], '$.FromPort') IS NULL
            AND JSON_EXTRACT_SCALAR(JSON_EXTRACT_ARRAY(ip_permissions_egress)[OFFSET(0)], '$.ToPort') IS NULL
            AND JSON_EXTRACT_SCALAR(JSON_EXTRACT_ARRAY(ip_permissions_egress)[OFFSET(0)], '$.IpProtocol') = '-1'
            AND ARRAY_LENGTH(JSON_EXTRACT_ARRAY(JSON_EXTRACT_ARRAY(ip_permissions_egress)[OFFSET(0)], '$.IpRanges')) = 1
            AND JSON_EXTRACT_SCALAR(JSON_EXTRACT_ARRAY(JSON_EXTRACT_ARRAY(ip_permissions_egress)[OFFSET(0)], '$.IpRanges')[OFFSET(0)], '$.CidrIp') = '0.0.0.0/0'
            AND JSON_EXTRACT_SCALAR(JSON_EXTRACT_ARRAY(JSON_EXTRACT_ARRAY(ip_permissions_egress)[OFFSET(0)], '$.IpRanges')[OFFSET(0)], '$.Description') IS NULL
            AND ARRAY_LENGTH(JSON_EXTRACT_ARRAY(JSON_EXTRACT_ARRAY(ip_permissions_egress)[OFFSET(0)], '$.Ipv6Ranges')) = 0
            AND ARRAY_LENGTH(JSON_EXTRACT_ARRAY(JSON_EXTRACT_ARRAY(ip_permissions_egress)[OFFSET(0)], '$.PrefixListIds')) = 0
            AND ARRAY_LENGTH(JSON_EXTRACT_ARRAY(JSON_EXTRACT_ARRAY(ip_permissions_egress)[OFFSET(0)], '$.UserIdGroupPairs')) = 0
          )
        )
      THEN 'pass'
    ELSE 'fail'
  END AS status
from
    {{ full_table_name("aws_ec2_security_groups") }}
{% endmacro %}

{% macro athena__default_sg_no_access(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'The VPC default security group should not allow inbound and outbound traffic' AS title,
  account_id,
  arn,
  case when
      group_name='default'
      and
      json_array_length(json_parse(ip_permissions)) > 0
      or
      json_array_length(json_parse(ip_permissions_egress)) > 0
      then 'fail'
      else 'pass'
  end
FROM
    aws_ec2_security_groups
{% endmacro %}