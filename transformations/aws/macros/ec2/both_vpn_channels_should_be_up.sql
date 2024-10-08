{% macro both_vpn_channels_should_be_up(framework, check_id) %}
  {{ return(adapter.dispatch('both_vpn_channels_should_be_up')(framework, check_id)) }}
{% endmacro %}

{% macro default__both_vpn_channels_should_be_up(framework, check_id) %}{% endmacro %}

{% macro postgres__both_vpn_channels_should_be_up(framework, check_id) %}
WITH TunnelStatus AS (
    SELECT
        distinct c.vpn_connection_id,
        COUNT(CASE WHEN t ->> 'Status' = 'UP' THEN 1 END) OVER(PARTITION BY c.vpn_connection_id) as up_count
    FROM
        aws_ec2_vpn_connections c,
		JSONB_ARRAY_ELEMENTS(vgw_telemetry) as t
)

SELECT
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Both VPN tunnels for an AWS Site-to-Site VPN connection should be up' as title,
    c.account_id,
    'arn:aws:ec2:' || c.region || ':' || c.account_id || ':vpn-connection/' || c.vpn_connection_id AS resource_id,
    CASE
        WHEN t.up_count >= 2 THEN 'pass'
        ELSE 'fail'
    END as status
FROM
    aws_ec2_vpn_connections c
LEFT JOIN TunnelStatus t ON c.vpn_connection_id = t.vpn_connection_id
{% endmacro %}

{% macro snowflake__both_vpn_channels_should_be_up(framework, check_id) %}
WITH TunnelStatus AS (
    SELECT
        distinct c.vpn_connection_id,
        COUNT_IF(t.value:Status::text = 'UP') OVER(PARTITION BY c.vpn_connection_id) as up_count
    FROM
        aws_ec2_vpn_connections c,
        LATERAL FLATTEN(input => c.vgw_telemetry) t
)

SELECT
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Both VPN tunnels for an AWS Site-to-Site VPN connection should be up' as title,
    c.account_id,
    'arn:aws:ec2:' || c.region || ':' || c.account_id || ':vpn-connection/' || c.vpn_connection_id AS resource_id,
    CASE
        WHEN t.up_count >= 2 THEN 'pass'
        ELSE 'fail'
    END as status
FROM
    aws_ec2_vpn_connections c
LEFT JOIN TunnelStatus t ON c.vpn_connection_id = t.vpn_connection_id
{% endmacro %}

{% macro bigquery__both_vpn_channels_should_be_up(framework, check_id) %}
WITH TunnelStatus AS (
    SELECT
        distinct c.vpn_connection_id,
        countif(CAST(JSON_VALUE(t.Status) AS STRING) = 'UP') OVER(PARTITION BY c.vpn_connection_id) as up_count
    FROM
        {{ full_table_name("aws_ec2_vpn_connections") }} c,
        UNNEST(JSON_QUERY_ARRAY(c.vgw_telemetry)) AS t
)

SELECT
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Both VPN tunnels for an AWS Site-to-Site VPN connection should be up' as title,
    c.account_id,
    'arn:aws:ec2:' || c.region || ':' || c.account_id || ':vpn-connection/' || c.vpn_connection_id AS resource_id,
    CASE
        WHEN t.up_count >= 2 THEN 'pass'
        ELSE 'fail'
    END as status
FROM
    {{ full_table_name("aws_ec2_vpn_connections") }} c
LEFT JOIN TunnelStatus t ON c.vpn_connection_id = t.vpn_connection_id
{% endmacro %}

{% macro athena__both_vpn_channels_should_be_up(framework, check_id) %}
select * from (
WITH TunnelStatus AS (
    SELECT
        vpn_connection_id,
        COUNT(CASE WHEN JSON_EXTRACT_SCALAR(t.Status, '$') = 'UP' THEN 1 END) OVER (PARTITION BY vpn_connection_id) as up_count
    FROM
        aws_ec2_vpn_connections,
        UNNEST(CAST(json_parse(vgw_telemetry) AS array(json))) AS t (Status)
)

SELECT
    '{{framework}}' AS framework,
    '{{check_id}}' AS check_id,
    'Both VPN tunnels for an AWS Site-to-Site VPN connection should be up' AS title,
    account_id,
    CONCAT('arn:aws:ec2:', region, ':', account_id, ':vpn-connection/', aws_ec2_vpn_connections.vpn_connection_id) AS resource_id,
    CASE
        WHEN up_count >= 2 THEN 'pass'
        ELSE 'fail'
    END AS status
FROM
    aws_ec2_vpn_connections
LEFT JOIN TunnelStatus ON aws_ec2_vpn_connections.vpn_connection_id = TunnelStatus.vpn_connection_id
)
{% endmacro %}