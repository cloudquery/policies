with
    aggregated as (
    ({{ networks_acls_ingress_rules() }})
    )
select * from aggregated
