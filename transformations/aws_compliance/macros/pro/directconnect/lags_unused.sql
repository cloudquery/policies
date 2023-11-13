{% macro lags_unused(framework, check_id) %}
  {{ return(adapter.dispatch('lags_unused')(framework, check_id)) }}
{% endmacro %}

{% macro default__lags_unused(framework, check_id) %}{% endmacro %}

{% macro postgres__lags_unused(framework, check_id) %}
select
       '{{framework}}'                              as framework,
       '{{check_id}}'                               as check_id,
       'Direct Connect LAGs with no connections' as title,
       account_id,
       arn                                       as resource_id,
       'fail'                                    as status
from aws_directconnect_lags
where number_of_connections = 0 or coalesce(jsonb_array_length(connections), 0) = 0;
{% endmacro %}
