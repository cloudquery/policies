{% macro redis_only_secure_connections_to_your_azure_cache_for_redis_should_be_enabled(framework, check_id) %}

SELECT
  _cq_sync_time As sync_time,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Only secure connections to your Azure Cache for Redis should be enabled',
  subscription_id,
  id,
  case
    when (properties ->> 'enableNonSslPort')::boolean IS NOT FALSE
    then 'fail' else 'pass'
  end
FROM azure_redis_caches

{% endmacro %}