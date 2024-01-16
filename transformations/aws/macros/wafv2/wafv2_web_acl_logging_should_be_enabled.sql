{% macro wafv2_web_acl_logging_should_be_enabled(framework, check_id) %}
  {{ return(adapter.dispatch('wafv2_web_acl_logging_should_be_enabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__wafv2_web_acl_logging_should_be_enabled(framework, check_id) %}{% endmacro %}

{% macro postgres__wafv2_web_acl_logging_should_be_enabled(framework, check_id) %}
(
-- WAF Classic
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'AWS WAF Classic global web ACL logging should be enabled' as title,
    account_id,
    arn as resource_id,
    case when
        logging_configuration is null or logging_configuration = '{}'
    then 'fail' else 'pass' end as status
from aws_waf_web_acls
)
union
(
-- WAF V2
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'AWS WAF Classic global web ACL logging should be enabled' as title,
    account_id,
    arn as resource_id,
    case when
        logging_configuration is null or logging_configuration = '{}'
    then 'fail' else 'pass' end as status
from aws_wafv2_web_acls
)
{% endmacro %}
{% macro snowflake__wafv2_web_acl_logging_should_be_enabled(framework, check_id) %}
(
-- WAF Classic
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'AWS WAF Classic global web ACL logging should be enabled' as title,
    account_id,
    arn as resource_id,
    case when
        logging_configuration is null or logging_configuration = '{}'
    then 'fail' else 'pass' end as status
from aws_waf_web_acls
)
union
(
-- WAF V2
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'AWS WAF Classic global web ACL logging should be enabled' as title,
    account_id,
    arn as resource_id,
    case when
        logging_configuration is null or logging_configuration = '{}'
    then 'fail' else 'pass' end as status
from aws_wafv2_web_acls
)
{% endmacro %}