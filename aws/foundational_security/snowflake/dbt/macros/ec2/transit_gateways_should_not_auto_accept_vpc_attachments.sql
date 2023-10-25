{% macro transit_gateways_should_not_auto_accept_vpc_attachments(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Amazon EC2 Transit Gateways should not automatically accept VPC attachment requests' as title,
    account_id,
    arn as resource_id,
    CASE
    WHEN options:AutoAcceptSharedAttachments = 'enable' THEN 'fail'
    ELSE 'pass'
    END as status
FROM aws_ec2_transit_gateways
{% endmacro %}