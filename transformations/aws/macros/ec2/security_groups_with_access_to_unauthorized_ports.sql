{% macro security_groups_with_access_to_unauthorized_ports(framework, check_id) %}
  {{ return(adapter.dispatch('security_groups_with_access_to_unauthorized_ports')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__security_groups_with_access_to_unauthorized_ports(framework, check_id) %}
-- uses view which uses aws_security_group_ingress_rules.sql query

SELECT
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Aggregates rules of security groups with ports and IPs including ipv6' as title,
  account_id,
  arn as resource_id,
  CASE
    WHEN ip_protocol != 'tcp' THEN 'fail' -- No parameterised allowlist in place at the moment.
    WHEN ip IN ('0.0.0.0/0') OR ip6 IN ('::/0') THEN
      CASE
        WHEN from_port::TEXT IS NULL THEN 'fail' -- Unrestricted traffic
        WHEN to_port::TEXT IS NULL THEN 'fail' -- Unrestricted traffic
        WHEN TRIM(from_port::TEXT) IN ('80', '80,443', '443,80', '443') AND TRIM(to_port::TEXT) IN ('80', '80,443', '443,80', '443') THEN 'pass' -- Authorized ports
        ELSE 'fail' -- Any other port; no parameterised allowlist in place at the moment.
      END
    ELSE 'pass' -- "NOT_APPLICABLE" per https://docs.aws.amazon.com/config/latest/developerguide/vpc-sg-open-only-to-authorized-ports.html
  END AS status
FROM {{ref('aws_compliance__security_group_ingress_rules')}}
{% endmacro %}

{% macro postgres__security_groups_with_access_to_unauthorized_ports(framework, check_id) %}
-- uses view which uses aws_security_group_ingress_rules.sql query
WITH IndividualRuleStatus AS (
  SELECT
    account_id,
    arn as resource_id,
    CASE
      WHEN ip_protocol != 'tcp' THEN 'fail' -- No parameterised allowlist in place at the moment.
      WHEN ip IN ('0.0.0.0/0') OR ip6 IN ('::/0') THEN
      CASE
        WHEN from_port::TEXT IS NULL THEN 'fail' -- Unrestricted traffic
        WHEN to_port::TEXT IS NULL THEN 'fail' -- Unrestricted traffic
        WHEN TRIM(from_port::TEXT) IN ('80', '80,443', '443,80', '443') AND TRIM(to_port::TEXT) IN ('80', '80,443', '443,80', '443') THEN 'pass' -- Authorized ports
        ELSE 'fail' -- Any other port; no parameterised allowlist in place at the moment.
      END
      ELSE 'pass' -- "NOT_APPLICABLE" per https://docs.aws.amazon.com/config/latest/developerguide/vpc-sg-open-only-to-authorized-ports.html
    END AS status
  FROM {{ ref('aws_compliance__security_group_ingress_rules') }}
)

SELECT
	'{{framework}}' as framework,
	'{{check_id}}' as check_id,
	'Aggregates rules of security groups with ports and IPs including ipv6' as title,	
    account_id,
    resource_id,
    CASE
      WHEN SUM(CASE WHEN status = 'fail' THEN 1 ELSE 0 END) > 0 THEN 'fail'
      ELSE 'pass'
    END as status
  FROM IndividualRuleStatus
  GROUP BY account_id, resource_id

{% endmacro %}

{% macro default__security_groups_with_access_to_unauthorized_ports(framework, check_id) %}{% endmacro %}

{% macro bigquery__security_groups_with_access_to_unauthorized_ports(framework, check_id) %}
-- uses view which uses aws_security_group_ingress_rules.sql query

SELECT
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Aggregates rules of security groups with ports and IPs including ipv6' as title,
  account_id,
  arn as resource_id,
  CASE
    WHEN ip_protocol != 'tcp' THEN 'fail' -- No parameterised allowlist in place at the moment.
    WHEN ip IN ('0.0.0.0/0') OR ip6 IN ('::/0') THEN
      CASE
        WHEN CAST(from_port AS STRING) IS NULL THEN 'fail' -- Unrestricted traffic
        WHEN CAST(to_port AS STRING) IS NULL THEN 'fail' -- Unrestricted traffic
        WHEN TRIM(CAST(from_port AS STRING)) IN ('80', '80,443', '443,80', '443') AND TRIM(CAST(to_port AS STRING)) IN ('80', '80,443', '443,80', '443') THEN 'pass' -- Authorized ports
        ELSE 'fail' -- Any other port; no parameterised allowlist in place at the moment.
      END
      ELSE 'pass' -- "NOT_APPLICABLE" per https://docs.aws.amazon.com/config/latest/developerguide/vpc-sg-open-only-to-authorized-ports.html
    END AS status
FROM {{ref('aws_compliance__security_group_ingress_rules')}}
{% endmacro %}

{% macro athena__security_groups_with_access_to_unauthorized_ports(framework, check_id) %}
-- Assuming aws_compliance__security_group_ingress_rules view is available with the necessary fields
select * from (
WITH IndividualRuleStatus AS (
  SELECT
    account_id,
    arn as resource_id,
    CASE
      WHEN ip_protocol != 'tcp' THEN 'fail' -- No parameterised allowlist in place at the moment.
      WHEN ip IN ('0.0.0.0/0') OR ip6 IN ('::/0') THEN
        CASE
            WHEN CAST(from_port AS VARCHAR) IS NULL THEN 'fail' -- Unrestricted traffic
            WHEN CAST(to_port AS VARCHAR) IS NULL THEN 'fail' -- Unrestricted traffic
            WHEN TRIM(CAST(from_port AS VARCHAR)) IN ('80', '80,443', '443,80', '443') AND TRIM(CAST(to_port AS VARCHAR)) IN ('80', '80,443', '443,80', '443') THEN 'pass' -- Authorized ports
          ELSE 'fail' -- Any other port; no parameterised allowlist in place at the moment.
        END
      ELSE 'pass' -- "NOT_APPLICABLE" per https://docs.aws.amazon.com/config/latest/developerguide/vpc-sg-open-only-to-authorized-ports.html
    END AS status
  FROM {{ref('aws_compliance__security_group_ingress_rules')}}
)

SELECT
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Aggregates rules of security groups with ports and IPs including ipv6' as title,    
    account_id,
    resource_id,
    CASE
      WHEN SUM(CASE WHEN status = 'fail' THEN 1 ELSE 0 END) > 0 THEN 'fail'
      ELSE 'pass'
    END as status
  FROM IndividualRuleStatus
  GROUP BY account_id, resource_id
)
{% endmacro %}
