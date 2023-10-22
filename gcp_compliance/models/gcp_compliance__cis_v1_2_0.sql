with
    aggregated as (
        select * from {{ ref('check_iam') }}
        union
        select * from {{ ref('check_kms') }}
        union
        select * from {{ ref('check_bigquery') }}
        union
        select * from {{ ref('check_compute') }}
        union
        select * from {{ ref('check_dns') }}
        union
        select * from {{ ref('check_logging') }}
        union
        select * from {{ ref('check_sql') }}
        union
        select * from {{ ref('check_storage') }}

    )
select *
from aggregated
