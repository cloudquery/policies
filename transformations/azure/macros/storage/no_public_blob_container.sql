{% macro storage_no_public_blob_container(framework, check_id) %}
  {{ return(adapter.dispatch('storage_no_public_blob_container')(framework, check_id)) }}
{% endmacro %}

{% macro default__storage_no_public_blob_container(framework, check_id) %}{% endmacro %}

{% macro postgres__storage_no_public_blob_container(framework, check_id) %}
SELECT
    azsc.id                                                                     AS resrouce_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure that ''Public access level'' is set to Private for blob containers' AS title,
    azsc.subscription_id                                                        AS subscription_id,
    CASE
        WHEN (asa.properties->>'allowBlobPublicAccess')::BOOLEAN = true 
        AND (azsc.properties->>'publicAccess') <> 'None' 
        THEN 'fail'
        ELSE 'pass'
    END                                                                         AS status
FROM azure_storage_containers azsc
    JOIN azure_storage_accounts asa on azsc._cq_parent_id = asa._cq_id
{% endmacro %}

{% macro snowflake__storage_no_public_blob_container(framework, check_id) %}
SELECT
    azsc.id                                                                     AS resrouce_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure that ''Public access level'' is set to Private for blob containers' AS title,
    azsc.subscription_id                                                        AS subscription_id,
    CASE
        WHEN (asa.properties:allowBlobPublicAccess)::BOOLEAN = true 
        AND (azsc.properties:publicAccess) <> 'None' 
        THEN 'fail'
        ELSE 'pass'
    END                                                                         AS status
FROM azure_storage_containers azsc
    JOIN azure_storage_accounts asa on azsc._cq_parent_id = asa._cq_id
{% endmacro %}

{% macro bigquery__storage_no_public_blob_container(framework, check_id) %}
SELECT
    azsc.id                                                                     AS resrouce_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure that "Public access level" is set to Private for blob containers' AS title,
    azsc.subscription_id                                                        AS subscription_id,
    CASE
        WHEN CAST( JSON_VALUE(asa.properties.allowBlobPublicAccess) AS BOOL) = TRUE 
        AND JSON_VALUE(azsc.properties.publicAccess) <> 'None' 
        THEN 'fail'
        ELSE 'pass'
    END                                                                         AS status
FROM {{ full_table_name("azure_storage_containers") }} azsc
    JOIN {{ full_table_name("azure_storage_accounts") }} asa on azsc._cq_parent_id = asa._cq_id
{% endmacro %}