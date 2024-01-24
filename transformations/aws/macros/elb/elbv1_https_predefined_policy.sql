{% macro elbv1_https_predefined_policy(framework, check_id) %}
  {{ return(adapter.dispatch('elbv1_https_predefined_policy')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__elbv1_https_predefined_policy(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Classic Load Balancers with HTTPS/SSL listeners should use a predefined security policy that has strong configuration' as title,
  lb.account_id,
  lb.arn as resource_id,
  case when
    li.value:Listener:Protocol in ('HTTPS', 'SSL') and 'ELBSecurityPolicy-TLS-1-2-2017-01' NOT IN (po.value:OtherPolicies)
    then 'fail'
    else 'pass'
  end as status
from aws_elbv1_load_balancers lb, lateral flatten(input => parse_json(lb.listener_descriptions)) as li,
                                  lateral flatten(input => parse_json(lb.policies)) as po
{% endmacro %}

{% macro postgres__elbv1_https_predefined_policy(framework, check_id) %}
WITH flat_listeners AS (
    SELECT
        arn,
        account_id,
        li->'Listener'->>'Protocol' as protocol,
        li->'PolicyNames' as policies_arr
    FROM aws_elbv1_load_balancers lb, jsonb_array_elements(lb.listener_descriptions) AS li
),
violations AS (
SELECT 
    fl.arn,
    fl.account_id,
    CASE 
        WHEN fl.protocol IN ('HTTPS', 'SSL')
          AND NOT EXISTS (
            SELECT 1
            FROM aws_elbv1_load_balancer_policies pol
            WHERE fl.policies_arr @> ('["' || pol.policy_name || '"]')::jsonb
            AND pol.policy_attribute_descriptions->>'Reference-Security-Policy' = 'ELBSecurityPolicy-TLS-1-2-2017-01'
        ) THEN 1
        ELSE 0
    END AS flag
FROM flat_listeners fl
)
SELECT
  DISTINCT
    '{{framework}}' AS framework,
    '{{check_id}}' AS check_id,
    'Classic Load Balancers with HTTPS/SSL listeners should use a predefined security policy that has strong configuration' AS title,
    v.account_id,
    v.arn AS resource_id,
    CASE
      WHEN MAX(flag) OVER(PARTITION BY arn) = 1 THEN 'fail'
      ELSE 'pass'
    END as status
FROM violations v{% endmacro %}

{% macro default__elbv1_https_predefined_policy(framework, check_id) %}{% endmacro %}

{% macro bigquery__elbv1_https_predefined_policy(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Classic Load Balancers with HTTPS/SSL listeners should use a predefined security policy that has strong configuration' as title,
  lb.account_id,
  lb.arn as resource_id,
  case when
    JSON_VALUE(li.Listener.Protocol) in ('HTTPS', 'SSL') 
    and 'ELBSecurityPolicy-TLS-1-2-2017-01' NOT IN UNNEST(JSON_EXTRACT_STRING_ARRAY(po.OtherPolicies))
    then 'fail'
    else 'pass'
  end as status
from {{ full_table_name("aws_elbv1_load_balancers") }}
 lb,
  UNNEST(JSON_QUERY_ARRAY(listener_descriptions)) AS li,
  UNNEST(JSON_QUERY_ARRAY(policies)) AS po
{% endmacro %}