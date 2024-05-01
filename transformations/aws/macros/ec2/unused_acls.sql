{% macro unused_acls(framework, check_id) %}
  {{ return(adapter.dispatch('unused_acls')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__unused_acls(framework, check_id) %}
with results as (
select distinct
    account_id,
    network_acl_id as resource_id,
    case when
        association.value:NetworkAclAssociationId is null
        then 'pass'
        else 'fail'
    end as status
from aws_ec2_network_acls, lateral flatten(input => parse_json(aws_ec2_network_acls.associations), OUTER => TRUE) as association
)

select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Unused network access control lists should be removed' as title,
    account_id,
    resource_id,
    status
from results
{% endmacro %}

{% macro postgres__unused_acls(framework, check_id) %}
with results as (
select distinct
    account_id,
    network_acl_id as resource_id,
    case when
        a->>'NetworkAclAssociationId' is null
        then 'fail'
        else 'pass'
    end as status
from aws_ec2_network_acls left join jsonb_array_elements(aws_ec2_network_acls.associations) as a on true
        )
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Unused network access control lists should be removed' as title,
    account_id,
    resource_id,
    status
from results
{% endmacro %}

{% macro default__unused_acls(framework, check_id) %}{% endmacro %}

{% macro bigquery__unused_acls(framework, check_id) %}
with results as (
select distinct
    account_id,
    network_acl_id as resource_id,
    case when
        association.NetworkAclAssociationId is null
        then 'pass'
        else 'fail'
    end as status
from {{ full_table_name("aws_ec2_network_acls") }},
UNNEST(JSON_QUERY_ARRAY(associations)) AS association
)
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Unused network access control lists should be removed' as title,
    account_id,
    resource_id,
    status
from results
{% endmacro %}

{% macro athena__unused_acls(framework, check_id) %}
WITH results AS (
    SELECT DISTINCT
        account_id,
        network_acl_id AS resource_id,
        CASE WHEN
            JSON_EXTRACT(assoc, '$.NetworkAclAssociationId') IS NULL
        THEN 'fail'
        ELSE 'pass'
        END AS status
    FROM aws_ec2_network_acls
    CROSS JOIN UNNEST(CAST(json_parse(associations) AS array(json))) AS t (assoc)
)

SELECT
    '{{framework}}' AS framework,
    '{{check_id}}' AS check_id,
    'Unused network access control lists should be removed' as title,
    account_id,
    resource_id,
    status
FROM results
{% endmacro %}
