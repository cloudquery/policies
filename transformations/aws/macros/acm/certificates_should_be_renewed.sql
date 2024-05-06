{% macro certificates_should_be_renewed(framework, check_id) %}
  {{ return(adapter.dispatch('certificates_should_be_renewed')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__certificates_should_be_renewed(framework, check_id) %}
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

{% macro postgres__certificates_should_be_renewed(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'certificate has less than 30 days to be renewed' as title,
  account_id,
  arn AS resource_id,
  case when
    not_after < NOW() AT TIME ZONE 'UTC' + INTERVAL '30' DAY
    then 'fail'
    else 'pass'
  end as status
FROM aws_acm_certificates
{% endmacro %}

{% macro default__certificates_should_be_renewed(framework, check_id) %}{% endmacro %}

{% macro bigquery__certificates_should_be_renewed(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'certificate has less than 30 days to be renewed' as title,
  account_id,
  arn AS resource_id,
  case when
    not_after < CAST( {{ dbt.dateadd('day', 30, 'current_date') }} AS TIMESTAMP ) 
    then 'fail'
    else 'pass'
  end as status
FROM {{ full_table_name("aws_acm_certificates") }}
{% endmacro %}

{% macro athena__certificates_should_be_renewed(framework, check_id) %}
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