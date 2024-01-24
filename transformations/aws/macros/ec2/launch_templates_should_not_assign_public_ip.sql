{% macro launch_templates_should_not_assign_public_ip(framework, check_id) %}
  {{ return(adapter.dispatch('launch_templates_should_not_assign_public_ip')(framework, check_id)) }}
{% endmacro %}

{% macro default__launch_templates_should_not_assign_public_ip(framework, check_id) %}{% endmacro %}

{% macro postgres__launch_templates_should_not_assign_public_ip(framework, check_id) %}
WITH FlattenedData AS (
    SELECT
        account_id,
        arn,
        flat_interfaces.value as interface
    FROM
        aws_ec2_launch_template_versions,
	JSONB_ARRAY_ELEMENTS(launch_template_data->'networkInterfaceSet') as flat_interfaces
   WHERE default_version
)

SELECT
    DISTINCT
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Amazon EC2 launch templates should not assign public IPs to network interfaces' as title,
    FlattenedData.account_id,
    FlattenedData.arn as resource_id,
    CASE
    WHEN association ->> 'publicIp' is not null
        OR (interface ->> 'associatePublicIpAddress')::BOOLEAN = TRUE THEN 'fail'
    ELSE 'pass'
    END as status 
FROM
    FlattenedData
LEFT JOIN
    aws_ec2_network_interfaces
        ON interface ->> 'networkInterfaceId' = aws_ec2_network_interfaces.network_interface_id
{% endmacro %}

{% macro snowflake__launch_templates_should_not_assign_public_ip(framework, check_id) %}
WITH FlattenedData AS (
    SELECT
        account_id,
        arn,
        flat_interfaces.value as interface
    FROM
        aws_ec2_launch_template_versions
   JOIN LATERAL FLATTEN(input => launch_template_data:networkInterfaceSet) as flat_interfaces
   WHERE default_version
)

SELECT
    DISTINCT
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Amazon EC2 launch templates should not assign public IPs to network interfaces' as title,
    FlattenedData.account_id,
    FlattenedData.arn as resource_id,
    CASE
    WHEN association:publicIp is not null
        OR interface:associatePublicIpAddress::BOOLEAN = TRUE THEN 'fail'
    ELSE 'pass'
    END as status 
FROM
    FlattenedData
LEFT JOIN
    aws_ec2_network_interfaces
        ON interface:networkInterfaceId = aws_ec2_network_interfaces.network_interface_id
{% endmacro %}

{% macro bigquery__launch_templates_should_not_assign_public_ip(framework, check_id) %}
WITH FlattenedData AS (
    SELECT
        account_id,
        arn,
        flat_interfaces.value as interface
    FROM
        {{ full_table_name("aws_ec2_launch_template_versions") }},
        UNNEST(JSON_QUERY_ARRAY(launch_template_data.networkInterfaceSet)) AS flat_interfaces
   WHERE default_version
)

SELECT
    DISTINCT
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Amazon EC2 launch templates should not assign public IPs to network interfaces' as title,
    FlattenedData.account_id,
    FlattenedData.arn as resource_id,
    CASE
    WHEN association.publicIp is not null
        OR CAST( JSON_VALUE(interface.associatePublicIpAddress) AS BOOL) = TRUE THEN 'fail'
    ELSE 'pass'
    END as status 
FROM
    FlattenedData
LEFT JOIN
    {{ full_table_name("aws_ec2_network_interfaces") }}
        ON JSON_VALUE(interface.networkInterfaceId) = aws_ec2_network_interfaces.network_interface_id
{% endmacro %}