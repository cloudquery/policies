with
    aggregated as (
    ({{ log_metric_filter_and_alarm() }})
    )
select * from aggregated
