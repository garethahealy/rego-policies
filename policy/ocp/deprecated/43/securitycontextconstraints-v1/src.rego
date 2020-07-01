package main

import data.lib.konstraint

# violation: Check for deprecated apiVersion. Expect security.openshift.io/v1
# @Kinds v1/SecurityContextConstraints
violation[msg] {
  obj := konstraint.object
  lower(obj.apiVersion) == "v1"
  lower(obj.kind) == "securitycontextconstraints"

  msg := konstraint.format(sprintf("%s/%s: API v1 for SecurityContextConstraints is no longer served by default, use security.openshift.io/v1 instead.", [obj.kind, obj.metadata.name]))
}