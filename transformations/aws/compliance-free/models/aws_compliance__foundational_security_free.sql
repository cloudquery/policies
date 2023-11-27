{{ config(enabled=is_snowflake()) }}

with
    aggregated as (
        {{ access_logs_enabled('foundational_security','cloudfront.5') }}
        union
        ({{ access_point_enforce_user_identity('foundational_security','efs.4') }})
        union
        ({{ access_point_path_should_not_be_root('foundational_security','efs.3') }})
        union
        ({{ account_level_public_access_blocks('foundational_security','s3.1') }})
        union
        ({{ advanced_health_reporting_enabled('foundational_security','elastic_beanstalk.1') }})
        union
        ({{ alb_deletion_protection_enabled('foundational_security','elb.6') }})
        union
        ({{ alb_drop_http_headers('foundational_security','elb.4') }})
        union
        ({{ alb_logging_enabled('foundational_security','elb.5') }})
        union
        ({{ amazon_aurora_clusters_should_have_backtracking_enabled('foundational_security','rds.14') }})
        union
        ({{ api_gw_access_logging_should_be_configured('foundational_security','apigateway.9') }})
        union
        ({{ api_gw_associated_wth_waf('foundational_security','apigateway.4') }})
        union
        ({{ api_gw_cache_data_encrypted('foundational_security','apigateway.5') }})
        union
        ({{ api_gw_execution_logging_enabled('foundational_security','apigateway.1') }})
        union
        ({{ api_gw_routes_should_specify_authorization_type('foundational_security','apigateway.8') }})
    )
select 
        ('{{ run_started_at }}')::timestamp as policy_execution_time,
        aggregated.*
from aggregated
