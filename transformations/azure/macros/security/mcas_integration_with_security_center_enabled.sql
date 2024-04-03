{% macro security_mcas_integration_with_security_center_enabled(framework, check_id) %}
  {{ return(adapter.dispatch('security_mcas_integration_with_security_center_enabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__security_mcas_integration_with_security_center_enabled(framework, check_id) %}{% endmacro %}

{% macro postgres__security_mcas_integration_with_security_center_enabled(framework, check_id) %}
SELECT
  id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure that Microsoft Cloud App Security (MCAS) integration with Security Center is selected (Automatic)' as title,
  subscription_id,
  case
    when enabled = TRUE
    then 'pass' else 'fail'
  end
FROM azure_security_settings ass
WHERE name in ('MCAS', 'Microsoft Cloud App Security')
{% endmacro %}

{% macro snowflake__security_mcas_integration_with_security_center_enabled(framework, check_id) %}

{% endmacro %}

{% macro bigquery__security_mcas_integration_with_security_center_enabled(framework, check_id) %}

{% endmacro %}