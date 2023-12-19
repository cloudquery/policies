{% macro security_notify_high_severity_alerts(framework, check_id) %}

SELECT
  id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure that "Notify about alerts with the following severity" is set to "High" (Automated)' as title,
  subscription_id,
  case
    when email IS NOT NULL
      AND email != '' AND alert_notifications = 'On'
    then 'pass' else 'fail'
  end
FROM azure_security_contacts
{% endmacro %}