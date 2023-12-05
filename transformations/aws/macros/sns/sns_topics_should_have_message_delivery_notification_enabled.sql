{% macro sns_topics_should_have_message_delivery_notification_enabled(framework, check_id) %}
  {{ return(adapter.dispatch('sns_topics_should_have_message_delivery_notification_enabled')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__sns_topics_should_have_message_delivery_notification_enabled(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
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
{% endmacro %}

{% macro postgres__sns_topics_should_have_message_delivery_notification_enabled(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Logging of delivery status should be enabled for notification messages sent to a topic' as title,
    account_id,
    arn as resource_id,
    case when
        unknown_fields->'HTTPSuccessFeedbackRoleArn' is Null
        AND  unknown_fields->'FirehoseSuccessFeedbackRoleArn' is Null
        AND  unknown_fields->'LambdaSuccessFeedbackRoleArn' is Null
        AND  unknown_fields->'ApplicationSuccessFeedbackRoleArn' is Null
        AND  unknown_fields->'SQSSuccessFeedbackRoleArn' is Null
    then 'fail' else 'pass' end as status
from aws_sns_topics{% endmacro %}

{% macro default__sns_topics_should_have_message_delivery_notification_enabled(framework, check_id) %}{% endmacro %}
                    