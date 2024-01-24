with
    aggregated as (
        ({{ autoscaling_groups_elb_check('pci_dss_v3.2.1','autoscaling.1') }})
        {{ union() }}
        ({{ logs_encrypted('pci_dss_v3.2.1','cloudtrail.1') }})
        {{ union() }}
        ({{ cloudtrail_enabled_all_regions('pci_dss_v3.2.1','cloudtrail.2') }})
        {{ union() }}
        ({{ log_file_validation_enabled('pci_dss_v3.2.1','cloudtrail.3') }})
        {{ union() }}
        ({{ integrated_with_cloudwatch_logs('pci_dss_v3.2.1','cloudtrail.4') }})
        {{ union() }}
        ({{ check_oauth_usage_for_sources('pci_dss_v3.2.1','codebuild.1') }})
        {{ union() }}
        ({{ check_environment_variables('pci_dss_v3.2.1','codebuild.2') }})
        {{ union() }}
        ({{ config_enabled_all_regions('pci_dss_v3.2.1','config.1') }})   
    )
select 
        {{ gen_timestamp() }},
        aggregated.*
from aggregated
