{% macro emr_cluster_master_nodes_should_not_have_public_ip_addresses(framework, check_id) %}
  {{ return(adapter.dispatch('emr_cluster_master_nodes_should_not_have_public_ip_addresses')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__emr_cluster_master_nodes_should_not_have_public_ip_addresses(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'EMR clusters should not have public IP addresses' as title,
    aws_emr_clusters.account_id,
    aws_emr_clusters.arn as resource_id,
    case when aws_ec2_subnets.map_public_ip_on_launch and aws_emr_clusters.status:State in ('RUNNING', 'WAITING') then 'fail'
    else 'pass' end as status
from
    aws_emr_clusters
left outer join aws_ec2_subnets
    on aws_emr_clusters.ec2_instance_attributes:Ec2SubnetId = aws_ec2_subnets.subnet_id
{% endmacro %}

{% macro postgres__emr_cluster_master_nodes_should_not_have_public_ip_addresses(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'EMR clusters should not have public IP addresses' as title,
    aws_emr_clusters.account_id,
    aws_emr_clusters.arn as resource_id,
    case when aws_ec2_subnets.map_public_ip_on_launch and aws_emr_clusters.status->>'State' in ('RUNNING', 'WAITING') then 'fail'
    else 'pass' end as status
from
    aws_emr_clusters
left outer join aws_ec2_subnets
    on aws_emr_clusters.ec2_instance_attributes->>'Ec2SubnetId' = aws_ec2_subnets.subnet_id
{% endmacro %}

{% macro default__emr_cluster_master_nodes_should_not_have_public_ip_addresses(framework, check_id) %}{% endmacro %}

{% macro bigquery__emr_cluster_master_nodes_should_not_have_public_ip_addresses(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'EMR clusters should not have public IP addresses' as title,
    aws_emr_clusters.account_id,
    aws_emr_clusters.arn as resource_id,
    case when aws_ec2_subnets.map_public_ip_on_launch and JSON_VALUE(aws_emr_clusters.status.State) in ('RUNNING', 'WAITING') then 'fail'
    else 'pass' end as status
from
    {{ full_table_name("aws_emr_clusters") }}
left outer join {{ full_table_name("aws_ec2_subnets") }}
    on JSON_VALUE(aws_emr_clusters.ec2_instance_attributes.Ec2SubnetId) = aws_ec2_subnets.subnet_id
{% endmacro %}

{% macro athena__emr_cluster_master_nodes_should_not_have_public_ip_addresses(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'EMR clusters should not have public IP addresses' as title,
    aws_emr_clusters.account_id,
    aws_emr_clusters.arn as resource_id,
    case when aws_ec2_subnets.map_public_ip_on_launch and json_extract_scalar(aws_emr_clusters.status, '$.State') in ('RUNNING', 'WAITING') then 'fail'
    else 'pass' end as status
from
    aws_emr_clusters
left outer join aws_ec2_subnets
    on json_extract_scalar(aws_emr_clusters.ec2_instance_attributes, '$.Ec2SubnetId') = aws_ec2_subnets.subnet_id
{% endmacro %}