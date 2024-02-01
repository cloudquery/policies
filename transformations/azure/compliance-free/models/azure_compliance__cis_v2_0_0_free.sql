with
    aggregated as (
        ({{iam_custom_subscription_owner_roles('cis_v2.0.0','1.23')}})
        {{ union() }}
        ({{security_defender_on_for_servers('cis_v2.0.0','2.1.1')}})
        {{ union() }}
        ({{security_defender_on_for_app_service('cis_v2.0.0','2.1.2')}})
        {{ union() }}
        ({{security_defender_on_for_sql_servers('cis_v2.0.0','2.1.4')}})
        {{ union() }}
        ({{security_defender_on_for_sql_servers_on_machines('cis_v2.0.0','2.1.5')}})
        {{ union() }}
        ({{security_defender_on_for_storage('cis_v2.0.0','2.1.7')}})
        {{ union() }}
        ({{security_defender_on_for_container_registeries('cis_v2.0.0','2.1.8')}})
        {{ union() }}
        ({{security_defender_on_for_key_vault('cis_v2.0.0','2.1.10')}})
 )
select 
        {{ gen_timestamp() }},
        aggregated.*
from aggregated
