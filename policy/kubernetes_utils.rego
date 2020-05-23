package kubernetes

is_list {
  input.apiVersion == "v1"
  input.kind == "List"
}

is_not_list {
  input.apiVersion != "v1"
  input.kind != "List"
}