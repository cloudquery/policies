{% macro datalake_datalake_analytics_accounts_with_disabled_logging(framework, check_id) %}
WITH
    settings_with_logs AS (
        SELECT resource_id, JSONB_ARRAY_ELEMENTS(properties -> 'logs') AS logs FROM azure_monitor_diagnostic_settings
    ),
    accounts_with_logging_enabled AS (SELECT DISTINCT d._cq_id
                                      FROM azure_datalakeanalytics_accounts d
                                               LEFT JOIN settings_with_logs s ON d.id = s.resource_id
                                      WHERE (s.logs->>'enabled')::boolean IS TRUE
    )

SELECT
  :'execution_time'
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  '',
  subscription_id,
  id,
  case
    when e.cq_id is null then 'fail' else 'pass'
  end
FROM azure_datalakeanalytics_accounts a
    LEFT JOIN accounts_with_logging_enabled e ON a.cq_id = e.cq_id
{% endmacro %}