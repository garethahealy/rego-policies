package main

import data.lib.konstraint

# violation: Check for deprecated apiVersion: https://docs.openshift.com/container-platform/4.2/release_notes/ocp-4-2-release-notes.html#ocp-4-2-deprecated-features
# @Kinds automationbroker.io/v1alpha1/*
violation[msg] {
  obj := konstraint.object
  contains(lower(obj.apiVersion), "automationbroker.io/v1alpha1")

  msg := konstraint.format(sprintf("%s/%s: automationbroker.io/v1alpha1 is deprecated.", [obj.kind, obj.metadata.name]))
}