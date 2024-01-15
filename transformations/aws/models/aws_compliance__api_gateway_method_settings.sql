with
    aggregated as (
    ({{ api_gateway_method_settings() }})
    )
select * from aggregated