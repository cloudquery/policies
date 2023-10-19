with
    aggregated as (
        {{ storage_buckets_publicly_accessible('cis_v1.2.0', '5.1') }}
        union
        {{ storage_buckets_without_uniform_bucket_level_access('cis_v1.2.0', '5.2') }}
    )
select *
from aggregated
