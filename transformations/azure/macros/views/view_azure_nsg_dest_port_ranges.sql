{% macro view_azure_nsg_dest_port_ranges() %}
  {{ return(adapter.dispatch('view_azure_nsg_dest_port_ranges')()) }}
{% endmacro %}

{% macro default__view_azure_nsg_dest_port_ranges() %}{% endmacro %}

{% macro postgres__view_azure_nsg_dest_port_ranges() %}
WITH security_rules AS (
    SELECT    
		subscription_id,
        security_rules->>'id' AS id,
        security_rules->'properties'->>'access' AS access,
        security_rules->'properties'->>'protocol' AS protocol,
        security_rules->'properties'->>'direction' AS direction,
        security_rules->'properties'->>'sourceAddressPrefix' AS sourceAddressPrefix,
        security_rules->'properties'->>'destinationPortRange' AS destinationPortRange,
        security_rules->'properties'->'destinationPortRanges' AS destinationPortRanges
    FROM
        azure_network_security_groups ansg,
        jsonb_array_elements(ansg.properties->'securityRules') AS security_rules
),
dest_port AS (
    SELECT
        id,
        destinationPortRange
    FROM
        security_rules
    WHERE
        destinationPortRange <> '' OR destinationPortRange IS NOT NULL
),
unified_port_ranges AS (
    SELECT
        id,
        split_part(port_range, '-', 1) :: INT AS start_dest_port,
        split_part(port_range, '-', 2) :: INT AS end_dest_port
    FROM
        security_rules AS sr, jsonb_array_elements_text(sr.destinationPortRanges) AS port_range
    WHERE
        port_range  ~ '^[0-9]+-[0-9]+$'
    UNION
    SELECT
        id,
        port_range :: INT AS start_dest_port,
        port_range :: INT AS end_dest_port
    FROM
        security_rules AS sr, jsonb_array_elements_text(sr.destinationPortRanges) AS port_range
    WHERE
        port_range ~ '^[0-9]+$'
    UNION
    SELECT
        id,
        1 AS start_port,
        65535 AS end_port
    FROM
        dest_port
    WHERE
        destinationPortRange = '*'
    UNION
    SELECT
        id,
        destinationPortRange :: INT AS start_dest_port,
        destinationPortRange :: INT AS end_dest_port
    FROM
        dest_port
    WHERE
        destinationPortRange ~ '^[0-9]+$'
    UNION
    SELECT
        id,
        split_part(destinationPortRange, '-', 1) :: INT AS start_dest_port,
        split_part(destinationPortRange, '-', 2) :: INT AS end_dest_port
    FROM
        dest_port
    WHERE
        destinationPortRange ~ '^[0-9]+-[0-9]+$'
)
SELECT
	sr.id AS id,
    sr.subscription_id AS subscription_id,
    access,
    protocol,
    direction,
    sourceAddressPrefix,
    start_dest_port,
    end_dest_port
FROM
    security_rules sr
        JOIN unified_port_ranges
            ON sr.id = unified_port_ranges.id
{% endmacro %}

{% macro snowflake__view_azure_nsg_dest_port_ranges() %}
WITH security_rules AS (
    SELECT    
		ansg."subscription_id",
        security_rules.value:id AS id,
        security_rules.value:properties:access AS access,
        security_rules.value:properties:protocol AS protocol,
        security_rules.value:properties:direction AS direction,
        security_rules.value:properties:sourceAddressPrefix AS sourceAddressPrefix,
        security_rules.value:properties:destinationPortRange AS destinationPortRange,
        security_rules.value:properties:destinationPortRanges AS destinationPortRanges
    FROM
        azure_network_security_groups ansg,
        LATERAL FLATTEN(input => ansg."properties":securityRules) AS security_rules
),
dest_port AS (
    SELECT
        id,
        destinationPortRange
    FROM
        security_rules
    WHERE
        destinationPortRange <> '' OR destinationPortRange IS NOT NULL
),
unified_port_ranges AS (
    SELECT
        id,
        split_part(port_range.value, '-', 1) :: INT AS start_dest_port,
        split_part(port_range.value, '-', 2) :: INT AS end_dest_port
    FROM
        security_rules AS sr,
        LATERAL FLATTEN(input => sr.destinationPortRanges) AS port_range
    WHERE
        port_range.value  REGEXP '^[0-9]+-[0-9]+$'
    UNION
    SELECT
        id,
        port_range.value :: INT AS start_dest_port,
        port_range.value :: INT AS end_dest_port
    FROM
        security_rules AS sr,
        LATERAL FLATTEN(input => sr.destinationPortRanges) AS port_range
    WHERE
        port_range.value REGEXP '^[0-9]+$'
    UNION
    SELECT
        id,
        1 AS start_port,
        65535 AS end_port
    FROM
        dest_port
    WHERE
        destinationPortRange = '*'
    UNION
    SELECT
        id,
        destinationPortRange :: INT AS start_dest_port,
        destinationPortRange :: INT AS end_dest_port
    FROM
        dest_port
    WHERE
        destinationPortRange REGEXP '^[0-9]+$'
    UNION
    SELECT
        id,
        split_part(destinationPortRange, '-', 1) :: INT AS start_dest_port,
        split_part(destinationPortRange, '-', 2) :: INT AS end_dest_port
    FROM
        dest_port
    WHERE
        destinationPortRange REGEXP '^[0-9]+-[0-9]+$'
)
SELECT
	sr.id AS id,
    sr."subscription_id" AS subscription_id,
    access,
    protocol,
    direction,
    sourceAddressPrefix,
    start_dest_port,
    end_dest_port
