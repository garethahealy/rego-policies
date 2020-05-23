package main

import data.kubernetes
import data.openshift

# catch all
deny[msg] {
  msg := _deny
}

deny[msg] {
  openshift.is_template

  obj := input.objects[_]
  msg := _deny with input as obj
}

deny[msg] {
  openshift.is_not_template

  obj := input.objects[_]
  msg := _deny
}

deny[msg] {
  kubernetes.is_list

  obj := input.items[_]
  msg := _deny with input as obj
}

deny[msg] {
  kubernetes.is_not_list

  msg := _deny
}

_deny = msg {
  contains(input.apiVersion, "servicecatalog.k8s.io/v1beta1")

  msg := sprintf("%s/%s: servicecatalog.k8s.io/v1beta1 is deprecated.", [input.kind, input.metadata.name])
}

_deny = msg {
  contains(input.apiVersion, "automationbroker.io/v1alpha1")

  msg := sprintf("%s/%s: automationbroker.io/v1alpha1 is deprecated.", [input.kind, input.metadata.name])
}

_deny = msg {
  contains(input.apiVersion, "osb.openshift.io/v1")

  msg := sprintf("%s/%s: osb.openshift.io/v1 is deprecated.", [input.kind, input.metadata.name])
}

_deny = msg {
  contains(input.apiVersion, "operatorsources.operators.coreos.com/v1")

  msg := sprintf("%s/%s: operatorsources.operators.coreos.com/v1 is deprecated.", [input.kind, input.metadata.name])
}

_deny = msg {
  contains(input.apiVersion, "catalogsourceconfigs.operators.coreos.com/v1")

  msg := sprintf("%s/%s: catalogsourceconfigs.operators.coreos.com/v1 is deprecated.", [input.kind, input.metadata.name])
}

_deny = msg {
  contains(input.apiVersion, "catalogsourceconfigs.operators.coreos.com/v2")

  msg := sprintf("%s/%s: catalogsourceconfigs.operators.coreos.com/v2 is deprecated.", [input.kind, input.metadata.name])
}