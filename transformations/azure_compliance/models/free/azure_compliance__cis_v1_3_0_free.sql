with
    aggregated as (
        ({{iam_custom_subscription_owner_roles('cis_v1.3.0','1.21')}})
        union
        ({{security_defender_on_for_servers('cis_v1.3.0','2.1')}})
        union
        ({{security_defender_on_for_app_service('cis_v1.3.0','2.2')}})
        union
        ({{security_defender_on_for_sql_servers('cis_v1.3.0','2.3')}})
        union
        ({{security_defender_on_for_sql_servers_on_machines('cis_v1.3.0','2.4')}})
        union
        ({{security_defender_on_for_storage('cis_v1.3.0','2.5')}})
        union
        ({{security_defender_on_for_k8s('cis_v1.3.0','2.6')}})
        union
        ({{security_defender_on_for_container_registeries('cis_v1.3.0','2.7')}})
        union
        ({{security_defender_on_for_key_vault('cis_v1.3.0','2.8')}})
 )
select *
from aggregated
