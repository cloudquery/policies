{% macro network_virtualnetworkserviceendpoint_appservice_auditifnotexists(framework, check_id) %}

select
  awa.id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'App Service should use a virtual network service endpoint',
  awa.subscription_id AS subscription_id,
  case
    when vnet.properties -> 'vnetResourceId' is null
    then 'fail' else 'pass'
  end
from
    azure_appservice_web_apps awa
left join
    azure_appservice_web_app_vnet_connections as vnet
on vnet._cq_parent_id = awa._cq_id
{% endmacro %}