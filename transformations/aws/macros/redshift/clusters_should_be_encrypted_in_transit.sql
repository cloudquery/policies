{% macro clusters_should_be_encrypted_in_transit(framework, check_id) %}
  {{ return(adapter.dispatch('clusters_should_be_encrypted_in_transit')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__clusters_should_be_encrypted_in_transit(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
'Connections to Amazon Redshift clusters should be encrypted in transit' AS title,
  rsc.account_id,
  rsc.arn AS resource_id,
  'fail' AS status
FROM
  aws_redshift_clusters AS rsc
JOIN
  aws_redshift_cluster_parameter_groups AS rscpg ON rsc.arn = rscpg.cluster_arn
LEFT JOIN
  aws_redshift_cluster_parameters AS rscp ON rscpg.cluster_arn = rscp.cluster_arn
  AND rscp.parameter_name = 'require_ssl'
WHERE
  (rscp.parameter_value = 'false')
  OR (rscp.parameter_value IS NULL)
  OR NOT EXISTS (
    SELECT
      1
    FROM
      aws_redshift_cluster_parameters
    WHERE
      cluster_arn = rscpg.cluster_arn
      AND parameter_name = 'require_ssl'
 )
{% endmacro %}

{% macro postgres__clusters_should_be_encrypted_in_transit(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Connections to Amazon Redshift clusters should be encrypted in transit' as title,
    account_id,
    arn as resource_id,
    'fail' as status -- TODO FIXME
from aws_redshift_clusters as rsc

where exists(select 1
                    from aws_redshift_cluster_parameter_groups as rscpg
    inner join aws_redshift_cluster_parameters as rscp
        on
            rscpg.cluster_arn = rscp.cluster_arn
    where rsc.arn = rscpg.cluster_arn
        and (
            rscp.parameter_name = 'require_ssl' and rscp.parameter_value = 'false'
        )
        or (
            rscp.parameter_name = 'require_ssl' and rscp.parameter_value is null
        )
        or not exists((select 1
            from aws_redshift_cluster_parameters
            where cluster_arn = rscpg.cluster_arn
                and parameter_name = 'require_ssl'))
)
{% endmacro %}

{% macro default__clusters_should_be_encrypted_in_transit(framework, check_id) %}{% endmacro %}
                    