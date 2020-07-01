package main

import data.lib.konstraint

# violation: Check for deprecated apiVersion. Expect project.openshift.io/v1
# @Kinds v1/ProjectRequest
violation[msg] {
  obj := konstraint.object
  lower(obj.apiVersion) == "v1"
  lower(obj.kind) == "projectrequest"

  msg := konstraint.format(sprintf("%s/%s: API v1 for ProjectRequest is no longer served by default, use project.openshift.io/v1 instead.", [obj.kind, obj.metadata.name]))
}