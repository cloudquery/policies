{% macro compute_unattached_disks_are_encrypted_with_cmk(framework, check_id) %}
  {{ return(adapter.dispatch('compute_unattached_disks_are_encrypted_with_cmk')(framework, check_id)) }}
{% endmacro %}

{% macro default__compute_unattached_disks_are_encrypted_with_cmk(framework, check_id) %}{% endmacro %}

{% macro postgres__compute_unattached_disks_are_encrypted_with_cmk(framework, check_id) %}
SELECT _cq_sync_time As sync_time,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Ensure that ''Unattached disks'' are encrypted with CMK (Automated)' AS title,
       subscription_id                                                       AS subscription_id,
       id                                                                    AS resource_id,
       CASE
           WHEN properties -> 'encryption'->>'type' NOT LIKE '%CustomerKey%'
               THEN 'fail'
           ELSE 'pass'
           END                                                               AS status
FROM azure_compute_disks
WHERE properties ->> 'diskState' = 'Unattached'
{% endmacro %}

{% macro snowflake__compute_unattached_disks_are_encrypted_with_cmk(framework, check_id) %}
SELECT _cq_sync_time As sync_time,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Ensure that ''Unattached disks'' are encrypted with CMK (Automated)' AS title,
       subscription_id                                                       AS subscription_id,
       id                                                                    AS resource_id,
       CASE
           WHEN properties:encryption:type NOT LIKE '%CustomerKey%'
               THEN 'fail'
           ELSE 'pass'
           END                                                               AS status
FROM azure_compute_disks
WHERE properties:diskState = 'Unattached'
{% endmacro %}