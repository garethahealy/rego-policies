package lib.openshift

is_deploymentconfig(object) = deploymentconfig {
  lower(object.apiVersion) == "apps.openshift.io/v1"
  lower(object.kind) == "deploymentconfig"

  deploymentconfig := object
}