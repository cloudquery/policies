{% macro vpc_network_acl_remote_administration(framework, check_id) %}
  {{ return(adapter.dispatch('vpc_network_acl_remote_administration')(framework, check_id)) }}
{% endmacro %}

{% macro default__vpc_network_acl_remote_administration(framework, check_id) %}{% endmacro %}

{% macro postgres__vpc_network_acl_remote_administration(framework, check_id) %}
select
  '{{framework}}',
  '{{check_id}}',
  'Ensure no Network ACLs allow ingress from 0.0.0.0/0 to remote server administration ports (Automated)' AS title,
  account_id,
  arn,
  case when
      (cidr_block = '0.0.0.0/0')
      and (
          (
            (port_range_from is null and port_range_to is null) -- all ports
            or 22 between port_range_from and port_range_to
            or 3389 between port_range_from and port_range_to
          )
          and
          (
            protocol in ('6','17','-1','TCP','UDP','ALL') 
          )
          )
      then 'fail'
      else 'pass'
  end
from {{ ref('aws_compliance__networks_acls_ingress_rules') }}
{% endmacro %}

{% macro snowflake__vpc_network_acl_remote_administration(framework, check_id) %}
select
  '{{framework}}',
  '{{check_id}}',
  'Ensure no Network ACLs allow ingress from 0.0.0.0/0 to remote server administration ports (Automated)' AS title,
  account_id,
  arn,
  case when
      (cidr_block = '0.0.0.0/0')
      and (
          (
            (port_range_from is null and port_range_to is null) -- all ports
            or 22 between port_range_from and port_range_to
            or 3389 between port_range_from and port_range_to
          )
          and
          (
            protocol in ('6','17','-1','TCP','UDP','ALL') 
          )
          )
      then 'fail'
      else 'pass'
  end as status
from {{ ref('aws_compliance__networks_acls_ingress_rules') }}
{% endmacro %}

{% macro bigquery__vpc_network_acl_remote_administration(framework, check_id) %}
select
  '{{framework}}',
  '{{check_id}}',
  'Ensure no Network ACLs allow ingress from 0.0.0.0/0 to remote server administration ports (Automated)' AS title,
  account_id,
  arn,
  case when
      (cidr_block = '0.0.0.0/0')
      and (
          (
            (port_range_from is null and port_range_to is null) -- all ports
            or 22 between port_range_from and port_range_to
            or 3389 between port_range_from and port_range_to
          )
          and
          (
            protocol in ('6','17','-1','TCP','UDP','ALL') 
          )
          )
      then 'fail'
      else 'pass'
  end
from {{ ref('aws_compliance__networks_acls_ingress_rules') }}
{% endmacro %}

{% macro athena__vpc_network_acl_remote_administration(framework, check_id) %}
select
  '{{framework}}',
  '{{check_id}}',
  'Ensure no Network ACLs allow ingress from 0.0.0.0/0 to remote server administration ports (Automated)' AS title,
  account_id,
  arn,
  case when
      (cidr_block = '0.0.0.0/0')
      and (
          (
            (port_range_from is null and port_range_to is null) -- all ports
            or 22 between port_range_from and port_range_to
            or 3389 between port_range_from and port_range_to
          )
          and
          (
            protocol in ('6','17','-1','TCP','UDP','ALL') 
          )
          )
      then 'fail'
      else 'pass'
  end as status
from {{ ref('aws_compliance__networks_acls_ingress_rules') }}
{% endmacro %}