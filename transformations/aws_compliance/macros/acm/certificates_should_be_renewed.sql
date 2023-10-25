{% macro certificates_should_be_renewed(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'certificate has less than 30 days to be renewed' as title,
  account_id,
  arn AS resource_id,
  case when
    not_after < {{ dbt.dateadd('day', 30, 'current_date') }}
    then 'fail'
    else 'pass'
  end as status
FROM aws_acm_certificates
{% endmacro %}