with
    aggregated as (
    {{unused_route53_histed_zones()}}
    {{ union() }}
    {{unused_backup_vaults()}}
    {{ union() }}
    {{unused_cloudfront_distributions()}}
    {{ union() }}
    {{unused_directconntect_connections()}}
    {{ union() }}
    {{unused_dynamodb_tables()}}
    {{ union() }}
    {{unused_ec2_ebs_volumes()}}
    {{ union() }}
    {{unused_ec2_eips()}}
    {{ union() }}
    {{unused_ec2_hosts()}}
    {{ union() }}
    {{unused_ec2_images()}}
    {{ union() }}
    -- depends_on: {{ ref('aws_cost__by_resources') }}
    {{unused_ec2_internet_gateways()}}
    {{ union() }}
    -- depends_on: {{ ref('aws_cost__by_resources') }}
    {{unused_ec2_network_acls()}}
    {{ union() }}
    {{unused_ec2_transit_gateways()}}
    {{ union() }}
    {{unused_ecr_repositories()}}
    {{ union() }}
    {{unused_efs_filesystems()}}
    {{ union() }}
    {{unused_lightsail_container_services()}}
    {{ union() }}
    {{unused_lightsail_disks()}}
    {{ union() }}
    {{unused_lightsail_distributions()}}
    {{ union() }}
    {{unused_lightsail_load_balancers()}}
    {{ union() }}
    {{unused_lightsail_static_ips()}}
    {{ union() }}
    {{unused_load_balancers()}}
    {{ union() }}
    {{unused_route53_histed_zones()}}
    {{ union() }}
    {{unused_sns_topics()}}
    )
select 
        {{ gen_timestamp() }},
        aggregated.*
from aggregated 