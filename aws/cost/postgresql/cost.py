RESOURCES_BY_COST = """
CREATE OR REPLACE VIEW resources_by_cost as
SELECT
  line_item_resource_id,
  line_item_product_code,
  sum(line_item_blended_cost) AS cost
FROM {table}
WHERE line_item_resource_id !=''
GROUP BY line_item_resource_id, line_item_product_code
HAVING sum(line_item_blended_cost) > 0
ORDER BY cost DESC;
"""

REGIONS_BY_COST = """
CREATE OR REPLACE VIEW regions_by_cost as
SELECT
  product_location,
  sum(line_item_blended_cost) AS cost
FROM {table}
WHERE line_item_resource_id !='' and product_location_type = 'AWS Region'
GROUP BY product_location
HAVING sum(line_item_blended_cost) > 0
ORDER BY cost DESC;
"""

COST_OVER_TIME = """
CREATE OR REPLACE VIEW cost_over_time as
SELECT
  line_item_usage_start_date,
  line_item_usage_end_date,
  sum(line_item_blended_cost) AS cost
FROM {table}
WHERE line_item_resource_id !='' and product_location_type = 'AWS Region'
GROUP BY line_item_usage_start_date, line_item_usage_end_date
HAVING sum(line_item_blended_cost) > 0
ORDER BY line_item_usage_start_date asc;
"""

GCP2_EBS_VOLUMES = """
CREATE OR REPLACE VIEW gcp2_ebs_volumes as
SELECT
  costquery.line_item_resource_id,
  costquery.cost,
  vols.volume_type,
  vols.attachments,
  vols.arn,
  vols.tags,
  vols.state,
  vols.snapshot_id,
  vols.size,
  vols.create_time
FROM (
	SELECT
	  line_item_resource_id, line_item_product_code,
    SUM(line_item_blended_cost) AS cost
	FROM {table}
	WHERE
    line_item_resource_id LIKE 'vol-%'
	GROUP BY
    line_item_resource_id, line_item_product_code
	HAVING SUM(line_item_blended_cost) > 0
	ORDER BY cost DESC
) as costquery
LEFT JOIN "aws_ec2_ebs_volumes" as vols
ON costquery.line_item_resource_id = vols.volume_id
WHERE vols.volume_type = 'gp2'
"""

UNUSED_ACM_CERTS = """
CREATE OR REPLACE VIEW unused_acm_certs_cost AS
select
       c.account_id,
       c.arn                      as resource_id,
       rbc.cost
from aws_acm_certificates c
JOIN resources_by_cost rbc ON c.arn = rbc.line_item_resource_id 
where array_length(c.in_use_by, 1) = 0
"""

UNUSED_BACKUP_VAULTS = """
CREATE OR REPLACE VIEW unused_backup_vaults_cost AS
with point as (
    select distinct vault_arn 
    from aws_backup_vault_recovery_points
    ),
    unused_vaults as (
select
       vault.account_id,
       vault.arn                        as resource_id
from aws_backup_vaults vault
         left join point on point.vault_arn = vault.arn
where point.vault_arn is null)

SELECT 
    uv.account_id,
    uv.resource_id,
    rbc.cost
FROM unused_vaults uv
JOIN resources_by_cost rbc ON uv.resource_id = rbc.line_item_resource_id;
"""

UNUSED_CLOUDFRONT_DISTRIBUTIONS = """
CREATE OR REPLACE VIEW unused_cloudfront_distribution_cost AS
select
       d.account_id,
       d.arn                                as resource_id,
       rbc.cost
from aws_cloudfront_distributions d
JOIN resources_by_cost rbc ON d.arn = rbc.line_item_resource_id 
where (d.distribution_config->>'Enabled')::boolean is distinct from true;
"""

UNUSED_DIRECTCONNTECT_CONNECTIONS = """
CREATE OR REPLACE VIEW unused_directconnect_connections_cost AS
select 
       dc.account_id,
       dc.arn                                          as resource_id,
       rbc.cost
from aws_directconnect_connections dc
JOIN resources_by_cost rbc ON dc.arn = rbc.line_item_resource_id 
where dc.connection_state = 'down';
"""

UNUSED_DYNAMODB_TABLES = """
CREATE OR REPLACE VIEW unused_dynamodb_tables_cost AS
select 
       ddb.account_id,
       ddb.arn                            as resource_id,
       rbc.cost
from aws_dynamodb_tables ddb
JOIN resources_by_cost rbc ON ddb.arn = rbc.line_item_resource_id 
where ddb.item_count = 0;
"""

