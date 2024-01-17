with
    aggregated as (
        ({{ api_server_1_2_1('Kubernetes CIS v1.7.0','api_server_1_2_1') }})
        union
        ({{ api_server_1_2_2('Kubernetes CIS v1.7.0','api_server_1_2_2') }})
        union
        ({{ api_server_1_2_3('Kubernetes CIS v1.7.0','api_server_1_2_3') }})
        union
        ({{ api_server_1_2_4('Kubernetes CIS v1.7.0','api_server_1_2_4') }})
        union
        ({{ api_server_1_2_5('Kubernetes CIS v1.7.0','api_server_1_2_5') }})
        union
        ({{ api_server_1_2_6('Kubernetes CIS v1.7.0','api_server_1_2_6') }})
        union
        ({{ api_server_1_2_7('Kubernetes CIS v1.7.0','api_server_1_2_7') }})
        union
        ({{ api_server_1_2_8('Kubernetes CIS v1.7.0','api_server_1_2_8') }})
    )
select 
        ('{{ run_started_at }}')::timestamp as policy_execution_time,
        aggregated.*
from aggregated
