with
    aggregated as (
        ({{ security_account_information_provided('test-framework','check') }})        
    )
select 
*
from aggregated
