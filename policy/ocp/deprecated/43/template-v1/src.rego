package main

import data.lib.konstraint

# violation: Check for deprecated apiVersion. Expect template.openshift.io/v1
# @Kinds v1/Template
violation[msg] {
  obj := konstraint.object
  lower(obj.apiVersion) == "v1"
  lower(obj.kind) == "template"

  msg := konstraint.format(sprintf("%s/%s: API v1 for Template is no longer served by default, use template.openshift.io/v1 instead.", [obj.kind, obj.metadata.name]))
}