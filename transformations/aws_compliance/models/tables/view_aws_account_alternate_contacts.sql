{{ config(materialized='ephemeral') }}

select * from aws_account_alternate_contacts {{ cq_filters() }}
