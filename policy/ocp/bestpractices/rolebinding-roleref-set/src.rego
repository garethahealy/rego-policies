package main

import data.lib.konstraint
import data.lib.kubernetes

# violation: Check if 'roleRef.kind' is set
# @Kinds rbac.authorization.k8s.io/v1/RoleBinding
violation[msg] {
  rolebinding := kubernetes.is_rolebinding(konstraint.object)

  not rolebinding.roleRef.kind

  msg := konstraint.format(sprintf("%s/%s: RoleBinding roleRef.kind key is null, use ClusterRole or Role instead.", [rolebinding.kind, rolebinding.metadata.name]))
}