{% macro cloudtrail_enabled_all_regions(framework, check_id) %}
select
    '{{check_id}}' As check_id,
    '{{framework}}' As framework,
    'Ensure CloudTrail is enabled in all regions' as title,
    aws_cloudtrail_trails.account_id,
    arn as resource_id,
    case
        when is_multi_region_trail = FALSE or (
                    is_multi_region_trail = TRUE and (
                        read_write_type != 'All' or include_management_events = FALSE
                )) then 'fail'
        else 'pass'
    end as status
from aws_cloudtrail_trails
inner join
    aws_cloudtrail_trail_event_selectors on
        aws_cloudtrail_trails.arn = aws_cloudtrail_trail_event_selectors.trail_arn
        and aws_cloudtrail_trails.region = aws_cloudtrail_trail_event_selectors.region
        and aws_cloudtrail_trails.account_id = aws_cloudtrail_trail_event_selectors.account_id
{% endmacro %}