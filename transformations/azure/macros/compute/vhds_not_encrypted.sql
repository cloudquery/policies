{% macro compute_vhds_not_encrypted(framework, check_id) %}
  {{ return(adapter.dispatch('compute_vhds_not_encrypted')(framework, check_id)) }}
{% endmacro %}

{% macro default__compute_vhds_not_encrypted(framework, check_id) %}{% endmacro %}

{% macro postgres__compute_vhds_not_encrypted(framework, check_id) %}
SELECT
        id                                          AS resource_id,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Ensure that VHD''s are encrypted (Manual)' AS title,
       subscription_id                             AS subscription_id,
       CASE
           WHEN (properties -> 'encryptionSettingsCollection' ->> 'enabled')::boolean IS DISTINCT FROM TRUE
           THEN 'fail'
           ELSE 'pass'
       END                                         AS status
FROM azure_compute_disks
{% endmacro %}

{% macro snowflake__compute_vhds_not_encrypted(framework, check_id) %}
SELECT
        id                                          AS resource_id,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Ensure that VHD''s are encrypted (Manual)' AS title,
       subscription_id                             AS subscription_id,
       CASE
           WHEN (properties:encryptionSettingsCollection:enabled)::boolean IS DISTINCT FROM TRUE
           THEN 'fail'
           ELSE 'pass'
       END                                         AS status
FROM azure_compute_disks
{% endmacro %}

{% macro bigquery__compute_vhds_not_encrypted(framework, check_id) %}
SELECT
        id                                          AS resource_id,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Ensure that VHDs are encrypted (Manual)' AS title,
       subscription_id                             AS subscription_id,
       CASE
           WHEN CAST( JSON_VALUE(properties.encryptionSettingsCollection.enabled) AS BOOL) IS DISTINCT FROM TRUE
           THEN 'fail'
           ELSE 'pass'
       END                                         AS status
FROM {{ full_table_name("azure_compute_disks") }}
{% endmacro %}