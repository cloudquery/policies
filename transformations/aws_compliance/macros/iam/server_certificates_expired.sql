{% macro server_certificates_expired(framework, check_id) %}
  {{ return(adapter.dispatch('server_certificates_expired')(framework, check_id)) }}
{% endmacro %}

{% macro default__server_certificates_expired(framework, check_id) %}{% endmacro %}

{% macro postgres__server_certificates_expired(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Ensure that all the expired SSL/TLS certificates stored in AWS IAM are removed (Automated)' as title,
    account_id,
    arn AS resource_id,
    case when
                 expiration < NOW() AT TIME ZONE 'UTC'
             then 'fail'
         else 'pass'
        end as status
FROM aws_iam_server_certificates{% endmacro %}
