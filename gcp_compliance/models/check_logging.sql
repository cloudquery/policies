with
    aggregated as (
        {{ logging_audit_config_changes_without_log_metric_filter_alerts('cis_v1.2.0', '2.5') }}
        union
        {{ logging_custom_role_changes_without_log_metric_filter_alerts('cis_v1.2.0', '2.6') }}
        union
        {{ logging_dns_logging_disabled('cis_v1.2.0', '2.12') }}
        union
        {{ logging_log_buckets_retention_policy_disabled('cis_v1.2.0', '2.3') }}
        union
        {{ logging_project_ownership_changes_without_log_metric_filter_alerts('cis_v1.2.0', '2.4') }}
        union
        {{ logging_sql_instance_changes_without_log_metric_filter_alerts('cis_v1.2.0', '2.11') }}
        union
        {{ logging_storage_iam_changes_without_log_metric_filter_alerts('cis_v1.2.0', '2.10') }}
        union
        {{ logging_vpc_firewall_changes_without_log_metric_filter_alerts('cis_v1.2.0', '2.7') }}
        union
        {{ logging_vpc_network_changes_without_log_metric_filter_alerts('cis_v1.2.0', '2.9') }}
        union
        {{ logging_vpc_route_changes_without_log_metric_filter_alerts('cis_v1.2.0', '2.8') }}
    )

select * from aggregated
