{% macro both_vpn_channels_should_be_up(framework, check_id) %}
wITH TunnelStatus AS (
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