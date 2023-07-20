
EC2_INSTANCES_SHOULD_BE_MANAGED_BY_SSM = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Amazon EC2 instances should be managed by AWS Systems Manager' as title,
    aws_ec2_instances.account_id,
    aws_ec2_instances.arn as resource_id,
    case when
        aws_ssm_instances.instance_id is null
    then 'fail' else 'pass' end as status
from
    aws_ec2_instances
left outer join aws_ssm_instances on aws_ec2_instances.instance_id = aws_ssm_instances.instance_id
"""

INSTANCES_SHOULD_HAVE_PATCH_COMPLIANCE_STATUS_OF_COMPLIANT = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Amazon EC2 instances managed by Systems Manager should have a patch compliance status of COMPLIANT after a patch installation' as title,
    aws_ssm_instances.account_id,
    aws_ssm_instances.arn,
    case when
        aws_ssm_instance_compliance_items.compliance_type = 'Patch'
        and aws_ssm_instance_compliance_items.status is distinct from 'COMPLIANT'
    then 'fail' else 'pass' end as status
from
    aws_ssm_instances
inner join aws_ssm_instance_compliance_items on aws_ssm_instances.arn = aws_ssm_instance_compliance_items.instance_arn
"""

INSTANCES_SHOULD_HAVE_ASSOCIATION_COMPLIANCE_STATUS_OF_COMPLIANT = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Amazon EC2 instances managed by Systems Manager should have an association compliance status of COMPLIANT' as title,
    aws_ssm_instances.account_id,
    aws_ssm_instances.arn,
    case when
        aws_ssm_instance_compliance_items.compliance_type = 'Association'
        and aws_ssm_instance_compliance_items.status is distinct from 'COMPLIANT'
    then 'fail' else 'pass' end as status
from
    aws_ssm_instances
inner join aws_ssm_instance_compliance_items on aws_ssm_instances.arn = aws_ssm_instance_compliance_items.instance_arn
"""

DOCUMENTS_SHOULD_NOT_BE_PUBLIC = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'SSM documents should not be public' as title,
    account_id,
    arn as resource_id,
    case when ARRAY_CONTAINS('all'::variant, p.value:AccountIds::ARRAY) then 'fail' else 'pass' end as status
from aws_ssm_documents, lateral flatten(input => parse_json(aws_ssm_documents.permissions)) as p
where owner in (select account_id from aws_iam_accounts);
"""
