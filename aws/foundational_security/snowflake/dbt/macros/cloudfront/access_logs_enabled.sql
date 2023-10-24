{% macro access_logs_enabled(framework, check_id) %}
insert into aws_policy_results
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'CloudFront distributions should have logging enabled' as title,
    account_id,
    arn as resource_id,
    case
        when (distribution_config:Logging:Enabled)::boolean is distinct from true then 'fail'
        else 'pass'
    end as status
from aws_cloudfront_distributions
{% endmacro %}