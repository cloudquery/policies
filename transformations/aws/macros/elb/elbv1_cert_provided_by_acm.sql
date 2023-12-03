{% macro elbv1_cert_provided_by_acm(framework, check_id) %}
  {{ return(adapter.dispatch('elbv1_cert_provided_by_acm')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__elbv1_cert_provided_by_acm(framework, check_id) %}
with listeners as (
  select
      lb.account_id as account_id,
      lb.arn as resource_id,
      li.value:Listener:Protocol as protocol,
      li.value:Listener:SSLCertificateId as ssl_certificate_id
  from
      aws_elbv1_load_balancers lb,
      lateral flatten(input => parse_json(lb.listener_descriptions), outer => TRUE) as li
)

select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Classic Load Balancers with SSL/HTTPS listeners should use a certificate provided by AWS Certificate Manager' as title,
  listeners.account_id,
  listeners.resource_id,
  case when
    listeners.protocol = 'HTTPS' and aws_acm_certificates.arn is null
    then 'fail'
    else 'pass'
  end as status
from listeners
left join aws_acm_certificates on aws_acm_certificates.arn = listeners.ssl_certificate_id
{% endmacro %}

{% macro postgres__elbv1_cert_provided_by_acm(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Classic Load Balancers with SSL/HTTPS listeners should use a certificate provided by AWS Certificate Manager' as title,
  lb.account_id,
  lb.arn as resource_id,
  case when
    li->'Listener'->>'Protocol' = 'HTTPS' and aws_acm_certificates.arn is null
    then 'fail'
    else 'pass'
  end as status
from aws_elbv1_load_balancers lb, jsonb_array_elements(lb.listener_descriptions) as li
left join
    aws_acm_certificates on
        aws_acm_certificates.arn = li->'Listener'->>'SSLCertificateId'
{% endmacro %}

{% macro default__elbv1_cert_provided_by_acm(framework, check_id) %}{% endmacro %}
                    