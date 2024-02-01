{% macro securityhub_enabled(framework, check_id) %}
  {{ return(adapter.dispatch('securityhub_enabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__securityhub_enabled(framework, check_id) %}{% endmacro %}

{% macro postgres__securityhub_enabled(framework, check_id) %}
with enabled_securityhub_regions as (select account_id, region from aws_securityhub_hubs)

select
       '{{framework}}'                    as framework,
       '{{check_id}}'                     as check_id,
       'SecurityHub should be enabled' AS title,
       r.account_id,
       r.region                        AS resource_id,
       case
           when
               r.enabled = TRUE AND e.region is null
               then 'fail'
           else 'pass' end             AS status
from aws_regions r
         left join enabled_securityhub_regions e on e.region = r.region AND e.account_id = r.account_id
{% endmacro %}

{% macro snowflake__securityhub_enabled(framework, check_id) %}
with enabled_securityhub_regions as (select account_id, region from aws_securityhub_hubs)

select
       '{{framework}}'                    as framework,
       '{{check_id}}'                     as check_id,
       'SecurityHub should be enabled' AS title,
       r.account_id,
       r.region                        AS resource_id,
       case
           when
               r.enabled = TRUE AND e.region is null
               then 'fail'
           else 'pass' end             AS status
from aws_regions r
         left join enabled_securityhub_regions e on e.region = r.region AND e.account_id = r.account_id
{% endmacro %}

{% macro bigquery__securityhub_enabled(framework, check_id) %}
with enabled_securityhub_regions as (select account_id, region from {{ full_table_name("aws_securityhub_hubs") }})

select
       '{{framework}}'                    as framework,
       '{{check_id}}'                     as check_id,
       'SecurityHub should be enabled' AS title,
       r.account_id,
       r.region                        AS resource_id,
       case
           when
               r.enabled = TRUE AND e.region is null
               then 'fail'
           else 'pass' end             AS status
from {{ full_table_name("aws_regions") }} r
         left join enabled_securityhub_regions e on e.region = r.region AND e.account_id = r.account_id
{% endmacro %}
