{% macro keyvault_secrets_without_expiration_date(framework, check_id) %}
  {{ return(adapter.dispatch('keyvault_secrets_without_expiration_date')(framework, check_id)) }}
{% endmacro %}

{% macro default__keyvault_secrets_without_expiration_date(framework, check_id) %}{% endmacro %}

{% macro postgres__keyvault_secrets_without_expiration_date(framework, check_id) %}
SELECT 
       akvs.id                                                             AS resource_id,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Ensure that the expiration date is set on all Secrets (Automated)' AS title,
       akv.subscription_id                                                 AS subscription_id,
       CASE
           WHEN (akvs.attributes ->>'enabled')::boolean = TRUE
            AND (akvs.attributes ->>'exp') IS NULL
           THEN 'fail'
           ELSE 'pass'
       END                                                                 AS status
FROM azure_keyvault_keyvaults akv
    JOIN azure_keyvault_secrets akvs
      ON akv._cq_id = akvs._cq_parent_id
{% endmacro %}

{% macro snowflake__keyvault_secrets_without_expiration_date(framework, check_id) %}
SELECT  
       akvs.id                                                             AS resource_id,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Ensure that the expiration date is set on all Secrets (Automated)' AS title,
       akv.subscription_id                                                 AS subscription_id,
       CASE
           WHEN (akvs.attributes:enabled)::boolean = TRUE
            AND (akvs.attributes:exp) IS NULL
           THEN 'fail'
           ELSE 'pass'
       END                                                                 AS status
FROM azure_keyvault_keyvaults akv
    JOIN azure_keyvault_secrets akvs
      ON akv._cq_id = akvs._cq_parent_id
{% endmacro %}

{% macro bigquery__keyvault_secrets_without_expiration_date(framework, check_id) %}
SELECT  
       akvs.id                                                             AS resource_id,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Ensure that the expiration date is set on all Secrets (Automated)' AS title,
       akv.subscription_id                                                 AS subscription_id,
       CASE
           WHEN CAST( JSON_VALUE(akvs.attributes.enabled) AS BOOL) = TRUE
            AND JSON_VALUE(akvs.attributes.exp) IS NULL
           THEN 'fail'
           ELSE 'pass'
       END                                                                 AS status
FROM {{ full_table_name("azure_keyvault_keyvaults") }} akv
    JOIN {{ full_table_name("azure_keyvault_secrets") }} akvs
      ON akv._cq_id = akvs._cq_parent_id
{% endmacro %}