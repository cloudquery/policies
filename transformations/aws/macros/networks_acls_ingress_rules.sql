{% macro networks_acls_ingress_rules(framework, check_id) %}
  {{ return(adapter.dispatch('networks_acls_ingress_rules')()) }}
{% endmacro %}

{% macro default__networks_acls_ingress_rules() %}{% endmacro %}

{% macro postgres__networks_acls_ingress_rules() %}
WITH rules AS (SELECT aena.arn,
                      aena.account_id,
                      (jsonb_array_elements(entries) -> 'PortRange' ->> 'From')::int AS port_range_from,
                      (jsonb_array_elements(entries) -> 'PortRange' ->> 'To')::int   AS port_range_to,
                      jsonb_array_elements(entries) ->> 'Protocol'                   AS protocol,
                      jsonb_array_elements(entries) ->> 'CidrBlock'                  AS cidr_block,
                      jsonb_array_elements(entries) ->> 'Ipv6CidrBlock'              AS ipv6_cidr_block,
                      jsonb_array_elements(entries) ->> 'Egress'                     AS egress,
                      jsonb_array_elements(entries) ->> 'RuleAction'                 AS rule_action
               FROM aws_ec2_network_acls aena)
SELECT arn, account_id, port_range_from, port_range_to, protocol, cidr_block, ipv6_cidr_block
FROM rules
WHERE egress IS DISTINCT FROM 'true'
  AND rule_action = 'allow'
{% endmacro %}

{% macro snowflake__networks_acls_ingress_rules() %}
WITH rules AS (
  SELECT 
     aena.arn,
     aena.account_id,
     (v.value:PortRange:From)::int as port_range_from,
     (v.value:PortRange:To)::int as port_range_to,
     v.value:Protocol as protocol,
     v.value:CidrBlock as cidr_block,
     v.value:Ipv6CidrBlock as ipv6_cidr_block,
     v.value:Egress as egress,
     v.value:RuleAction as rule_action
FROM aws_ec2_network_acls aena,
LATERAL FLATTEN(ENTRIES) v
)
SELECT arn, account_id, port_range_from, port_range_to, protocol, cidr_block, ipv6_cidr_block
FROM rules
WHERE egress IS DISTINCT FROM 'true'
  AND rule_action = 'allow'
{% endmacro %}

{% macro bigquery__networks_acls_ingress_rules() %}
WITH rules AS (SELECT aena.arn,
                      aena.account_id,
                      CAST(JSON_VALUE(port_range_from) AS INT64) as port_range_from,
                      CAST(JSON_VALUE(port_range_to) AS INT64) as port_range_to,
                      JSON_VALUE(protocol) as protocol,
                      JSON_VALUE(cidr_block) as cidr_block,
                      JSON_VALUE(ipv6_cidr_block) as ipv6_cidr_block,
                      JSON_VALUE(egress) as egress,
                      JSON_VALUE(rule_action) as rule_action
               FROM {{ full_table_name("aws_ec2_network_acls") }} aena,
               UNNEST(JSON_QUERY_ARRAY(entries.PortRange.From)) AS port_range_from,
               UNNEST(JSON_QUERY_ARRAY(entries.PortRange.To)) AS port_range_to,
               UNNEST(JSON_QUERY_ARRAY(entries.Protocol)) AS protocol,
               UNNEST(JSON_QUERY_ARRAY(entries.CidrBlock)) AS cidr_block,
               UNNEST(JSON_QUERY_ARRAY(entries.Ipv6CidrBlock)) AS ipv6_cidr_block,
               UNNEST(JSON_QUERY_ARRAY(entries.Egress)) AS egress,
               UNNEST(JSON_QUERY_ARRAY(entries.RuleAction)) AS rule_action
               )
SELECT arn, account_id, port_range_from, port_range_to, protocol, cidr_block, ipv6_cidr_block
FROM rules
WHERE egress IS DISTINCT FROM 'true'
  AND rule_action = 'allow'
{% endmacro %}

{% macro athena__networks_acls_ingress_rules() %}
WITH rules AS (
    SELECT 
        aena.arn,
        aena.account_id,
        cast(json_extract_scalar(v, '$.PortRange.From') as integer) as port_range_from,
        cast(json_extract_scalar(v, '$.PortRange.To') as integer) as port_range_to,
        json_extract_scalar(v, '$.Protocol') as protocol,
        json_extract_scalar(v, '$.CidrBlock') as cidr_block,
        json_extract_scalar(v, '$.Ipv6CidrBlock') as ipv6_cidr_block,
        json_extract_scalar(v, '$.Egress') as egress,
        json_extract_scalar(v, '$.RuleAction') as rule_action
    FROM 
        aws_ec2_network_acls aena
    CROSS JOIN
        UNNEST(cast(json_extract(aena.entries, '$') as array(json))) as t(v)
)
SELECT 
    arn, 
    account_id, 
    port_range_from, 
    port_range_to, 
    protocol, 
    cidr_block, 
    ipv6_cidr_block
FROM 
    rules
WHERE 
    egress <> 'true'
    AND rule_action = 'allow'
{% endmacro %}