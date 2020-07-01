package main

import data.lib.konstraint

# violation: Check for deprecated apiVersion. Expect rbac.authorization.k8s.io/v1
# @Kinds v1/RoleBinding
violation[msg] {
  obj := konstraint.object
  lower(obj.apiVersion) == "v1"
  lower(obj.kind) == "rolebinding"

  msg := konstraint.format(sprintf("%s/%s: API v1 for RoleBinding is no longer served by default, use rbac.authorization.k8s.io/v1 instead.", [obj.kind, obj.metadata.name]))
}