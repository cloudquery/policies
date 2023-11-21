with
    aggregated as (
        ({{ autoscaling_groups_elb_check('pci_dss_v3.2.1','autoscaling.1') }})
        UNION
        ({{ logs_encrypted('pci_dss_v3.2.1','cloudtrail.1') }})
        UNION
        ({{ cloudtrail_enabled_all_regions('pci_dss_v3.2.1','cloudtrail.2') }})
        UNION
        ({{ log_file_validation_enabled('pci_dss_v3.2.1','cloudtrail.3') }})
        UNION
        ({{ integrated_with_cloudwatch_logs('pci_dss_v3.2.1','cloudtrail.4') }})
        UNION
        ({{ check_oauth_usage_for_sources('pci_dss_v3.2.1','codebuild.1') }})
        UNION
        ({{ check_environment_variables('pci_dss_v3.2.1','codebuild.2') }})
        UNION
        ({{ config_enabled_all_regions('pci_dss_v3.2.1','config.1') }})   
    )
select 
        ('{{ run_started_at }}')::timestamp as policy_execution_time,
        aggregated.*
from aggregated
