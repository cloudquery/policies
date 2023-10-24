{% macro unused_acls(framework, check_id) %}
insert into aws_policy_results
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