UNUSED_EC2_EBS_VOLUMES = """
CREATE OR REPLACE VIEW unused_ec2_ebs_volumes_cost AS
select 
       ev.account_id,
       ev.arn            as resource_id,
       rbc.cost
from aws_ec2_ebs_volumes ev
JOIN resources_by_cost rbc ON ev.arn = rbc.line_item_resource_id 
where coalesce(jsonb_array_length(ev.attachments), 0) = 0;
"""

UNUSED_EC2_EIPS = """
CREATE OR REPLACE VIEW unused_ec2_eips_cost AS
select 
       eips.account_id,
       eips.allocation_id     as resource_id,
       rbc.cost
from aws_ec2_eips eips
JOIN resources_by_cost rbc ON eips.allocation_id = rbc.line_item_resource_id 
where eips.association_id is null;
"""

UNUSED_EC2_HOSTS = """
CREATE OR REPLACE VIEW unused_ec2_hosts_cost AS
select 
       h.account_id,
       h.arn                     as resource_id,
       rbc.cost
from aws_ec2_hosts h
JOIN resources_by_cost rbc ON h.arn = rbc.line_item_resource_id 
where coalesce(jsonb_array_length(h.instances), 0) = 0;
"""

UNUSED_EC2_IMAGES = """
CREATE OR REPLACE VIEW unused_ec2_images_cost AS
select 
       i.account_id,
       i.arn                    as resource_id,
       rbc.cost
from aws_ec2_images i
JOIN resources_by_cost rbc ON i.arn = rbc.line_item_resource_id 
where coalesce(jsonb_array_length(i.block_device_mappings), 0) = 0;
"""

UNUSED_EC2_INTERNET_GATEWAYS = """
CREATE OR REPLACE VIEW unused_ec2_internet_gateways_cost AS
select 
       ig.account_id,
       ig.arn                       as resource_id,
       rbc.cost
from aws_ec2_internet_gateways ig
JOIN resources_by_cost rbc ON ig.arn = rbc.line_item_resource_id 
where coalesce(jsonb_array_length(ig.attachments), 0) = 0;
"""

UNUSED_EC2_NETWORK_ACLS = """
CREATE OR REPLACE VIEW unused_ec2_network_acls_cost AS
select 
       a.account_id,
       a.arn                                  as resource_id,
       rbc.cost
from aws_ec2_network_acls a
JOIN resources_by_cost rbc ON a.arn = rbc.line_item_resource_id
where coalesce(jsonb_array_length(a.associations), 0) = 0;
"""

UNUSED_EC2_TRANSIT_GATEWAYS = """
CREATE OR REPLACE VIEW unused_ec2_transit_gateways_cost AS
with attachment as (select distinct transit_gateway_arn from aws_ec2_transit_gateway_attachments),
unused_transit_gateways as (
select 
       gateway.account_id,
       gateway.arn              as resource_id
from aws_ec2_transit_gateways gateway
         left join attachment on attachment.transit_gateway_arn = gateway.arn
where attachment.transit_gateway_arn is null)
SELECT 
    ug.account_id,
    ug.resource_id,
    rbc.cost
FROM unused_transit_gateways ug
JOIN resources_by_cost rbc ON ug.resource_id = rbc.line_item_resource_id;
"""

UNUSED_ECR_REPOSITORIES = """
CREATE OR REPLACE VIEW unused_ecr_repositories_cost AS
with image as (select distinct account_id, repository_name from aws_ecr_repository_images),
unused_repo as (
select 
       repository.account_id,
       repository.arn          as resource_id
from aws_ecr_repositories repository
         left join image on image.account_id = repository.account_id and image.repository_name = repository.repository_name
where image.repository_name is null)
SELECT 
    ur.account_id,
    ur.resource_id,
    rbc.cost
FROM unused_repo ur
JOIN resources_by_cost rbc ON ur.resource_id = rbc.line_item_resource_id;
"""

UNUSED_EFS_FILESYSTEMS = """
CREATE OR REPLACE VIEW unused_efs_filesystems_cost AS
select 
       fs.account_id,
       fs.arn                     as resource_id,
       rbc.cost
from aws_efs_filesystems fs
JOIN resources_by_cost rbc ON fs.arn = rbc.line_item_resource_id
where fs.number_of_mount_targets = 0;
"""

