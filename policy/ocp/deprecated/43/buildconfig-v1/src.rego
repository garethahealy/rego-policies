package main

import data.lib.konstraint

# violation: Check for deprecated apiVersion. Expect build.openshift.io/v1
# @Kinds v1/BuildConfig
violation[msg] {
  obj := konstraint.object
  lower(obj.apiVersion) == "v1"
  lower(obj.kind) == "buildconfig"

  msg := konstraint.format(sprintf("%s/%s: API v1 for BuildConfig is no longer served by default, use build.openshift.io/v1 instead.", [obj.kind, obj.metadata.name]))
}