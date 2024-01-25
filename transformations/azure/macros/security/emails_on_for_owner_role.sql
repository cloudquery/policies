{% macro security_emails_on_for_owner_role(framework, check_id) %}
  {{ return(adapter.dispatch('security_emails_on_for_owner_role')(framework, check_id)) }}
{% endmacro %}

{% macro default__security_emails_on_for_owner_role(framework, check_id) %}{% endmacro %}

{% macro postgres__security_emails_on_for_owner_role(framework, check_id) %}
SELECT
  id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure That "All users with the following roles" is set to "Owner" (Automated)' as title,
  subscription_id,
  case
    when properties ->> 'notificationsByRole' = 'Owner' and properties ->> 'email' is not null
    then 'pass' else 'fail'
  end
FROM azure_security_contacts asc
where "name" = "default1"
{% endmacro %}

{% macro snowflake__security_emails_on_for_owner_role(framework, check_id) %}
SELECT
  id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure That "All users with the following roles" is set to "Owner" (Automated)' as title,
  subscription_id,
  case
    when properties:notificationsByRole = 'Owner' and properties:email is not null
    then 'pass' else 'fail'
  end
FROM azure_security_contacts asc
where name = "default1"
{% endmacro %}

{% macro bigquery__security_emails_on_for_owner_role(framework, check_id) %}
SELECT
  id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure That "All users with the following roles" is set to "Owner" (Automated)' as title,
  subscription_id,
  case
    when JSON_VALUE(properties.notificationsByRole) = 'Owner' and (JSON_VALUE(properties.email) is not null or JSON_VALUE(properties.email) != "")
    then 'pass' else 'fail'
  end
FROM {{ full_table_name("azure_security_contacts") }} asc
where name = "default1"
{% endmacro %}