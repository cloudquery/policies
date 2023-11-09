with
    aggregated as (
        ({{ api_server_1_2_1('Kubernetes CIS v1.7.0','api_server_1_2_1') }})
        union
        ({{ daemonset_cpu_limit('nsa_cisa_v1',"daemonset_cpu_limit") }})
        union
        ({{ deployment_cpu_limit('nsa_cisa_v1',"deployment_cpu_limit") }})
        union
        ({{ job_cpu_limit('nsa_cisa_v1',"job_cpu_limit") }})
        union
        ({{ namespace_limit_range_default_cpu_limit('nsa_cisa_v1',"namespace_limit_range_default_cpu_limit") }})
        union
        ({{ namespace_resource_quota_cpu_limit('nsa_cisa_v1',"namespace_resource_quota_cpu_limit") }})
        union
        ({{ replicaset_cpu_limit('nsa_cisa_v1',"replicaset_cpu_limit") }})
        union
        ({{ daemonset_cpu_request('nsa_cisa_v1',"daemonset_cpu_request") }})
        union
        ({{ deployment_cpu_request('nsa_cisa_v1',"deployment_cpu_request") }})
        union
        ({{ namespace_limit_range_default_cpu_request('nsa_cisa_v1',"namespace_limit_range_default_cpu_request") }})
        union
        ({{ namespace_resource_quota_cpu_request('nsa_cisa_v1',"namespace_resource_quota_cpu_request") }})
        union
        ({{ replicaset_cpu_request('nsa_cisa_v1',"replicaset_cpu_request") }})
        union
        ({{ daemonset_memory_limit('nsa_cisa_v1',"daemonset_memory_limit") }})
        union
        ({{ deployment_memory_limit('nsa_cisa_v1',"deployment_memory_limit") }})
        union
        ({{ job_memory_limit('nsa_cisa_v1',"job_memory_limit") }})
        union
        ({{ namespace_limit_range_default_memory_limit('nsa_cisa_v1',"namespace_limit_range_default_memory_limit") }})
        union
        ({{ namespace_resource_quota_memory_limit('nsa_cisa_v1',"namespace_resource_quota_memory_limit") }})
        union
        ({{ replicaset_memory_limit('nsa_cisa_v1',"replicaset_memory_limit") }})
        union
        ({{ daemonset_memory_request('nsa_cisa_v1',"daemonset_memory_request") }})
        union
        ({{ deployment_memory_request('nsa_cisa_v1',"deployment_memory_request") }})
        union
        ({{ job_memory_request('nsa_cisa_v1',"job_memory_request") }})
        union
        ({{ namespace_limit_range_default_memory_request('nsa_cisa_v1',"namespace_limit_range_default_memory_request") }})
        union
        ({{ namespace_resource_quota_memory_request('nsa_cisa_v1',"namespace_resource_quota_memory_request") }})
        union
        ({{ replicaset_memory_request('nsa_cisa_v1',"replicaset_memory_request") }})
        union
        ({{ network_policy_default_deny_egress('nsa_cisa_v1',"network_policy_default_deny_egress") }})
        union
        ({{ network_policy_default_deny_ingress('nsa_cisa_v1',"network_policy_default_deny_ingress") }})
        union
        ({{ pod_volume_host_path('nsa_cisa_v1',"container_disallow_host_path") }})
        union
        ({{ daemonset_container_privilege_disabled('nsa_cisa_v1',"daemonset_container_privilege_disabled") }})
        union
        ({{ deployment_container_privilege_disabled('nsa_cisa_v1',"deployment_container_privilege_disabled") }})
        union
        ({{ job_container_privilege_disabled('nsa_cisa_v1',"job_container_privilege_disabled") }})
        union
        ({{ pod_container_privilege_disabled('nsa_cisa_v1',"pod_container_privilege_disabled") }})
        union
        ({{ replicaset_container_privilege_disabled('nsa_cisa_v1',"replicaset_container_privilege_disabled") }})
        union
        ({{ daemonset_container_privilege_escalation_disabled('nsa_cisa_v1',"daemonset_container_privilege_escalation_disabled") }})
        union
        ({{ deployment_container_privilege_escalation_disabled('nsa_cisa_v1',"deployment_container_privilege_escalation_disabled") }})
        union
        ({{ job_container_privilege_escalation_disabled('nsa_cisa_v1',"job_container_privilege_escalation_disabled") }})
        union
        ({{ pod_host_network_access_disabled('nsa_cisa_v1',"pod_container_privilege_escalation_disabled") }})
        union
        ({{ replicaset_host_network_access_disabled('nsa_cisa_v1',"replicaset_container_privilege_escalation_disabled") }})
        union
        ({{ daemonset_host_network_access_disabled('nsa_cisa_v1',"daemonset_host_network_access_disabled") }})
        union
        ({{ deployment_host_network_access_disabled('nsa_cisa_v1',"deployment_host_network_access_disabled") }})
        union
        ({{ job_host_network_access_disabled('nsa_cisa_v1',"job_host_network_access_disabled") }})
        union
        ({{ daemonset_hostpid_hostipc_sharing_disabled('nsa_cisa_v1',"daemonset_hostpid_hostipc_sharing_disabled") }})
        union
        ({{ deployment_hostpid_hostipc_sharing_disabled('nsa_cisa_v1',"deployment_hostpid_hostipc_sharing_disabled") }})
        union
        ({{ job_hostpid_hostipc_sharing_disabled('nsa_cisa_v1',"job_hostpid_hostipc_sharing_disabled") }})
        union
        ({{ pod_hostpid_hostipc_sharing_disabled('nsa_cisa_v1',"pod_hostpid_hostipc_sharing_disabled") }})
        union
        ({{ replicaset_hostpid_hostipc_sharing_disabled('nsa_cisa_v1',"replicaset_hostpid_hostipc_sharing_disabled") }})
        union
        ({{ daemonset_immutable_container_filesystem('nsa_cisa_v1',"daemonset_immutable_container_filesystem") }})
        union
        ({{ deployment_immutable_container_filesystem('nsa_cisa_v1',"deployment_immutable_container_filesystem") }})
        union
        ({{ job_immutable_container_filesystem('nsa_cisa_v1',"job_immutable_container_filesystem") }})
        union
        ({{ pod_immutable_container_filesystem('nsa_cisa_v1',"pod_immutable_container_filesystem") }})
        union
        ({{ replicaset_immutable_container_filesystem('nsa_cisa_v1',"replicaset_immutable_container_filesystem") }})
        union
        ({{ daemonset_non_root_container('nsa_cisa_v1',"daemonset_non_root_container") }})
        union
        ({{ deployment_non_root_container('nsa_cisa_v1',"deployment_non_root_container") }})
        union
        ({{ job_non_root_container('nsa_cisa_v1',"job_non_root_container") }})
        union
        ({{ pod_non_root_container('nsa_cisa_v1',"pod_non_root_container") }})
        union
        ({{ replicaset_non_root_container('nsa_cisa_v1',"replicaset_non_root_container") }})
        union
        ({{ pod_service_account_token_disabled('nsa_cisa_v1',"pod_service_account_token_disabled") }})
        union
        ({{ service_account_token_disabled('nsa_cisa_v1',"service_account_token_disabled") }})
    )
select 
*
from aggregated
