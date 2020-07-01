package lib.kubernetes

is_rolebinding(object) = rolebinding {
  lower(object.apiVersion) == "rbac.authorization.k8s.io/v1"
  lower(object.kind) == "rolebinding"

  rolebinding := object
}