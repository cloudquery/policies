{% macro network_acls_should_not_allow_ingress_for_ssh_rdp_ports(framework, check_id) %}
  {{ return(adapter.dispatch('network_acls_should_not_allow_ingress_for_ssh_rdp_ports')(framework, check_id)) }}
{% endmacro %}

{% macro default__network_acls_should_not_allow_ingress_for_ssh_rdp_ports(framework, check_id) %}{% endmacro %}

{% macro postgres__network_acls_should_not_allow_ingress_for_ssh_rdp_ports(framework, check_id) %}
WITH bad_entries as (
SELECT
    DISTINCT
    arn
FROM 
    aws_ec2_network_acls,
	JSONB_ARRAY_ELEMENTS(entries) as entry
WHERE 
    entry.value ->> 'Egress' = 'false'
    AND entry.value ->> 'Protocol' = '6'
    AND entry.value ->> 'RuleAction' = 'allow'
    AND (
        (entry.value -> 'PortRange' ->> 'From')::INTEGER IN (22, 3389) 
        OR (entry.value -> 'PortRange' ->> 'To')::INTEGER IN (22, 3389)
    )
    AND (
        entry.value ->> 'CidrBlock' = '0.0.0.0/0' 
        OR entry.value ->> 'Ipv6CidrBlock' = '::/0'
)
)
SELECT
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Network ACLs should not allow ingress from 0.0.0.0/0 to port 22 or port 3389' as title,
    a.account_id,
    a.arn as resource_id,
    CASE
        WHEN b.arn is not null THEN 'fail'
        ELSE 'pass'
    END as status
FROM
    aws_ec2_network_acls a
LEFT JOIN bad_entries b
    ON a.arn = b.arn
{% endmacro %}

{% macro snowflake__network_acls_should_not_allow_ingress_for_ssh_rdp_ports(framework, check_id) %}
WITH bad_entries as (
SELECT
    DISTINCT
    arn
FROM 
    aws_ec2_network_acls,
    LATERAL FLATTEN(input => entries) AS entry
WHERE 
    entry.value:Egress::STRING = 'false'
    AND entry.value:Protocol::STRING = '6'
    AND entry.value:RuleAction::STRING = 'allow'
    AND (
        entry.value:PortRange:From::INTEGER IN (22, 3389) 
        OR entry.value:PortRange:To::INTEGER IN (22, 3389)
    )
    AND (
        entry.value:CidrBlock::STRING = '0.0.0.0/0' 
        OR entry.value:Ipv6CidrBlock::STRING = '::/0'
)
)
SELECT
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Network ACLs should not allow ingress from 0.0.0.0/0 to port 22 or port 3389' as title,
    a.account_id,
    a.arn as resource_id,
    CASE
        WHEN b.arn is not null THEN 'fail'
        ELSE 'pass'
    END as status
FROM
    aws_ec2_network_acls a
LEFT JOIN bad_entries b
    ON a.arn = b.arn
{% endmacro %}

{% macro bigquery__network_acls_should_not_allow_ingress_for_ssh_rdp_ports(framework, check_id) %}
WITH bad_entries as (
SELECT
    DISTINCT
    arn
FROM 
    {{ full_table_name("aws_ec2_network_acls") }},
UNNEST(JSON_QUERY_ARRAY(entries)) AS entry
WHERE 
    CAST(JSON_VALUE(entry.Egress) AS STRING) = 'false'
    AND CAST(JSON_VALUE(entry.Protocol) AS STRING) = '6'
    AND CAST(JSON_VALUE(entry.RuleAction) AS STRING) = 'allow'
    AND (
        CAST(JSON_VALUE(entry.PortRange.From) AS INT64) IN (22, 3389) 
        OR CAST(JSON_VALUE(entry.PortRange.To) AS INT64) IN (22, 3389)
    )
    AND (
        CAST(JSON_VALUE(entry.CidrBlock) AS STRING) = '0.0.0.0/0' 
        OR CAST(JSON_VALUE(entry.Ipv6CidrBlock) AS STRING) = '::/0'
)
)
SELECT
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Network ACLs should not allow ingress from 0.0.0.0/0 to port 22 or port 3389' as title,
    a.account_id,
    a.arn as resource_id,
    CASE
        WHEN b.arn is not null THEN 'fail'
        ELSE 'pass'
    END as status
FROM
    {{ full_table_name("aws_ec2_network_acls") }} a
LEFT JOIN bad_entries b
    ON a.arn = b.arn
{% endmacro %}