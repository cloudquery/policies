
SNS_TOPICS_SHOULD_BE_ENCRYPTED_AT_REST_USING_AWS_KMS = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'SNS topics should be encrypted at rest using AWS KMS' as title,
    account_id,
    arn as resource_id,
    case when
        kms_master_key_id is null or kms_master_key_id = ''
    then 'fail' else 'pass' end as status
from aws_sns_topics
"""

SNS_TOPICS_SHOULD_HAVE_MESSAGE_DELIVERY_NOTIFICATION_ENABLED = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Logging of delivery status should be enabled for notification messages sent to a topic' as title,
    account_id,
    arn as resource_id,
    case when
        unknown_fields:HTTPSuccessFeedbackRoleArn IS NULL
        AND  unknown_fields:FirehoseSuccessFeedbackRoleArn IS NULL
        AND  unknown_fields:LambdaSuccessFeedbackRoleArn IS NULL
        AND  unknown_fields:ApplicationSuccessFeedbackRoleArn IS NULL
        AND  unknown_fields:SQSSuccessFeedbackRoleArn IS NULL
    then 'fail' else 'pass' end as status
from aws_sns_topics
"""