FROM
    security_rules sr
        JOIN unified_port_ranges
            ON sr.id = unified_port_ranges.id
{% endmacro %}

{% macro bigquery__view_azure_nsg_dest_port_ranges() %}
WITH security_rules AS (
    SELECT    
		subscription_id,
        JSON_VALUE(security_rules.id) AS id,
        JSON_VALUE(security_rules.properties.access) AS access,
        JSON_VALUE(security_rules.properties.protocol) AS protocol,
        JSON_VALUE(security_rules.properties.direction) AS direction,
        JSON_VALUE(security_rules.properties.sourceAddressPrefix) AS sourceAddressPrefix,
        JSON_VALUE(security_rules.properties.destinationPortRange) AS destinationPortRange,
        JSON_VALUE(security_rules.properties.destinationPortRanges) AS destinationPortRanges
    FROM
        {{ full_table_name("azure_network_security_groups") }} ansg,
        UNNEST(JSON_QUERY_ARRAY(ansg.properties.securityRules)) AS security_rules
),
dest_port AS (
    SELECT
        id,
        destinationPortRange
    FROM
        security_rules
    WHERE
        destinationPortRange <> '' OR destinationPortRange IS NOT NULL
),
unified_port_ranges AS (
    SELECT
        id,
        CAST(SPLIT(port_range, '-')[OFFSET(0)] AS INT64) AS start_dest_port,
        CAST(SPLIT(port_range, '-')[OFFSET(1)] AS INT64) AS end_dest_port
    FROM
        security_rules AS sr,
        UNNEST(JSON_QUERY_ARRAY(sr.destinationPortRanges)) AS port_range
    WHERE
        REGEXP_CONTAINS(port_range, r'^[0-9]+-[0-9]+$')
    UNION ALL
    SELECT
        id,
        CAST(port_range AS INT64) AS start_dest_port,
        CAST(port_range AS INT64) AS end_dest_port
    FROM
        security_rules AS sr,
        UNNEST(JSON_QUERY_ARRAY(sr.destinationPortRanges)) AS port_range
    WHERE
        REGEXP_CONTAINS(port_range, r'^[0-9]+$')
    UNION ALL
    SELECT
        id,
        1 AS start_port,
        65535 AS end_port
    FROM
        dest_port
    WHERE
        destinationPortRange = '*'
    UNION ALL
    SELECT
        id,
        CAST(destinationPortRange AS INT64) AS start_dest_port,
        CAST(destinationPortRange AS INT64) AS end_dest_port
    FROM
        dest_port
    WHERE
        REGEXP_CONTAINS(destinationPortRange, r'^[0-9]+$')
    UNION ALL
    SELECT
        id,
        CAST(SPLIT(destinationPortRange, '-')[OFFSET(0)] AS INT64) AS start_dest_port,
        CAST(SPLIT(destinationPortRange, '-')[OFFSET(1)] AS INT64) AS end_dest_port
    FROM
        dest_port
    WHERE
        REGEXP_CONTAINS(destinationPortRange, r'^[0-9]+-[0-9]+$')
)
SELECT
	sr.id AS id,
    sr.subscription_id AS subscription_id,
    access,
    protocol,
    direction,
    sourceAddressPrefix,
    start_dest_port,
    end_dest_port
FROM
    security_rules sr
        JOIN unified_port_ranges
            ON sr.id = unified_port_ranges.id
{% endmacro %}