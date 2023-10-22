with
    aggregated as (
        {{ kms_publicly_accessible('cis_v1.2.0', '1.9') }}
        union
        {{ kms_keys_not_rotated_within_90_days('cis_v1.2.0', '1.10') }}
        union
        {{ kms_separation_of_duties('cis_v1.2.0', '1.11') }}
    )

select * from aggregated
