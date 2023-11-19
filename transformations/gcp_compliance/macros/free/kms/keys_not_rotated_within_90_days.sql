{% macro kms_keys_not_rotated_within_90_days(framework, check_id) %}
  {{ return(adapter.dispatch('kms_keys_not_rotated_within_90_days')(framework, check_id)) }}
{% endmacro %}

{% macro default__kms_keys_not_rotated_within_90_days(framework, check_id) %}{% endmacro %}

{% macro postgres__kms_keys_not_rotated_within_90_days(framework, check_id) %}
select
        "name" as resource_id,
        _cq_sync_time as sync_time,
        '{{framework}}' as framework,
        '{{check_id}}' as check_id,
        'Ensure KMS encryption keys are rotated within a period of 90 days (Automated)'
        as title,
        project_id as project_id,
        case
            when
                (
                    make_interval(secs => rotation_period / 1000000000.0)
                    > make_interval(days => 90)
                )
                or next_rotation_time is null
                or date_part('day', current_date - next_rotation_time::timestamp) > 90
            then 'fail'
            else 'pass'
        end as status
    from gcp_kms_crypto_keys
{% endmacro %}

{% macro snowflake__kms_keys_not_rotated_within_90_days(framework, check_id) %}
select
        name as resource_id,
        _cq_sync_time as sync_time,
        '{{framework}}' as framework,
        '{{check_id}}' as check_id,
        'Ensure KMS encryption keys are rotated within a period of 90 days (Automated)'
        as title,
        project_id as project_id,
        case
            when
            ((
              DATEADD(SECOND, rotation_period / 1000000000.0, CURRENT_TIMESTAMP))
            > DATEADD(DAY, 90, CURRENT_TIMESTAMP))
           OR
           next_rotation_time IS NULL
            OR datediff(day, next_rotation_time::timestamp, current_date) > 90
        
            then 'fail'
            else 'pass'
        end as status
    from gcp_kms_crypto_keys
{% endmacro %}

{% macro bigquery__kms_keys_not_rotated_within_90_days(framework, check_id) %}
select
        name as resource_id,
        _cq_sync_time as sync_time,
        '{{framework}}' as framework,
        '{{check_id}}' as check_id,
        'Ensure KMS encryption keys are rotated within a period of 90 days (Automated)'
        as title,
        project_id as project_id,
        case
            when
                (
                    INTERVAL CAST( (rotation_period/1000000000.0) AS INT64 ) SECOND
                    > INTERVAL 90 DAY
                )
                or next_rotation_time is null
                or TIMESTAMP_DIFF(next_rotation_time, CURRENT_TIMESTAMP(), DAY) > 90
            then 'fail'
            else 'pass'
        end as status
    from {{ full_table_name("gcp_kms_crypto_keys") }}
{% endmacro %}
