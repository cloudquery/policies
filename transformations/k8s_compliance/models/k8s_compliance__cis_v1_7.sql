with
    aggregated as (
        {{ anonymous_auth_disabled('Kubernetes CIS v1.7.0','api_server_1.2.1') }}
        union

    )
select 
*
from aggregated
