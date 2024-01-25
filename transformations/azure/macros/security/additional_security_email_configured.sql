{% macro security_additional_security_email_configured(framework, check_id) %}
  {{ return(adapter.dispatch('security_additional_security_email_configured')(framework, check_id)) }}
{% endmacro %}

{% macro default__additional_security_email_configured(framework, check_id) %}{% endmacro %}

{% macro postgres__additional_security_email_configured(framework, check_id) %}
SELECT
  id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure "Additional email addresses" is Configured with a Security Contact Email (Automated)' as title,
  subscription_id,
  case
    when properties ->> 'email' is not null
    then 'pass' else 'fail'
  end
FROM azure_security_contacts asc
where "name" = "default"
{% endmacro %}

{% macro snowflake__additional_security_email_configured(framework, check_id) %}
SELECT
  id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure "Additional email addresses" is Configured with a Security Contact Email (Automated)' as title,
  subscription_id,
  case
    when properties:email is not null
    then 'pass' else 'fail'
  end
FROM azure_security_contacts asc
where name = "default"
{% endmacro %}

{% macro bigquery__additional_security_email_configured(framework, check_id) %}
SELECT
  id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure "Additional email addresses" is Configured with a Security Contact Email (Automated)' as title,
  subscription_id,
  case
    when (JSON_VALUE(properties.email) is not null or JSON_VALUE(properties.email) != "")
    then 'pass' else 'fail'
  end
FROM {{ full_table_name("azure_security_contacts") }} asc
where name = "default"
{% endmacro %}