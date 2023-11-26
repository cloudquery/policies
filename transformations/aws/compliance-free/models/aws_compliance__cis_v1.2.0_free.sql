with
    aggregated as (
    ({{ avoid_root_usage('cis_v1.2.0','1.1') }})
        {{ union() }}
    ({{ mfa_enabled_for_console_access('cis_v1.2.0','1.2') }})
        {{ union() }}
    ({{ unused_creds_disabled('cis_v1.2.0','1.3') }})
        {{ union() }}
    ({{ old_access_keys('cis_v1.2.0','1.4') }})
        {{ union() }}
    ({{ password_policy_min_uppercase('cis_v1.2.0','1.5') }})
        {{ union() }}
    ({{ password_policy_min_lowercase('cis_v1.2.0','1.6') }})
    )
select 
        {{ gen_timestamp() }},
        aggregated.*
from aggregated
