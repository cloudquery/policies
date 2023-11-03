{% macro certificates_unused(framework, check_id) %}
  {{ return(adapter.dispatch('certificates_unused')(framework, check_id)) }}
{% endmacro %}

{% macro default__certificates_unused(framework, check_id) %}{% endmacro %}

{% macro postgres__certificates_unused(framework, check_id) %}
select
       '{{framework}}'             as framework,
       '{{check_id}}'              as check_id,
       'Unused ACM certificate' as title,
       account_id,
       arn                      as resource_id,
       'fail'                   as status
from aws_acm_certificates
where array_length(in_use_by, 1) = 0{% endmacro %}
