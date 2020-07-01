package main

import data.lib.konstraint

# violation: Check for deprecated apiVersion. Expect image.openshift.io/v1
# @Kinds v1/ImageStream
violation[msg] {
  obj := konstraint.object
  lower(obj.apiVersion) == "v1"
  lower(obj.kind) == "imagestream"

  msg := konstraint.format(sprintf("%s/%s: API v1 for ImageStream is no longer served by default, use image.openshift.io/v1 instead.", [obj.kind, obj.metadata.name]))
}