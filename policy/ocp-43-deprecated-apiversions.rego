package main

# catch all
deny[msg] {
  msg := _deny
}

import data.kubernetes
import data.openshift

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

deny[msg] {
  input.apiVersion == "v1"
  input.kind == "Template"
  msg := sprintf("%s/%s: API v1 for Template is no longer served by default, use template.openshift.io/v1 instead.", [input.kind, input.metadata.name])
}

_deny = msg {
  input.apiVersion == "v1"
  input.kind == "ProjectRequest"
  msg := sprintf("%s/%s: API v1 for ProjectRequest is no longer served by default, use project.openshift.io/v1 instead.", [input.kind, input.metadata.name])
}

_deny = msg {
  input.apiVersion == "v1"
  input.kind == "ImageStream"
  msg := sprintf("%s/%s: API v1 for ImageStream is no longer served by default, use image.openshift.io/v1 instead.", [input.kind, input.metadata.name])
}

_deny = msg {
  input.apiVersion == "v1"
  input.kind == "BuildConfig"
  msg := sprintf("%s/%s: API v1 for BuildConfig is no longer served by default, use build.openshift.io/v1 instead.", [input.kind, input.metadata.name])
}

_deny = msg {
  input.apiVersion == "v1"
  input.kind == "DeploymentConfig"
  msg := sprintf("%s/%s: API v1 for DeploymentConfig is no longer served by default, use apps.openshift.io/v1 instead.", [input.kind, input.metadata.name])
}

_deny = msg {
  input.apiVersion == "v1"
  input.kind == "RoleBinding"
  msg := sprintf("%s/%s: API v1 for RoleBinding is no longer served by default, use rbac.authorization.k8s.io/v1 instead.", [input.kind, input.metadata.name])
}

_deny = msg {
  input.apiVersion == "v1"
  input.kind == "Route"
  msg := sprintf("%s/%s: API v1 for Route is no longer served by default, use route.openshift.io/v1 instead.", [input.kind, input.metadata.name])
}

_deny = msg {
  input.apiVersion == "v1"
  input.kind == "SecurityContextConstraints"
  msg := sprintf("%s/%s: API v1 for SecurityContextConstraints is no longer served by default, use security.openshift.io/v1 instead.", [input.kind, input.metadata.name])
}