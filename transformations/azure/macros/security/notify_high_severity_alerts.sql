{% macro default__security_notify_high_severity_alerts(framework, check_id) %}{% endmacro %}

{% macro postgres__security_notify_high_severity_alerts(framework, check_id) %}
SELECT
  id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure That "Notify about alerts with the following severity" is Set to "High" (Automated)' as title,
  subscription_id,
  case
    when properties ->> 'alertNotifications' = 'On' and properties ->> 'email' is not null
    then 'pass' else 'fail'
  end
FROM azure_security_contacts asc
where "name" = "default1"
{% endmacro %}

{% macro snowflake__security_notify_high_severity_alerts(framework, check_id) %}
SELECT
  id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure That "Notify about alerts with the following severity" is Set to "High" (Automated)' as title,
  subscription_id,
  case
    when properties:alertNotifications = 'On' and properties:email is not null
    then 'pass' else 'fail'
  end
FROM azure_security_contacts asc
where name = "default1"
{% endmacro %}

{% macro bigquery__security_notify_high_severity_alerts(framework, check_id) %}
SELECT
  id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure That "Notify about alerts with the following severity" is Set to "High" (Automated)' as title,
  subscription_id,
  case
    when JSON_VALUE(properties.alertNotifications) = 'On' and (JSON_VALUE(properties.email) is not null or JSON_VALUE(properties.email) != "")
    then 'pass' else 'fail'
  end
FROM {{ full_table_name("azure_security_contacts") }} asc
where name = "default1"
{% endmacro %}