UNUSED_LOAD_BALANCERS = """
CREATE OR REPLACE VIEW unused_load_balancers_cost AS
with listener as (select distinct load_balancer_arn from aws_elbv2_listeners),
     target_group as (select distinct unnest(load_balancer_arns) as load_balancer_arn
                      from aws_elbv2_target_groups),
lb_unused AS (
select 
       lb.account_id,
       lb.arn                     as resource_id
       from aws_elbv2_load_balancers lb
         left join listener on listener.load_balancer_arn = lb.arn
         left join target_group on target_group.load_balancer_arn = lb.arn
where listener.load_balancer_arn is null
   or target_group.load_balancer_arn is null)
SELECT 
    lb.account_id,
    lb.resource_id,
    rbc.cost
FROM lb_unused lb
JOIN resources_by_cost rbc ON lb.resource_id = rbc.line_item_resource_id;
"""

UNUSED_LIGHTSAIL_CONTAINER_SERVICES = """
CREATE OR REPLACE VIEW unused_lightsail_container_services_cost AS
with deployment as (select distinct container_service_arn from aws_lightsail_container_service_deployments),
unused_cs AS (
select 
       cs.account_id,
       cs.arn                                as resource_id
from aws_lightsail_container_services cs
         left join deployment on deployment.container_service_arn = cs.arn
where deployment.container_service_arn is null)
SELECT 
    cs.account_id,
    cs.resource_id,
    rbc.cost
FROM unused_cs cs
JOIN resources_by_cost rbc ON cs.resource_id = rbc.line_item_resource_id;
"""

UNUSED_LIGHTSAIL_DISKS = """
CREATE OR REPLACE VIEW unused_lightsail_disks_cost AS
select 
       d.account_id,
       d.arn                      as resource_id,
       rbc.cost
from aws_lightsail_disks d
JOIN resources_by_cost rbc ON d.arn = rbc.line_item_resource_id
where d.is_attached = false;

"""

UNUSED_LIGHTSAIL_DISTRIBUTIONS = """
CREATE OR REPLACE VIEW unused_lightsail_distributions_cost AS
select 
       d.account_id,
       d.arn                                as resource_id,
       rbc.cost
from aws_lightsail_distributions d
JOIN resources_by_cost rbc ON d.arn = rbc.line_item_resource_id
where d.is_enabled = false;
"""

UNUSED_LIGHTSAIL_LOAD_BALANCERS = """
CREATE OR REPLACE VIEW unused_lightsail_load_balancers_cost AS
select 
       lb.account_id,
       lb.arn                               as resource_id,
       rbc.cost
from aws_lightsail_load_balancers lb
JOIN resources_by_cost rbc ON lb.arn = rbc.line_item_resource_id
where coalesce(jsonb_array_length(lb.instance_health_summary), 0) = 0;
"""

UNUSED_LIGHTSAIL_STATIC_IPS = """
CREATE OR REPLACE VIEW unused_lightsail_static_ips_cost AS
select 
       si.account_id,
       si.arn                           as resource_id,
       rbc.cost
from aws_lightsail_static_ips si
JOIN resources_by_cost rbc ON si.arn = rbc.line_item_resource_id
where si.is_attached = false;
"""

UNUSED_ROUTE53_HISTED_ZONES = """
CREATE OR REPLACE VIEW unused_route53_hosted_zones_cost AS
select 
       hz.account_id,
       hz.arn                            as resource_id,
       rbc.cost
from aws_route53_hosted_zones hz
JOIN resources_by_cost rbc ON hz.arn = rbc.line_item_resource_id
where hz.resource_record_set_count = 0;
"""

UNUSED_SNS_TOPICS = """
CREATE OR REPLACE VIEW unused_sns_topics_cost AS
with subscription as (select distinct topic_arn from aws_sns_subscriptions),
unused_topics as (
select 
       topic.account_id,
       topic.arn          as resource_id

from aws_sns_topics topic
         left join subscription on subscription.topic_arn = topic.arn
where subscription.topic_arn is null)
SELECT 
    ut.account_id,
    ut.resource_id,
    rbc.cost
FROM unused_topics ut
JOIN resources_by_cost rbc ON ut.resource_id = rbc.line_item_resource_id;
"""
