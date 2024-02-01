{% macro storage_infrastructure_encryption_enabled(framework, check_id) %}
  {{ return(adapter.dispatch('storage_infrastructure_encryption_enabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__storage_infrastructure_encryption_enabled(framework, check_id) %}{% endmacro %}

{% macro postgres__storage_infrastructure_encryption_enabled(framework, check_id) %}
SELECT
    id                                                                     AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure that "Enable Infrastructure Encryption" for Each Storage Account in Azure Storage is Set to "enabled" (Automated)' AS title,
    subscription_id                                                        AS subscription_id,
    CASE
        WHEN (properties->>'requireInfrastructureEncryption')::BOOLEAN = true 
        THEN 'pass'
        ELSE 'fail'
    END                                                                         AS status
FROM azure_storage_accounts asa
{% endmacro %}

{% macro snowflake__storage_infrastructure_encryption_enabled(framework, check_id) %}
SELECT
    id                                                                     AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure that "Enable Infrastructure Encryption" for Each Storage Account in Azure Storage is Set to "enabled" (Automated)' AS title,
    subscription_id                                                        AS subscription_id,
    CASE
        WHEN (properties:requireInfrastructureEncryption)::BOOLEAN = true  
        THEN 'pass'
        ELSE 'fail'
    END                                                                         AS status
FROM azure_storage_accounts asa
{% endmacro %}

{% macro bigquery__storage_infrastructure_encryption_enabled(framework, check_id) %}
SELECT
    id                                                                     AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure that "Enable Infrastructure Encryption" for Each Storage Account in Azure Storage is Set to "enabled" (Automated)' AS title,
    subscription_id                                                        AS subscription_id,
    CASE
        WHEN CAST( JSON_VALUE(properties.requireInfrastructureEncryption) AS BOOL) = TRUE 
        THEN 'pass'
        ELSE 'fail'
    END                                                                         AS status
FROM {{ full_table_name("azure_storage_accounts") }} asa
{% endmacro %}