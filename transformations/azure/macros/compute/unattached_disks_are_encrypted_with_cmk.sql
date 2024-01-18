{% macro compute_unattached_disks_are_encrypted_with_cmk(framework, check_id) %}
  {{ return(adapter.dispatch('compute_unattached_disks_are_encrypted_with_cmk')(framework, check_id)) }}
{% endmacro %}

{% macro default__compute_unattached_disks_are_encrypted_with_cmk(framework, check_id) %}{% endmacro %}

{% macro postgres__compute_unattached_disks_are_encrypted_with_cmk(framework, check_id) %}
SELECT
       id                                                                    AS resource_id,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Ensure that ''Unattached disks'' are encrypted with CMK (Automated)' AS title,
       subscription_id                                                       AS subscription_id,
       CASE
           WHEN properties -> 'encryption'->>'type' NOT LIKE '%CustomerKey%'
               THEN 'fail'
           ELSE 'pass'
           END                                                               AS status
FROM azure_compute_disks
WHERE properties ->> 'diskState' = 'Unattached'
{% endmacro %}

{% macro snowflake__compute_unattached_disks_are_encrypted_with_cmk(framework, check_id) %}
SELECT
       id                                                                    AS resource_id,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Ensure that ''Unattached disks'' are encrypted with CMK (Automated)' AS title,
       subscription_id                                                       AS subscription_id,
       CASE
           WHEN properties:encryption:type NOT LIKE '%CustomerKey%'
               THEN 'fail'
           ELSE 'pass'
           END                                                               AS status
FROM azure_compute_disks
WHERE properties:diskState = 'Unattached'
{% endmacro %}

{% macro bigquery__compute_unattached_disks_are_encrypted_with_cmk(framework, check_id) %}
SELECT
       id                                                                    AS resource_id,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Ensure that "Unattached disks" are encrypted with CMK (Automated)' AS title,
       subscription_id                                                       AS subscription_id,
       CASE
           WHEN JSON_VALUE(properties.encryption.type) NOT LIKE '%CustomerKey%'
               THEN 'fail'
           ELSE 'pass'
           END                                                               AS status
FROM {{ full_table_name("azure_compute_disks") }}
WHERE JSON_VALUE(properties.diskState) = 'Unattached'
{% endmacro %}