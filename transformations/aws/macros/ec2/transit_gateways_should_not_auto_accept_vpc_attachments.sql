{% macro transit_gateways_should_not_auto_accept_vpc_attachments(framework, check_id) %}
  {{ return(adapter.dispatch('transit_gateways_should_not_auto_accept_vpc_attachments')(framework, check_id)) }}
{% endmacro %}

{% macro default__transit_gateways_should_not_auto_accept_vpc_attachments(framework, check_id) %}{% endmacro %}

{% macro postgres__transit_gateways_should_not_auto_accept_vpc_attachments(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Amazon EC2 Transit Gateways should not automatically accept VPC attachment requests' as title,
    account_id,
    arn as resource_id,
    CASE
    WHEN options ->> 'AutoAcceptSharedAttachments' = 'enable' THEN 'fail'
    ELSE 'pass'
    END as status
FROM aws_ec2_transit_gateways
{% endmacro %}

{% macro snowflake__transit_gateways_should_not_auto_accept_vpc_attachments(framework, check_id) %}
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

{% macro bigquery__transit_gateways_should_not_auto_accept_vpc_attachments(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Amazon EC2 Transit Gateways should not automatically accept VPC attachment requests' as title,
    account_id,
    arn as resource_id,
    CASE
    WHEN JSON_VALUE(options.AutoAcceptSharedAttachments) = 'enable' THEN 'fail'
    ELSE 'pass'
    END as status
FROM {{ full_table_name("aws_ec2_transit_gateways") }}
{% endmacro %}

{% macro athena__transit_gateways_should_not_auto_accept_vpc_attachments(framework, check_id) %}
select
    '{{framework}}' AS framework,
    '{{check_id}}' AS check_id,
    'Amazon EC2 Transit Gateways should not automatically accept VPC attachment requests' as title,
    account_id,
    arn as resource_id,
    CASE
    WHEN JSON_EXTRACT_SCALAR(options, '$.AutoAcceptSharedAttachments') = '"enable"' THEN 'fail'
    ELSE 'pass'
    END as status
from aws_ec2_transit_gateways
{% endmacro %}
