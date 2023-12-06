{% macro monitor_azure_monitor_log_profile_should_collect_logs_for_categories_write_delete_and_action(framework, check_id) %}

SELECT
  s.id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Azure Monitor log profile should collect logs for categories ''write,'' ''delete,'' and ''action''',
  s.id,
  'fail' as status
FROM
  azure_subscription_subscriptions s
  LEFT OUTER JOIN azure_monitor_log_profiles p
  ON s.id = '/subscriptions/' || p.subscription_id
WHERE
  p.properties -> 'categories' IS NULL
  OR NOT p.properties -> 'categories' @> '["Write", "Action","Delete"]'::jsonb
{% endmacro %}