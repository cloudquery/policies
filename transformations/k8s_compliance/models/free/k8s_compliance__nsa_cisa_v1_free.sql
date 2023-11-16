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
    )
select 
*
from aggregated
