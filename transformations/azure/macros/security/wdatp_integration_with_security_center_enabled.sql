{% macro security_wdatp_integration_with_security_center_enabled(framework, check_id) %}
  {{ return(adapter.dispatch('security_wdatp_integration_with_security_center_enabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__security_wdatp_integration_with_security_center_enabled(framework, check_id) %}{% endmacro %}

{% macro postgres__security_wdatp_integration_with_security_center_enabled(framework, check_id) %}
SELECT
  id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure that Microsoft Defender for Endpoint integration with Microsoft Defender for Cloud is selected' as title,
  subscription_id,
  case
    when enabled = TRUE
    then 'pass' else 'fail'
  end
FROM azure_security_settings ass
WHERE name in ('WDATP', 'ATP', 'Advanced Threat Protection') 
{% endmacro %}

{% macro snowflake__security_wdatp_integration_with_security_center_enabled(framework, check_id) %}

{% endmacro %}

{% macro bigquery__security_wdatp_integration_with_security_center_enabled(framework, check_id) %}

{% endmacro %}