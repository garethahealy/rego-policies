package main

import data.lib.konstraint

# violation: Check if all kinds contain labels as suggested by https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels
# @Kinds apps.openshift.io/v1/DeploymentConfig apps/DaemonSet apps/Deployment apps/StatefulSet
warn[msg] {
  obj := konstraint.object
  not is_common_labels_set(obj.metadata)

  msg := konstraint.format(sprintf("%s/%s: does not contain all the expected k8s labels in 'metadata.labels'. See: https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels", [obj.kind, obj.metadata.name]))
}

is_common_labels_set(metadata) {
    metadata.labels["app.kubernetes.io/name"]
    metadata.labels["app.kubernetes.io/instance"]
    #metadata.labels["app.kubernetes.io/version"]
    metadata.labels["app.kubernetes.io/component"]
    metadata.labels["app.kubernetes.io/part-of"]
    metadata.labels["app.kubernetes.io/managed-by"]
}