with
    aggregated as (
    ({{ security_account_information_provided('cis_v3.0.0','1.2') }})
        {{ union() }}
    ({{ iam_root_user_no_access_keys('cis_v3.0.0','1.4') }})
        {{ union() }}
    ({{ mfa_enabled_for_root('cis_v3.0.0','1.5') }})
        {{ union() }}
    ({{ hardware_mfa_enabled_for_root('cis_v3.0.0','1.6') }})
        {{ union() }}
    ({{ iam_root_last_used('cis_v3.0.0','1.7') }})
        {{ union() }}
    ({{ password_policy_min_length('cis_v3.0.0','1.8') }})
        {{ union() }}
    ({{ password_policy_prevent_reuse('cis_v3.0.0','1.9') }})
    )
select 
        {{ gen_timestamp() }},
        aggregated.*
from aggregated
