{% macro no_broad_public_ipv6_ingress_on_port_22_3389(framework, check_id) %}
  {{ return(adapter.dispatch('no_broad_public_ipv6_ingress_on_port_22_3389')(framework, check_id)) }}
{% endmacro %}

{% macro default__no_broad_public_ipv6_ingress_on_port_22_3389(framework, check_id) %}{% endmacro %}

{% macro postgres__no_broad_public_ipv6_ingress_on_port_22_3389(framework, check_id) %}
-- uses view which uses aws_security_group_ingress_rules.sql query
select
  '{{framework}}',
  '{{check_id}}',
  'Ensure no security groups allow ingress from ::/0 to remote server administration ports (Automated)',
  account_id,
  arn,
  case when
      (ip = '::/0')
      and (
          (from_port is null and to_port is null) -- all ports
          or 22 between from_port and to_port
          or 3389 between from_port and to_port)
      then 'fail'
      else 'pass'
  end
from {{ ref('aws_compliance__security_group_ingress_rules') }}
{% endmacro %}

{% macro snowflake__no_broad_public_ipv6_ingress_on_port_22_3389(framework, check_id) %}
select
  '{{framework}}',
  '{{check_id}}',
  'Ensure no security groups allow ingress from ::/0 to remote server administration ports (Automated)',
  account_id,
  arn,
  case when
      (ip = '::/0')
      and (
          (from_port is null and to_port is null) -- all ports
          or 22 between from_port and to_port
          or 3389 between from_port and to_port)
      then 'fail'
      else 'pass'
  end
from {{ ref('aws_compliance__security_group_ingress_rules') }}
{% endmacro %}

{% macro bigquery__no_broad_public_ipv6_ingress_on_port_22_3389(framework, check_id) %}
select
  '{{framework}}',
  '{{check_id}}',
  'Ensure no security groups allow ingress from ::/0 to remote server administration ports (Automated)',
  account_id,
  arn,
  case when
      (ip = '::/0')
      and (
          (from_port is null and to_port is null) -- all ports
          or 22 between from_port and to_port
          or 3389 between from_port and to_port)
      then 'fail'
      else 'pass'
  end
from {{ ref('aws_compliance__security_group_ingress_rules') }}
{% endmacro %}
