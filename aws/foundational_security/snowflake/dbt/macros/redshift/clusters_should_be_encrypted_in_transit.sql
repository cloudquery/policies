{% macro clusters_should_be_encrypted_in_transit(framework, check_id) %}
insert into aws_policy_results
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