package main

import data.lib.konstraint
import data.lib.kubernetes

# violation: Check if 'roleRef.apiGroup' is set
# @Kinds rbac.authorization.k8s.io/v1/RoleBinding
violation[msg] {
  rolebinding := kubernetes.is_rolebinding(konstraint.object)

  not rolebinding.roleRef.apiGroup

  msg := konstraint.format(sprintf("%s/%s: RoleBinding roleRef.apiGroup key is null, use rbac.authorization.k8s.io instead.", [rolebinding.kind, rolebinding.metadata.name]))
}