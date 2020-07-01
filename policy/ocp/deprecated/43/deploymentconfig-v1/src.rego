package main

import data.lib.konstraint

# violation: Check for deprecated apiVersion. Expect apps.openshift.io/v1
# @Kinds v1/DeploymentConfig
violation[msg] {
  obj := konstraint.object
  lower(obj.apiVersion) == "v1"
  lower(obj.kind) == "deploymentconfig"

  msg := konstraint.format(sprintf("%s/%s: API v1 for DeploymentConfig is no longer served by default, use apps.openshift.io/v1 instead.", [obj.kind, obj.metadata.name]))
}