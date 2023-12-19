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