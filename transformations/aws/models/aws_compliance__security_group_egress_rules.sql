with
    aggregated as (
    ({{ security_group_egress_rules() }})
    )
select * from aggregated