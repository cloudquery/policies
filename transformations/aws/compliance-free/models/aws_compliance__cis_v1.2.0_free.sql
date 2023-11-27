with
    aggregated as (
    ({{ avoid_root_usage('cis_v1.2.0','1.1') }})
        UNION
    ({{ mfa_enabled_for_console_access('cis_v1.2.0','1.2') }})
        UNION
    ({{ unused_creds_disabled('cis_v1.2.0','1.3') }})
        UNION
    ({{ old_access_keys('cis_v1.2.0','1.4') }})
        UNION
    ({{ password_policy_min_uppercase('cis_v1.2.0','1.5') }})
        UNION
    ({{ password_policy_min_lowercase('cis_v1.2.0','1.6') }})
    )
select 
        ('{{ run_started_at }}')::timestamp as policy_execution_time,
        aggregated.*
from aggregated
