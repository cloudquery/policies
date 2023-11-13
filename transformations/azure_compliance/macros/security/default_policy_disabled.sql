{% macro security_default_policy_disabled(framework, check_id) %}

SELECT
  _cq_sync_time As sync_time,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure any of the ASC Default policy setting is not set to "Disabled" (Automated)' as title,
  subscription_id,
  concat(id, '/', param),
  case
    when value = 'Disabled'
    then 'fail' else 'pass'
  end
FROM {{ ref('view_azure_security_policy_parameters') }}
{% endmacro %}