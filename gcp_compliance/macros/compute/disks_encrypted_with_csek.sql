{% macro compute_disks_encrypted_with_csek(framework, check_id) %}
    select 
                "name"                                                                    AS resource_id,
                _cq_sync_time As sync_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure VM disks for critical VMs are encrypted with Customer-Supplied Encryption Keys (CSEK) (Automated)' AS title,
                project_id                                                                AS project_id,
                CASE
                WHEN
                        disk_encryption_key->>'sha256' IS NULL
                        OR disk_encryption_key->>'sha256' = ''
                        OR source_image_encryption_key->>'kms_key_name' IS NULL
                        OR source_image_encryption_key->>'kms_key_name' = ''
                    THEN 'fail'
                ELSE 'pass'
                END                                                                                                    AS status
    FROM gcp_compute_disks
{% endmacro %}