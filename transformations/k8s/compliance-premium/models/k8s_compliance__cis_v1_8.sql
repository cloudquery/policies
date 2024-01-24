with
    aggregated as (
        ({{ api_server_1_2_1('Kubernetes CIS v1.8.0','api_server_1_2_1') }})
                union
        ({{ api_server_1_2_2('Kubernetes CIS v1.8.0','api_server_1_2_2') }})
                union
        ({{ api_server_1_2_3('Kubernetes CIS v1.8.0','api_server_1_2_3') }})
                union
        ({{ api_server_1_2_4('Kubernetes CIS v1.8.0','api_server_1_2_4') }})
                union
        ({{ api_server_1_2_5('Kubernetes CIS v1.8.0','api_server_1_2_5') }})
                union
        ({{ api_server_1_2_6('Kubernetes CIS v1.8.0','api_server_1_2_6') }})
                union
        ({{ api_server_1_2_7('Kubernetes CIS v1.8.0','api_server_1_2_7') }})
                union
        ({{ api_server_1_2_8('Kubernetes CIS v1.8.0','api_server_1_2_8') }})
                union
        ({{ api_server_1_2_9('Kubernetes CIS v1.8.0','api_server_1_2_9') }})
                union
        ({{ api_server_1_2_10('Kubernetes CIS v1.8.0','api_server_1_2_10') }})
                union
        ({{ api_server_1_2_11('Kubernetes CIS v1.8.0','api_server_1_2_11') }})
                union
        ({{ api_server_1_2_12('Kubernetes CIS v1.8.0','api_server_1_2_12') }})
                union
        ({{ api_server_1_2_13('Kubernetes CIS v1.8.0','api_server_1_2_13') }})
                union
        ({{ api_server_1_2_14('Kubernetes CIS v1.8.0','api_server_1_2_14') }})
                union
        ({{ api_server_1_2_15('Kubernetes CIS v1.8.0','api_server_1_2_15') }})
                union
        ({{ api_server_1_2_16('Kubernetes CIS v1.8.0','api_server_1_2_16') }})
                union
        ({{ api_server_1_2_17('Kubernetes CIS v1.8.0','api_server_1_2_17') }})
                union
        ({{ api_server_1_2_18('Kubernetes CIS v1.8.0','api_server_1_2_18') }})
                union
        ({{ api_server_1_2_19('Kubernetes CIS v1.8.0','api_server_1_2_19') }})
                union
        ({{ api_server_1_2_20('Kubernetes CIS v1.8.0','api_server_1_2_20') }})
                union
        ({{ api_server_1_2_21('Kubernetes CIS v1.8.0','api_server_1_2_21') }})
                union
        ({{ api_server_1_2_22('Kubernetes CIS v1.8.0','api_server_1_2_22') }})
                union
        ({{ api_server_1_2_23('Kubernetes CIS v1.8.0','api_server_1_2_23') }})
                union
        ({{ api_server_1_2_24('Kubernetes CIS v1.8.0','api_server_1_2_24') }})
                union
        ({{ api_server_1_2_25('Kubernetes CIS v1.8.0','api_server_1_2_25') }})
                union
        ({{ api_server_1_2_26('Kubernetes CIS v1.8.0','api_server_1_2_26') }})
                union
        ({{ api_server_1_2_27('Kubernetes CIS v1.8.0','api_server_1_2_27') }})
                union
        ({{ api_server_1_2_28('Kubernetes CIS v1.8.0','api_server_1_2_28') }})
                union
        ({{ api_server_1_2_29('Kubernetes CIS v1.8.0','api_server_1_2_29') }})
                union
        ({{ api_server_1_2_30('Kubernetes CIS v1.8.0','api_server_1_2_30') }})
                union
        ({{ controller_manager_1_3_1('Kubernetes CIS v1.8.0','controller_manager_1_3_1') }})
                union
        ({{ controller_manager_1_3_2('Kubernetes CIS v1.8.0','controller_manager_1_3_2') }})
                union
        ({{ controller_manager_1_3_3('Kubernetes CIS v1.8.0','controller_manager_1_3_3') }})
                union
        ({{ controller_manager_1_3_4('Kubernetes CIS v1.8.0','controller_manager_1_3_4') }})
                union
        ({{ controller_manager_1_3_5('Kubernetes CIS v1.8.0','controller_manager_1_3_5') }})
                union
        ({{ controller_manager_1_3_6('Kubernetes CIS v1.8.0','controller_manager_1_3_6') }})
                union
        ({{ controller_manager_1_3_7('Kubernetes CIS v1.8.0','controller_manager_1_3_7') }})
                union
        ({{ etcd_2_1('Kubernetes CIS v1.8.0','etcd_2_1') }})
                union
        ({{ etcd_2_2('Kubernetes CIS v1.8.0','etcd_2_2') }})
                union
        ({{ etcd_2_3('Kubernetes CIS v1.8.0','etcd_2_3') }})
                union
        ({{ etcd_2_4('Kubernetes CIS v1.8.0','etcd_2_4') }})
                union
        ({{ etcd_2_5('Kubernetes CIS v1.8.0','etcd_2_5') }})
                union
        ({{ etcd_2_6('Kubernetes CIS v1.8.0','etcd_2_6') }})
                union
        ({{ pod_security_standards_5_7_2('Kubernetes CIS v1.8.0','pod_security_standards_5_7_2') }})
                union
        ({{ pod_security_standards_5_7_3('Kubernetes CIS v1.8.0','pod_security_standards_5_7_3') }})
                union
        ({{ pod_security_standards_5_7_4('Kubernetes CIS v1.8.0','pod_security_standards_5_7_4') }})
                union
        ({{ logging_3_2_1('Kubernetes CIS v1.8.0','logging_3_2_1') }})
                union
        ({{ pod_security_standards_5_3_2('Kubernetes CIS v1.8.0','pod_security_standards_5_3_2') }})
                union
        ({{ pod_security_standards_5_2_2('Kubernetes CIS v1.8.0','pod_security_standards_5_2_2') }})
                union
        ({{ pod_security_standards_5_2_3('Kubernetes CIS v1.8.0','pod_security_standards_5_2_3') }})
                union
        ({{ pod_security_standards_5_2_4('Kubernetes CIS v1.8.0','pod_security_standards_5_2_4') }})
                union
        ({{ pod_security_standards_5_2_5('Kubernetes CIS v1.8.0','pod_security_standards_5_2_5') }})
                union
        ({{ pod_security_standards_5_2_6('Kubernetes CIS v1.8.0','pod_security_standards_5_2_6') }})
                union
        ({{ pod_security_standards_5_2_8('Kubernetes CIS v1.8.0','pod_security_standards_5_2_8') }})
                union
        ({{ pod_security_standards_5_2_9('Kubernetes CIS v1.8.0','pod_security_standards_5_2_9') }})
                union
        ({{ pod_security_standards_5_2_10('Kubernetes CIS v1.8.0','pod_security_standards_5_2_10') }})
                union
        ({{ pod_security_standards_5_2_11('Kubernetes CIS v1.8.0','pod_security_standards_5_2_11') }})
                union
        ({{ pod_security_standards_5_2_12('Kubernetes CIS v1.8.0','pod_security_standards_5_2_12') }})
                union
        ({{ pod_security_standards_5_2_13('Kubernetes CIS v1.8.0','pod_security_standards_5_2_13') }})
                union
        ({{ rbac_and_service_accounts_5_1_1('Kubernetes CIS v1.8.0','rbac_and_service_accounts_5_1_1') }})
                union
        ({{ rbac_and_service_accounts_5_1_2('Kubernetes CIS v1.8.0','rbac_and_service_accounts_5_1_2') }})
                union
        ({{ rbac_and_service_accounts_5_1_3('Kubernetes CIS v1.8.0','rbac_and_service_accounts_5_1_3') }})
                union
        ({{ rbac_and_service_accounts_5_1_4('Kubernetes CIS v1.8.0','rbac_and_service_accounts_5_1_4') }})
                union
        ({{ rbac_and_service_accounts_5_1_5('Kubernetes CIS v1.8.0','rbac_and_service_accounts_5_1_5') }})
                union
        ({{ rbac_and_service_accounts_5_1_6('Kubernetes CIS v1.8.0','rbac_and_service_accounts_5_1_6') }})
                union
        ({{ rbac_and_service_accounts_5_1_7('Kubernetes CIS v1.8.0','rbac_and_service_accounts_5_1_7') }})
                union
        ({{ rbac_and_service_accounts_5_1_8('Kubernetes CIS v1.8.0','rbac_and_service_accounts_5_1_8') }})
                union
        ({{ rbac_and_service_accounts_5_1_9('Kubernetes CIS v1.8.0','rbac_and_service_accounts_5_1_9') }})
                union
        ({{ rbac_and_service_accounts_5_1_10('Kubernetes CIS v1.8.0','rbac_and_service_accounts_5_1_10') }})
                union
        ({{ rbac_and_service_accounts_5_1_11('Kubernetes CIS v1.8.0','rbac_and_service_accounts_5_1_11') }})
                union
        ({{ rbac_and_service_accounts_5_1_12('Kubernetes CIS v1.8.0','rbac_and_service_accounts_5_1_12') }})
                union
        ({{ rbac_and_service_accounts_5_1_13('Kubernetes CIS v1.8.0','rbac_and_service_accounts_5_1_13') }})
                union
        ({{ scheduler_1_4_1('Kubernetes CIS v1.8.0','scheduler_1_4_1') }})
                union
        ({{ scheduler_1_4_2('Kubernetes CIS v1.8.0','scheduler_1_4_2') }})
                union
        ({{ pod_security_standards_5_4_1('Kubernetes CIS v1.8.0','pod_security_standards_5_4_1') }})
                union
        ({{ pod_security_standards_5_4_2('Kubernetes CIS v1.8.0','pod_security_standards_5_4_2') }})
    )
select 
        ('{{ run_started_at }}')::timestamp as policy_execution_time,
        aggregated.*
from aggregated
