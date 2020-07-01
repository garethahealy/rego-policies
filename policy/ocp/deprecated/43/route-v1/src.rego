package main

import data.lib.konstraint

# violation: Check for deprecated apiVersion. Expect route.openshift.io/v1
# @Kinds v1/Route
violation[msg] {
  obj := konstraint.object
  lower(obj.apiVersion) == "v1"
  lower(obj.kind) == "route"

  msg := konstraint.format(sprintf("%s/%s: API v1 for Route is no longer served by default, use route.openshift.io/v1 instead.", [obj.kind, obj.metadata.name]))
}
