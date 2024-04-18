with
    aggregated as (
    ({{ account_level_public_access_blocks('foundational_security','s3.1') }})
     {{ union() }}
    ({{ default_sg_no_access('foundational_security','ec2.2') }})
             )
select 
        {{ gen_timestamp() }},
        aggregated.*
from aggregated
