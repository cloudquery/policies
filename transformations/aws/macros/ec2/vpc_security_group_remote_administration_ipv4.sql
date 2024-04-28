{% macro vpc_security_group_remote_administration_ipv4(framework, check_id) %}
  {{ return(adapter.dispatch('vpc_security_group_remote_administration_ipv4')(framework, check_id)) }}
{% endmacro %}

{% macro default__vpc_security_group_remote_administration_ipv4(framework, check_id) %}{% endmacro %}

{% macro postgres__vpc_security_group_remote_administration_ipv4(framework, check_id) %}
select
  '{{framework}}',
  '{{check_id}}',
  'Ensure no security groups allow ingress from 0.0.0.0/0 to remote server administration ports (Automated)' AS title,
  account_id,
  arn,
  case when
      (ip = '0.0.0.0/0')
      and (
          (
            (from_port is null and to_port is null) -- all ports
            or 22 between from_port and to_port
            or 3389 between from_port and to_port
          )
          and
          (
            ip_protocol in ('6','17','-1','TCP','UDP','ALL') 
          )
          )
      then 'fail'
      else 'pass'
  end
from {{ ref('aws_compliance__security_group_ingress_rules') }}
{% endmacro %}

{% macro snowflake__vpc_security_group_remote_administration_ipv4(framework, check_id) %}
select
  '{{framework}}',
  '{{check_id}}',
  'Ensure no security groups allow ingress from 0.0.0.0/0 to remote server administration ports (Automated)' AS title,
  account_id,
  arn,
  case when
      (ip = '0.0.0.0/0')
      and (
          (
            (from_port is null and to_port is null) -- all ports
            or 22 between from_port and to_port
            or 3389 between from_port and to_port
          )
          and
          (
            ip_protocol in ('6','17','-1','TCP','UDP','ALL') 
          )
          )
      then 'fail'
      else 'pass'
  end
from {{ ref('aws_compliance__security_group_ingress_rules') }}
{% endmacro %}

{% macro bigquery__vpc_security_group_remote_administration_ipv4(framework, check_id) %}
select
  '{{framework}}',
  '{{check_id}}',
  'Ensure no security groups allow ingress from 0.0.0.0/0 to remote server administration ports (Automated)' AS title,
  account_id,
  arn,
  case when
      (ip = '0.0.0.0/0')
      and (
          (
            (from_port is null and to_port is null) -- all ports
            or 22 between from_port and to_port
            or 3389 between from_port and to_port
          )
          and
          (
            ip_protocol in ('6','17','-1','TCP','UDP','ALL') 
          )
          )
      then 'fail'
      else 'pass'
  end
from {{ ref('aws_compliance__security_group_ingress_rules') }}
{% endmacro %}

{% macro athena__vpc_security_group_remote_administration_ipv4(framework, check_id) %}
select
  '{{framework}}',
  '{{check_id}}',
  'Ensure no security groups allow ingress from 0.0.0.0/0 to remote server administration ports (Automated)' AS title,
  account_id,
  arn,
  case when
      (ip = '0.0.0.0/0')
      and (
          (
            (from_port is null and to_port is null) -- all ports
            or 22 between from_port and to_port
            or 3389 between from_port and to_port
          )
          and
          (
            ip_protocol in ('6','17','-1','TCP','UDP','ALL') 
          )
          )
      then 'fail'
      else 'pass'
  end
from {{ ref('aws_compliance__security_group_ingress_rules') }}
{% endmacro %}