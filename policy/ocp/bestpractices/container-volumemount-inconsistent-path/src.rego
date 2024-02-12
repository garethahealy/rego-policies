# METADATA
# title: 'RHCOP-OCP_BESTPRACT-00017: Container volume mount path is consistent'
# description: Mount paths should be mounted at '/var/run/company.com' to allow a consistent
#   understanding.
# custom:
#   matchers:
#     kinds:
#     - apiGroups:
#       - ""
#       kinds:
#       - Pod
#       - ReplicationController
#     - apiGroups:
#       - apps
#       kinds:
#       - DaemonSet
#       - Deployment
#       - Job
#       - ReplicaSet
#       - StatefulSet
#     - apiGroups:
#       - apps.openshift.io
#       kinds:
#       - DeploymentConfig
#     - apiGroups:
#       - batch
#       kinds:
#       - CronJob
package ocp.bestpractices.container_volumemount_inconsistent_path

import data.lib.konstraint.core as konstraint_core
import data.lib.openshift

violation[msg] {
  openshift.is_policy_active("RHCOP-OCP_BESTPRACT-00017")
  container := openshift.containers[_]

  volumeMount := container.volumeMounts[_]
  not startswith(volumeMount.mountPath, "/var/run")

  msg := konstraint_core.format_with_id(sprintf("%s/%s: container '%s' has a volumeMount '%s' mountPath at '%s'. A good practice is to use consistent mount paths, such as: /var/run/{organization}/{mount} - i.e.: /var/run/io.redhat-cop/my-secret", [konstraint_core.kind, konstraint_core.name, container.name, volumeMount.name, volumeMount.mountPath]), "RHCOP-OCP_BESTPRACT-00017")
}