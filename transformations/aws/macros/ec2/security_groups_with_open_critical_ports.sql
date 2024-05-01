{% macro security_groups_with_open_critical_ports(framework, check_id) %}
  {{ return(adapter.dispatch('security_groups_with_open_critical_ports')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__security_groups_with_open_critical_ports(framework, check_id) %}
-- uses view which uses aws_security_group_ingress_rules.sql query

select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Security groups should not allow unrestricted access to ports with high risk' as title,
    account_id,
    id as resource_id,
    case when
        (ip = '0.0.0.0/0' or ip = '::/0')
        and ((from_port is null and to_port is null) -- all ports
        or 20 between from_port and to_port
        or 21 between from_port and to_port
        or 22 between from_port and to_port
        or 23 between from_port and to_port
        or 25 between from_port and to_port
        or 110 between from_port and to_port
        or 135 between from_port and to_port
        or 143 between from_port and to_port
        or 445 between from_port and to_port
        or 1433 between from_port and to_port
        or 1434 between from_port and to_port
        or 3000 between from_port and to_port
        or 3306 between from_port and to_port
        or 3389 between from_port and to_port
        or 4333 between from_port and to_port
        or 5000 between from_port and to_port
        or 5432 between from_port and to_port
        or 5500 between from_port and to_port
        or 5601 between from_port and to_port
        or 8080 between from_port and to_port
        or 8088 between from_port and to_port
        or 8888 between from_port and to_port
        or 9200 between from_port and to_port
        or 9300 between from_port and to_port)
        then 'fail'
        else 'pass'
    end
FROM {{ref('aws_compliance__security_group_ingress_rules')}}
{% endmacro %}

{% macro postgres__security_groups_with_open_critical_ports(framework, check_id) %}
-- uses view which uses aws_security_group_ingress_rules.sql query
WITH IndividualRuleStatus AS (
  SELECT
      account_id,
    id as resource_id,
     case when
        (ip = '0.0.0.0/0' or ip = '::/0')
        and ((from_port is null and to_port is null) -- all ports
        or 20 between from_port and to_port
        or 21 between from_port and to_port
        or 22 between from_port and to_port
        or 23 between from_port and to_port
        or 25 between from_port and to_port
        or 110 between from_port and to_port
        or 135 between from_port and to_port
        or 143 between from_port and to_port
        or 445 between from_port and to_port
        or 1433 between from_port and to_port
        or 1434 between from_port and to_port
        or 3000 between from_port and to_port
        or 3306 between from_port and to_port
        or 3389 between from_port and to_port
        or 4333 between from_port and to_port
        or 5000 between from_port and to_port
        or 5432 between from_port and to_port
        or 5500 between from_port and to_port
        or 5601 between from_port and to_port
        or 8080 between from_port and to_port
        or 8088 between from_port and to_port
        or 8888 between from_port and to_port
        or 9200 between from_port and to_port
        or 9300 between from_port and to_port)
        then 'fail'
        else 'pass'
    end as status
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
  GROUP BY account_id, resource_id{% endmacro %}

{% macro default__security_groups_with_open_critical_ports(framework, check_id) %}{% endmacro %}

{% macro bigquery__security_groups_with_open_critical_ports(framework, check_id) %}
-- uses view which uses aws_security_group_ingress_rules.sql query

select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Security groups should not allow unrestricted access to ports with high risk' as title,
    account_id,
    id as resource_id,
    case when
        (ip = '0.0.0.0/0' or ip = '::/0')
        and ((from_port is null and to_port is null) -- all ports
        or 20 between from_port and to_port
        or 21 between from_port and to_port
        or 22 between from_port and to_port
        or 23 between from_port and to_port
        or 25 between from_port and to_port
        or 110 between from_port and to_port
        or 135 between from_port and to_port
        or 143 between from_port and to_port
        or 445 between from_port and to_port
        or 1433 between from_port and to_port
        or 1434 between from_port and to_port
        or 3000 between from_port and to_port
        or 3306 between from_port and to_port
        or 3389 between from_port and to_port
        or 4333 between from_port and to_port
        or 5000 between from_port and to_port
        or 5432 between from_port and to_port
        or 5500 between from_port and to_port
        or 5601 between from_port and to_port
        or 8080 between from_port and to_port
        or 8088 between from_port and to_port
        or 8888 between from_port and to_port
        or 9200 between from_port and to_port
        or 9300 between from_port and to_port)
        then 'fail'
        else 'pass'
    end
FROM {{ref('aws_compliance__security_group_ingress_rules')}}
{% endmacro %}

{% macro athena__security_groups_with_open_critical_ports(framework, check_id) %}
-- Assumes aws_compliance__security_group_ingress_rules view or equivalent is set up in Athena
WITH CriticalPortStatus AS (
  SELECT
      account_id,
      id as resource_id,
      case when
        (ip = '0.0.0.0/0' or ip = '::/0') and
        ((from_port IS NULL and to_port IS NULL) -- implies all ports
        or (20 BETWEEN from_port and to_port)
        or (21 BETWEEN from_port and to_port)
        or (22 BETWEEN from_port and to_port)
        or (23 BETWEEN from_port and to_port)
        or (25 BETWEEN from_port and to_port)
        or (110 BETWEEN from_port and to_port)
        or (135 BETWEEN from_port and to_port)
        or (143 BETWEEN from_port and to_port)
        or (445 BETWEEN from_port and to_port)
        or (1433 BETWEEN from_port and to_port)
        or (1434 BETWEEN from_port and to_port)
        or (3000 BETWEEN from_port and to_port)
        or (3306 BETWEEN from_port and to_port)
        or (3389 BETWEEN from_port and to_port)
        or (4333 BETWEEN from_port and to_port)
        or (5000 BETWEEN from_port and to_port)
        or (5432 BETWEEN from_port and to_port)
        or (5500 BETWEEN from_port and to_port)
        or (5601 BETWEEN from_port and to_port)
        or (8080 BETWEEN from_port and to_port)
        or (8088 BETWEEN from_port and to_port)
        or (8888 BETWEEN from_port and to_port)
        or (9200 BETWEEN from_port and to_port)
        or (9300 BETWEEN from_port and to_port))
        then 'fail'
        else 'pass'
      end as status
  FROM {{ref('aws_compliance__security_group_ingress_rules')}}
)

SELECT
    '{{framework}}' AS framework,
    '{{check_id}}' AS check_id,
    'Security groups should not allow unrestricted access to ports with high risk' AS title,
    account_id,
    resource_id,
    CASE
      WHEN SUM(CASE WHEN status = 'fail' THEN 1 ELSE 0 END) > 0 THEN 'fail'
      ELSE 'pass'
    END AS status
  FROM CriticalPortStatus
  GROUP BY account_id, resource_id
{% endmacro %}
