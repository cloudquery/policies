{% macro monitor_insufficient_diagnostic_capturing_settings(framework, check_id) %}
  {{ return(adapter.dispatch('monitor_insufficient_diagnostic_capturing_settings')(framework, check_id)) }}
{% endmacro %}

{% macro default__monitor_insufficient_diagnostic_capturing_settings(framework, check_id) %}{% endmacro %}

{% macro postgres__monitor_insufficient_diagnostic_capturing_settings(framework, check_id) %}
WITH diagnostic_settings AS (
    SELECT
        subscription_id,
        id,
        (logs->>'enabled')::boolean AS enabled,
        logs->>'category' AS category
    FROM
        azure_monitor_subscription_diagnostic_settings a,
        jsonb_array_elements(properties->'logs') AS logs
),
required_settings AS (
    SELECT *
    FROM diagnostic_settings
    WHERE category IN ('Administrative', 'Alert', 'Policy', 'Security')
)
SELECT
    id                                                          AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure Diagnostic Setting captures appropriate categories' AS title,
    subscription_id                                             AS subscription_id,
    CASE
        WHEN COUNT(id) = 4
        THEN 'pass'
        ELSE 'fail'
    END                                                         AS status
FROM required_settings
WHERE enabled
GROUP BY subscription_id, id
{% endmacro %}

{% macro snowflake__monitor_insufficient_diagnostic_capturing_settings(framework, check_id) %}
  WITH diagnostic_settings AS (
      SELECT
          subscription_id,
          id,
          (value:enabled)::boolean AS enabled,
          value:category AS category
      FROM azure_monitor_subscription_diagnostic_settings,
        LATERAL FLATTEN(input => properties:logs) AS logs
  ),
  required_settings AS (
      SELECT *
      FROM diagnostic_settings
      WHERE category IN ('Administrative', 'Alert', 'Policy', 'Security')
  )
  SELECT
      id                                                          AS resource_id,
      '{{framework}}' As framework,
      '{{check_id}}' As check_id,
      'Ensure Diagnostic Setting captures appropriate categories' AS title,
      subscription_id                                             AS subscription_id,
      CASE
          WHEN COUNT(id) = 4
          THEN 'pass'
          ELSE 'fail'
      END                                                         AS status
  FROM required_settings
  WHERE enabled
  GROUP BY subscription_id, id
{% endmacro %}