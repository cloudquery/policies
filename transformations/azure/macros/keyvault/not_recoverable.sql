{% macro keyvault_not_recoverable(framework, check_id) %}
  {{ return(adapter.dispatch('keyvault_not_recoverable')(framework, check_id)) }}
{% endmacro %}

{% macro default__keyvault_not_recoverable(framework, check_id) %}{% endmacro %}

{% macro postgres__keyvault_not_recoverable(framework, check_id) %}
SELECT _cq_sync_time As sync_time,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Ensure the key vault is recoverable (Automated)' AS title,
       subscription_id                                   AS subscription_id,
       id                                                AS resource_id,
       CASE
           WHEN (properties ->> 'enableSoftDelete')::boolean IS NOT TRUE OR (properties ->> 'enablePurgeProtection')::boolean IS NOT TRUE
               THEN 'fail'
           ELSE 'pass'
           END                                           AS status
FROM azure_keyvault_keyvault
{% endmacro %}

{% macro snowflake__keyvault_not_recoverable(framework, check_id) %}
SELECT _cq_sync_time As sync_time,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Ensure the key vault is recoverable (Automated)' AS title,
       subscription_id                                   AS subscription_id,
       id                                                AS resource_id,
       CASE
           WHEN (properties:enableSoftDelete::boolean != TRUE) OR (properties:enablePurgeProtection::boolean != TRUE)
               THEN 'fail'
           ELSE 'pass'
           END                                           AS status
FROM azure_keyvault_keyvault
{% endmacro %}