{% macro network_ssh_services_are_restricted_from_the_internet(framework, check_id) %}
  {{ return(adapter.dispatch('network_ssh_services_are_restricted_from_the_internet')(framework, check_id)) }}
{% endmacro %}

{% macro default__network_ssh_services_are_restricted_from_the_internet(framework, check_id) %}{% endmacro %}

{% macro postgres__network_ssh_services_are_restricted_from_the_internet(framework, check_id) %}
WITH conditions AS (
    SELECT
        subscription_id,
        id,
        access = 'Allow' AS acceptAccess,
        protocol = '*' OR upper(protocol) = 'TCP' AS matchProtocol,
        direction = 'Inbound' AS isInbound,
        sourceAddressPrefix IN ('*', '0.0.0.0', '<nw>/0', '/0', 'internet', 'any') AS matchPrefix,
        22 BETWEEN start_dest_port AND end_dest_port AS inRange
    FROM {{ ref('view_azure_nsg_dest_port_ranges') }}
),
statuses_by_port_range AS (
    SELECT
        subscription_id,
        id,
        acceptAccess AND matchProtocol AND isInbound AND matchPrefix AND inRange AS failed
    FROM conditions
),
statuses AS (
    SELECT subscription_id, id, bool_or(failed) AS failed
    FROM statuses_by_port_range
    GROUP BY subscription_id, id
)
SELECT
    id                                                       AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure that SSH access is restricted from the Internet' AS title,
    subscription_id                                          AS subscription_id,
    CASE
        WHEN failed
        THEN 'fail'
        ELSE 'pass'
    END                                                      AS status
FROM statuses
{% endmacro %}

{% macro snowflake__network_ssh_services_are_restricted_from_the_internet(framework, check_id) %}
WITH conditions AS (
    SELECT
        subscription_id,
        id,
        access = 'Allow' AS acceptAccess,
        protocol = '*' OR upper(protocol) = 'TCP' AS matchProtocol,
        direction = 'Inbound' AS isInbound,
        sourceAddressPrefix IN ('*', '0.0.0.0', '<nw>/0', '/0', 'internet', 'any') AS matchPrefix,
        22 BETWEEN start_dest_port AND end_dest_port AS inRange
    FROM {{ ref('view_azure_nsg_dest_port_ranges') }}
),
statuses_by_port_range AS (
    SELECT
        subscription_id,
        id,
        acceptAccess AND matchProtocol AND isInbound AND matchPrefix AND inRange AS failed
    FROM conditions
),
statuses AS (
    SELECT subscription_id, id, BOOLOR_AGG(failed) AS failed
    FROM statuses_by_port_range
    GROUP BY subscription_id, id
)
SELECT
    id                                                       AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure that SSH access is restricted from the Internet' AS title,
    subscription_id                                          AS subscription_id,
    CASE
        WHEN failed
        THEN 'fail'
        ELSE 'pass'
    END                                                      AS status
FROM statuses
{% endmacro %}

{% macro bigquery__network_ssh_services_are_restricted_from_the_internet(framework, check_id) %}
WITH conditions AS (
    SELECT
        subscription_id,
        id,
        access = 'Allow' AS acceptAccess,
        protocol = '*' OR upper(protocol) = 'TCP' AS matchProtocol,
        direction = 'Inbound' AS isInbound,
        sourceAddressPrefix IN ('*', '0.0.0.0', '<nw>/0', '/0', 'internet', 'any') AS matchPrefix,
        22 BETWEEN start_dest_port AND end_dest_port AS inRange
    FROM {{ ref('view_azure_nsg_dest_port_ranges') }}
),
statuses_by_port_range AS (
    SELECT
        subscription_id,
        id,
        acceptAccess AND matchProtocol AND isInbound AND matchPrefix AND inRange AS failed
    FROM conditions
),
statuses AS (
    SELECT subscription_id, id, LOGICAL_OR(failed) AS failed
    FROM statuses_by_port_range
    GROUP BY subscription_id, id
)
SELECT
    id                                                       AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure that SSH access is restricted from the Internet' AS title,
    subscription_id                                          AS subscription_id,
    CASE
        WHEN failed
        THEN 'fail'
        ELSE 'pass'
    END                                                      AS status
FROM statuses
{% endmacro %}