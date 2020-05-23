package openshift

is_template {
  input.apiVersion == "template.openshift.io/v1"
  input.kind == "Template"
}

is_not_template {
  input.apiVersion != "template.openshift.io/v1"
  input.kind != "Template"
}