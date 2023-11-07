{% macro storage_no_public_blob_container(framework, check_id) %}

SELECT
    azsc._cq_sync_time As sync_time,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure that ''Public access level'' is set to Private for blob containers' AS title,
    azsc.subscription_id                                                        AS subscription_id,
    azsc.id                                                                     AS resrouce_id,
    CASE
        WHEN (asa.properties->>'allowBlobPublicAccess')::BOOLEAN = true 
        AND (azsc.properties->>'publicAccess') <> 'None' 
        THEN 'fail'
        ELSE 'pass'
    END                                                                         AS status
FROM azure_storage_containers azsc
    JOIN azure_storage_accounts asa on azsc._cq_parent_id = asa._cq_id
{% endmacro %}