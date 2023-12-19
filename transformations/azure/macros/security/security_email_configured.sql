{% macro security_security_email_configured(framework, check_id) %}

SELECT
  id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure "Additional email addresses" is configured with a security contact email (Automated)' as title,
  subscription_id,
  case
    when email IS NOT NULL
      AND email != ''
    then 'pass' else 'fail'
  end
FROM azure_security_contacts
{% endmacro %}