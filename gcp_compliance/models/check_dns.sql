with
    aggregated as (
        {{ dns_key_signing_with_rsasha1('cis_v1.2.0', '3.4') }}
        union
        {{ dns_zone_signing_with_rsasha1('cis_v1.2.0', '3.5') }}
        union
        {{ dns_zones_with_dnssec_disabled('cis_v1.2.0', '3.3') }}
    )

select * from aggregated
