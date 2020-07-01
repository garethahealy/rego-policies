package main

import data.lib.konstraint
import data.lib.openshift

# violation: Check if 'spec.triggers' is set
# @Kinds apps.openshift.io/v1/DeploymentConfig
warn[msg] {
  openshift.is_deploymentconfig(konstraint.object)

  not input.spec.triggers

  msg := konstraint.format(sprintf("%s/%s: has no triggers set. Could you use a k8s native Deployment? See: https://kubernetes.io/docs/concepts/workloads/controllers/deployment", [input.kind, input.metadata.name]))
}