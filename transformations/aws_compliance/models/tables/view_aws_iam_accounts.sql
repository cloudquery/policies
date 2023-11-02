{{ config(materialized='ephemeral') }}

select * from aws_iam_accounts {{ cq_filters() }}
