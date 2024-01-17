{% macro security_default_policy_disabled(framework, check_id) %}
  {{ return(adapter.dispatch('security_default_policy_disabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__security_default_policy_disabled(framework, check_id) %}{% endmacro %}

{% macro postgres__security_default_policy_disabled(framework, check_id) %}
SELECT
  concat(id, '/', param),
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure any of the ASC Default policy setting is not set to "Disabled" (Automated)' as title,
  subscription_id,
  case
    when value = 'Disabled'
    then 'fail' else 'pass'
  end
FROM {{ ref('view_azure_security_policy_parameters') }}
{% endmacro %}

{% macro snowflake__security_default_policy_disabled(framework, check_id) %}
SELECT
  concat(id, '/', param),
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure any of the ASC Default policy setting is not set to "Disabled" (Automated)' as title,
  subscription_id,
  case
    when value = 'Disabled'
    then 'fail' else 'pass'
  end
FROM {{ ref('view_azure_security_policy_parameters') }}
{% endmacro %}

{% macro bigquery__security_default_policy_disabled(framework, check_id) %}
SELECT
  concat(id, '/', JSON_VALUE(param)),
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure any of the ASC Default policy setting is not set to "Disabled" (Automated)' as title,
  subscription_id,
  case
    when JSON_VALUE(value) = 'Disabled'
    then 'fail' else 'pass'
  end
FROM {{ ref('view_azure_security_policy_parameters') }}
{% endmacro %}