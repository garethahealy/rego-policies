#!/usr/bin/env bats

load bats-support-clone
load test_helper/bats-support/load
load test_helper/redhatcop-bats-library/load

setup_file() {
  rm -rf /tmp/rhcop
}

####################
# all-namespaces
####################

@test "policy/ocp/bestpractices/_all-namespaces" {
  tmp=$(split_files "policy/ocp/bestpractices/_all-namespaces/test_data/integration")

  cmd="conftest test ${tmp} --all-namespaces --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 0 ]
}

####################
# combine
####################

@test "policy/combine/namespace_has_networkpolicy" {
  tmp=$(split_files "policy/combine/namespace_has_networkpolicy/test_data/unit")

  cmd="conftest test ${tmp} --output tap --combine --namespace combine.namespace_has_networkpolicy --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "1..1" ]
  [ "${lines[1]}" = "not ok 1 - Combined - combine.namespace_has_networkpolicy - RHCOP-COMBINE-00001: Namespace/foo does not have a networking.k8s.io/v1:NetworkPolicy. See: https://docs.openshift.com/container-platform/4.6/networking/network_policy/about-network-policy.html" ]
  [[ "${#lines[@]}" -eq 2 ]]
}

@test "policy/combine/namespace_has_resourcequota" {
  tmp=$(split_files "policy/combine/namespace_has_resourcequota/test_data/unit")

  cmd="conftest test ${tmp} --output tap --combine --namespace combine.namespace_has_resourcequota --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "1..1" ]
  [ "${lines[1]}" = "not ok 1 - Combined - combine.namespace_has_resourcequota - RHCOP-COMBINE-00002: Namespace/foo does not have a core/v1:ResourceQuota. See: https://docs.openshift.com/container-platform/4.6/applications/quotas/quotas-setting-per-project.html" ]
  [[ "${#lines[@]}" -eq 2 ]]
}

####################
# ocp/bestpractices
####################

@test "policy/ocp/bestpractices/common_k8s_labels_notset" {
  tmp=$(split_files "policy/ocp/bestpractices/common_k8s_labels_notset/test_data/unit")

  cmd="conftest test ${tmp} --output tap --namespace ocp.bestpractices.common_k8s_labels_notset --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "1..2" ]
  [ "${lines[1]}" = "not ok 1 - ${tmp}/list.yml - ocp.bestpractices.common_k8s_labels_notset - RHCOP-OCP_BESTPRACT-00001: Deployment/nolabels: does not contain all the expected k8s labels in 'metadata.labels'. See: https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels" ]
  [ "${lines[2]}" = "not ok 2 - ${tmp}/list.yml - ocp.bestpractices.common_k8s_labels_notset - RHCOP-OCP_BESTPRACT-00001: DeploymentConfig/nolabels: does not contain all the expected k8s labels in 'metadata.labels'. See: https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels" ]
  [[ "${#lines[@]}" -eq 3 ]]
}

@test "policy/ocp/bestpractices/container_env_maxmemory_notset" {
  tmp=$(split_files "policy/ocp/bestpractices/container_env_maxmemory_notset/test_data/unit")

  cmd="conftest test ${tmp} --output tap --namespace ocp.bestpractices.container_env_maxmemory_notset --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "1..2" ]
  [ "${lines[1]}" = "not ok 1 - ${tmp}/list.yml - ocp.bestpractices.container_env_maxmemory_notset - RHCOP-OCP_BESTPRACT-00002: Deployment/nodownwardmemoryenv: container 'bar' does not have an env named 'CONTAINER_MAX_MEMORY' which is used by the Red Hat base images to calculate memory. See: https://docs.openshift.com/container-platform/4.6/nodes/clusters/nodes-cluster-resource-configure.html and https://github.com/jboss-openshift/cct_module/blob/master/jboss/container/java/jvm/bash/artifacts/opt/jboss/container/java/jvm/java-default-options" ]
  [ "${lines[2]}" = "not ok 2 - ${tmp}/list.yml - ocp.bestpractices.container_env_maxmemory_notset - RHCOP-OCP_BESTPRACT-00002: DeploymentConfig/nodownwardmemoryenv: container 'bar' does not have an env named 'CONTAINER_MAX_MEMORY' which is used by the Red Hat base images to calculate memory. See: https://docs.openshift.com/container-platform/4.6/nodes/clusters/nodes-cluster-resource-configure.html and https://github.com/jboss-openshift/cct_module/blob/master/jboss/container/java/jvm/bash/artifacts/opt/jboss/container/java/jvm/java-default-options" ]
  [[ "${#lines[@]}" -eq 3 ]]
}

@test "policy/ocp/bestpractices/container_image_latest" {
  tmp=$(split_files "policy/ocp/bestpractices/container_image_latest/test_data/unit")

  cmd="conftest test ${tmp} --output tap --namespace ocp.bestpractices.container_image_latest --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "${lines[0]}" = "1..2" ]
  [ "${lines[1]}" = "not ok 1 - ${tmp}/list.yml - ocp.bestpractices.container_image_latest - RHCOP-OCP_BESTPRACT-00003: Deployment/imageuseslatesttag: container 'bar' is using the latest tag for its image (quay.io/redhat-cop/openshift-applier:latest), which is an anti-pattern." ]
  [ "${lines[2]}" = "not ok 2 - ${tmp}/list.yml - ocp.bestpractices.container_image_latest - RHCOP-OCP_BESTPRACT-00003: DeploymentConfig/imageuseslatesttag: container 'bar' is using the latest tag for its image (quay.io/redhat-cop/openshift-applier:latest), which is an anti-pattern." ]
  [[ "${#lines[@]}" -eq 3 ]]
}

@test "policy/ocp/bestpractices/container_image_unknownregistries" {
  tmp=$(split_files "policy/ocp/bestpractices/container_image_unknownregistries/test_data/unit")

  cmd="conftest test ${tmp} --output tap --namespace ocp.bestpractices.container_image_unknownregistries --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "1..2" ]
  [ "${lines[1]}" = "not ok 1 - ${tmp}/list.yml - ocp.bestpractices.container_image_unknownregistries - RHCOP-OCP_BESTPRACT-00004: Deployment/imagefromunknownregistry: container 'bar' is from (docker.io/alpine:3.12), which is an unknown registry." ]
  [ "${lines[2]}" = "not ok 2 - ${tmp}/list.yml - ocp.bestpractices.container_image_unknownregistries - RHCOP-OCP_BESTPRACT-00004: DeploymentConfig/imagefromunknownregistry: container 'bar' is from (docker.io/alpine:3.12), which is an unknown registry." ]
  [[ "${#lines[@]}" -eq 3 ]]
}

@test "policy/ocp/bestpractices/container_java_xmx_set" {
  tmp=$(split_files "policy/ocp/bestpractices/container_java_xmx_set/test_data/unit")

  cmd="conftest test ${tmp} --output tap --namespace ocp.bestpractices.container_java_xmx_set --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "1..6" ]
  [ "${lines[1]}" = "not ok 1 - ${tmp}/list.yml - ocp.bestpractices.container_java_xmx_set - RHCOP-OCP_BESTPRACT-00005: Deployment/xmxviacommand: container 'bar' contains -Xmx in either, command, args or env. Instead, it is suggested you use the downward API to set the env 'CONTAINER_MAX_MEMORY'" ]
  [ "${lines[2]}" = "not ok 2 - ${tmp}/list.yml - ocp.bestpractices.container_java_xmx_set - RHCOP-OCP_BESTPRACT-00005: Deployment/xmxviaargs: container 'bar' contains -Xmx in either, command, args or env. Instead, it is suggested you use the downward API to set the env 'CONTAINER_MAX_MEMORY'" ]
  [ "${lines[3]}" = "not ok 3 - ${tmp}/list.yml - ocp.bestpractices.container_java_xmx_set - RHCOP-OCP_BESTPRACT-00005: Deployment/xmxviaenv: container 'bar' contains -Xmx in either, command, args or env. Instead, it is suggested you use the downward API to set the env 'CONTAINER_MAX_MEMORY'" ]
  [ "${lines[4]}" = "not ok 4 - ${tmp}/list.yml - ocp.bestpractices.container_java_xmx_set - RHCOP-OCP_BESTPRACT-00005: DeploymentConfig/xmxviacommand: container 'bar' contains -Xmx in either, command, args or env. Instead, it is suggested you use the downward API to set the env 'CONTAINER_MAX_MEMORY'" ]
  [ "${lines[5]}" = "not ok 5 - ${tmp}/list.yml - ocp.bestpractices.container_java_xmx_set - RHCOP-OCP_BESTPRACT-00005: DeploymentConfig/xmxviaargs: container 'bar' contains -Xmx in either, command, args or env. Instead, it is suggested you use the downward API to set the env 'CONTAINER_MAX_MEMORY'" ]
  [ "${lines[6]}" = "not ok 6 - ${tmp}/list.yml - ocp.bestpractices.container_java_xmx_set - RHCOP-OCP_BESTPRACT-00005: DeploymentConfig/xmxviaenv: container 'bar' contains -Xmx in either, command, args or env. Instead, it is suggested you use the downward API to set the env 'CONTAINER_MAX_MEMORY'" ]
  [[ "${#lines[@]}" -eq 7 ]]
}

@test "policy/ocp/bestpractices/container_labelkey_inconsistent" {
  tmp=$(split_files "policy/ocp/bestpractices/container_labelkey_inconsistent/test_data/unit")

  cmd="conftest test ${tmp} --output tap --namespace ocp.bestpractices.container_labelkey_inconsistent --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "1..2" ]
  [ "${lines[1]}" = "not ok 1 - ${tmp}/list.yml - ocp.bestpractices.container_labelkey_inconsistent - RHCOP-OCP_BESTPRACT-00006: Deployment/nonestandardlabel: has a label key which did not start with 'app.kubernetes.io/' or 'redhat-cop.github.com/'. Found 'app=Foo'" ]
  [ "${lines[2]}" = "not ok 2 - ${tmp}/list.yml - ocp.bestpractices.container_labelkey_inconsistent - RHCOP-OCP_BESTPRACT-00006: DeploymentConfig/nonestandardlabel: has a label key which did not start with 'app.kubernetes.io/' or 'redhat-cop.github.com/'. Found 'app=Foo'" ]
  [[ "${#lines[@]}" -eq 3 ]]
}

@test "policy/ocp/bestpractices/container_liveness_readinessprobe_equal" {
  tmp=$(split_files "policy/ocp/bestpractices/container_liveness_readinessprobe_equal/test_data/unit")

  cmd="conftest test ${tmp} --output tap --namespace ocp.bestpractices.container_liveness_readinessprobe_equal --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "1..2" ]
  [ "${lines[1]}" = "not ok 1 - ${tmp}/list.yml - ocp.bestpractices.container_liveness_readinessprobe_equal - RHCOP-OCP_BESTPRACT-00007: Deployment/probssetaresame: container 'bar' livenessProbe and readinessProbe are equal, which is an anti-pattern." ]
  [ "${lines[2]}" = "not ok 2 - ${tmp}/list.yml - ocp.bestpractices.container_liveness_readinessprobe_equal - RHCOP-OCP_BESTPRACT-00007: DeploymentConfig/probssetaresame: container 'bar' livenessProbe and readinessProbe are equal, which is an anti-pattern." ]
  [[ "${#lines[@]}" -eq 3 ]]
}

@test "policy/ocp/bestpractices/container_livenessprobe_notset" {
  tmp=$(split_files "policy/ocp/bestpractices/container_livenessprobe_notset/test_data/unit")

  cmd="conftest test ${tmp} --output tap --namespace ocp.bestpractices.container_livenessprobe_notset --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "1..2" ]
  [ "${lines[1]}" = "not ok 1 - ${tmp}/list.yml - ocp.bestpractices.container_livenessprobe_notset - RHCOP-OCP_BESTPRACT-00008: Deployment/noproblivenessset: container 'bar' has no livenessProbe. See: https://docs.redhat.com/en/documentation/openshift_container_platform/4.18/html/building_applications/application-health" ]
  [ "${lines[2]}" = "not ok 2 - ${tmp}/list.yml - ocp.bestpractices.container_livenessprobe_notset - RHCOP-OCP_BESTPRACT-00008: DeploymentConfig/noproblivenessset: container 'bar' has no livenessProbe. See: https://docs.redhat.com/en/documentation/openshift_container_platform/4.18/html/building_applications/application-health" ]
  [[ "${#lines[@]}" -eq 3 ]]
}

@test "policy/ocp/bestpractices/container_readinessprobe_notset" {
  tmp=$(split_files "policy/ocp/bestpractices/container_readinessprobe_notset/test_data/unit")

  cmd="conftest test ${tmp} --output tap --namespace ocp.bestpractices.container_readinessprobe_notset --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "1..2" ]
  [ "${lines[1]}" = "not ok 1 - ${tmp}/list.yml - ocp.bestpractices.container_readinessprobe_notset - RHCOP-OCP_BESTPRACT-00009: Deployment/noreadinessprob: container 'bar' has no readinessProbe. See: https://docs.redhat.com/en/documentation/openshift_container_platform/4.18/html/building_applications/application-health" ]
  [ "${lines[2]}" = "not ok 2 - ${tmp}/list.yml - ocp.bestpractices.container_readinessprobe_notset - RHCOP-OCP_BESTPRACT-00009: DeploymentConfig/noreadinessprob: container 'bar' has no readinessProbe. See: https://docs.redhat.com/en/documentation/openshift_container_platform/4.18/html/building_applications/application-health" ]
  [[ "${#lines[@]}" -eq 3 ]]
}

@test "policy/ocp/bestpractices/container_resources_limits_cpu_set" {
  tmp=$(split_files "policy/ocp/bestpractices/container_resources_limits_cpu_set/test_data/unit")

  cmd="conftest test ${tmp} --output tap --namespace ocp.bestpractices.container_resources_limits_cpu_set --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "1..2" ]
  [ "${lines[1]}" = "not ok 1 - ${tmp}/list.yml - ocp.bestpractices.container_resources_limits_cpu_set - RHCOP-OCP_BESTPRACT-00010: Deployment/resourceslimitscpuset: container 'bar' has cpu limits (1). It is not recommended to limit cpu. See: https://www.reddit.com/r/kubernetes/comments/all1vg/on_kubernetes_cpu_limits" ]
  [ "${lines[2]}" = "not ok 2 - ${tmp}/list.yml - ocp.bestpractices.container_resources_limits_cpu_set - RHCOP-OCP_BESTPRACT-00010: DeploymentConfig/resourceslimitscpuset: container 'bar' has cpu limits (1). It is not recommended to limit cpu. See: https://www.reddit.com/r/kubernetes/comments/all1vg/on_kubernetes_cpu_limits" ]
  [[ "${#lines[@]}" -eq 3 ]]
}

@test "policy/ocp/bestpractices/container_resources_limits_memory_greater_than" {
  tmp=$(split_files "policy/ocp/bestpractices/container_resources_limits_memory_greater_than/test_data/unit")

  cmd="conftest test ${tmp} --output tap --namespace ocp.bestpractices.container_resources_limits_memory_greater_than --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "1..2" ]
  [ "${lines[1]}" = "not ok 1 - ${tmp}/list.yml - ocp.bestpractices.container_resources_limits_memory_greater_than - RHCOP-OCP_BESTPRACT-00011: Deployment/memorylimittoolarge: container 'bar' has a memory limit of '7Gi' which is larger than the upper '6Gi' limit." ]
  [ "${lines[2]}" = "not ok 2 - ${tmp}/list.yml - ocp.bestpractices.container_resources_limits_memory_greater_than - RHCOP-OCP_BESTPRACT-00011: DeploymentConfig/memorylimittoolarge: container 'bar' has a memory limit of '7Gi' which is larger than the upper '6Gi' limit." ]
  [[ "${#lines[@]}" -eq 3 ]]
}

@test "policy/ocp/bestpractices/container_resources_limits_memory_notset" {
  tmp=$(split_files "policy/ocp/bestpractices/container_resources_limits_memory_notset/test_data/unit")

  cmd="conftest test ${tmp} --output tap --namespace ocp.bestpractices.container_resources_limits_memory_notset --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "1..2" ]
  [ "${lines[1]}" = "not ok 1 - ${tmp}/list.yml - ocp.bestpractices.container_resources_limits_memory_notset - RHCOP-OCP_BESTPRACT-00012: Deployment/resourcelimitsmemorynotset: container 'bar' has no memory limits. It is recommended to limit memory, as memory always has a maximum. See: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers" ]
  [ "${lines[2]}" = "not ok 2 - ${tmp}/list.yml - ocp.bestpractices.container_resources_limits_memory_notset - RHCOP-OCP_BESTPRACT-00012: DeploymentConfig/resourcelimitsmemorynotset: container 'bar' has no memory limits. It is recommended to limit memory, as memory always has a maximum. See: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers" ]
  [[ "${#lines[@]}" -eq 3 ]]
}

@test "policy/ocp/bestpractices/container_resources_memoryunit_incorrect" {
  tmp=$(split_files "policy/ocp/bestpractices/container_resources_memoryunit_incorrect/test_data/unit")

  cmd="conftest test ${tmp} --output tap --namespace ocp.bestpractices.container_resources_memoryunit_incorrect --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "1..4" ]
  [ "${lines[1]}" = "not ok 1 - ${tmp}/list.yml - ocp.bestpractices.container_resources_memoryunit_incorrect - RHCOP-OCP_BESTPRACT-00013: Deployment/invalidresourcesrequestsmemoryunits: container 'bar' memory resources for limits or requests (2Gi / 100m) has an incorrect unit. See: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#resource-units-in-kubernetes" ]
  [ "${lines[2]}" = "not ok 2 - ${tmp}/list.yml - ocp.bestpractices.container_resources_memoryunit_incorrect - RHCOP-OCP_BESTPRACT-00013: Deployment/invalidresourceslimitsmemoryunits: container 'bar' memory resources for limits or requests (20000000m / 1Mi) has an incorrect unit. See: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#resource-units-in-kubernetes" ]
  [ "${lines[3]}" = "not ok 3 - ${tmp}/list.yml - ocp.bestpractices.container_resources_memoryunit_incorrect - RHCOP-OCP_BESTPRACT-00013: DeploymentConfig/invalidresourcesrequestsmemoryunits: container 'bar' memory resources for limits or requests (2Gi / 100m) has an incorrect unit. See: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#resource-units-in-kubernetes" ]
  [ "${lines[4]}" = "not ok 4 - ${tmp}/list.yml - ocp.bestpractices.container_resources_memoryunit_incorrect - RHCOP-OCP_BESTPRACT-00013: DeploymentConfig/invalidresourceslimitsmemoryunits: container 'bar' memory resources for limits or requests (20000000m / 1Mi) has an incorrect unit. See: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#resource-units-in-kubernetes" ]
  [[ "${#lines[@]}" -eq 5 ]]
}

@test "policy/ocp/bestpractices/container_resources_requests_cpuunit_incorrect" {
  tmp=$(split_files "policy/ocp/bestpractices/container_resources_requests_cpuunit_incorrect/test_data/unit")

  cmd="conftest test ${tmp} --output tap --namespace ocp.bestpractices.container_resources_requests_cpuunit_incorrect --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "1..2" ]
  [ "${lines[1]}" = "not ok 1 - ${tmp}/list.yml - ocp.bestpractices.container_resources_requests_cpuunit_incorrect - RHCOP-OCP_BESTPRACT-00014: Deployment/invalidresourcesrequestcpuunits container 'bar' cpu resources for requests (100M) has an incorrect unit. See: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#resource-units-in-kubernetes" ]
  [ "${lines[2]}" = "not ok 2 - ${tmp}/list.yml - ocp.bestpractices.container_resources_requests_cpuunit_incorrect - RHCOP-OCP_BESTPRACT-00014: DeploymentConfig/invalidresourcesrequestcpuunits container 'bar' cpu resources for requests (100M) has an incorrect unit. See: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#resource-units-in-kubernetes" ]
  [[ "${#lines[@]}" -eq 3 ]]
}

@test "policy/ocp/bestpractices/container_resources_requests_memory_greater_than" {
  tmp=$(split_files "policy/ocp/bestpractices/container_resources_requests_memory_greater_than/test_data/unit")

  cmd="conftest test ${tmp} --output tap --namespace ocp.bestpractices.container_resources_requests_memory_greater_than --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "1..2" ]
  [ "${lines[1]}" = "not ok 1 - ${tmp}/list.yml - ocp.bestpractices.container_resources_requests_memory_greater_than - RHCOP-OCP_BESTPRACT-00015: Deployment/memoryrequesttoolarge: container 'bar' has a memory request of '3Gi' which is larger than the upper '2Gi' limit." ]
  [ "${lines[2]}" = "not ok 2 - ${tmp}/list.yml - ocp.bestpractices.container_resources_requests_memory_greater_than - RHCOP-OCP_BESTPRACT-00015: DeploymentConfig/memoryrequesttoolarge: container 'bar' has a memory request of '3Gi' which is larger than the upper '2Gi' limit." ]
  [[ "${#lines[@]}" -eq 3 ]]
}

@test "policy/ocp/bestpractices/container_secret_mounted_envs" {
  tmp=$(split_files "policy/ocp/bestpractices/container_secret_mounted_envs/test_data/unit")

  cmd="conftest test ${tmp} --output tap --namespace ocp.bestpractices.container_secret_mounted_envs --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "1..2" ]
  [ "${lines[1]}" = "not ok 1 - ${tmp}/list.yml - ocp.bestpractices.container_secret_mounted_envs - RHCOP-OCP_BESTPRACT-00016: Deployment/secretenvvars: container 'bar' has a secret 'my-secret' mounted as an environment variable. Secrets are meant to be secret, it is not a good practice to mount them as env vars." ]
  [ "${lines[2]}" = "not ok 2 - ${tmp}/list.yml - ocp.bestpractices.container_secret_mounted_envs - RHCOP-OCP_BESTPRACT-00016: DeploymentConfig/secretenvvars: container 'bar' has a secret 'my-secret' mounted as an environment variable. Secrets are meant to be secret, it is not a good practice to mount them as env vars." ]
  [[ "${#lines[@]}" -eq 3 ]]
}

@test "policy/ocp/bestpractices/container_volumemount_inconsistent_path" {
  tmp=$(split_files "policy/ocp/bestpractices/container_volumemount_inconsistent_path/test_data/unit")

  cmd="conftest test ${tmp} --output tap --namespace ocp.bestpractices.container_volumemount_inconsistent_path --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "1..2" ]
  [ "${lines[1]}" = "not ok 1 - ${tmp}/list.yml - ocp.bestpractices.container_volumemount_inconsistent_path - RHCOP-OCP_BESTPRACT-00017: Deployment/notvarrunvolumemountspath: container 'bar' has a volumeMount 'my-secret' mountPath at '/some/random/path/my-secret'. A good practice is to use consistent mount paths, such as: /var/run/{organization}/{mount} - i.e.: /var/run/io.redhat-cop/my-secret" ]
  [ "${lines[2]}" = "not ok 2 - ${tmp}/list.yml - ocp.bestpractices.container_volumemount_inconsistent_path - RHCOP-OCP_BESTPRACT-00017: DeploymentConfig/notvarrunvolumemountspath: container 'bar' has a volumeMount 'my-secret' mountPath at '/some/random/path/my-secret'. A good practice is to use consistent mount paths, such as: /var/run/{organization}/{mount} - i.e.: /var/run/io.redhat-cop/my-secret" ]
  [[ "${#lines[@]}" -eq 3 ]]
}

@test "policy/ocp/bestpractices/container_volumemount_missing" {
  tmp=$(split_files "policy/ocp/bestpractices/container_volumemount_missing/test_data/unit")

  cmd="conftest test ${tmp} --output tap --namespace ocp.bestpractices.container_volumemount_missing --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "1..2" ]
  [ "${lines[1]}" = "not ok 1 - ${tmp}/list.yml - ocp.bestpractices.container_volumemount_missing - RHCOP-OCP_BESTPRACT-00018: Deployment/missingvolumemount: volume 'my-missing-pvc' does not have a volumeMount in any of the containers." ]
  [ "${lines[2]}" = "not ok 2 - ${tmp}/list.yml - ocp.bestpractices.container_volumemount_missing - RHCOP-OCP_BESTPRACT-00018: DeploymentConfig/missingvolumemount: volume 'my-missing-pvc' does not have a volumeMount in any of the containers." ]
  [[ "${#lines[@]}" -eq 3 ]]
}

@test "policy/ocp/bestpractices/deploymentconfig_triggers_containername" {
  tmp=$(split_files "policy/ocp/bestpractices/deploymentconfig_triggers_containername/test_data/unit")

  cmd="conftest test ${tmp} --output tap --namespace ocp.bestpractices.deploymentconfig_triggers_containername --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "1..1" ]
  [ "${lines[1]}" = "not ok 1 - ${tmp}/example.yml - ocp.bestpractices.deploymentconfig_triggers_containername - RHCOP-OCP_BESTPRACT-00027: DeploymentConfig/triggercontainernamemissmatch: has a imageChangeParams trigger with a miss-matching container name for 'foobar'" ]
  [[ "${#lines[@]}" -eq 2 ]]
}

@test "policy/ocp/bestpractices/deploymentconfig_triggers_notset" {
  tmp=$(split_files "policy/ocp/bestpractices/deploymentconfig_triggers_notset/test_data/unit")

  cmd="conftest test ${tmp} --output tap --namespace ocp.bestpractices.deploymentconfig_triggers_notset --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "1..1" ]
  [ "${lines[1]}" = "not ok 1 - ${tmp}/example.yml - ocp.bestpractices.deploymentconfig_triggers_notset - RHCOP-OCP_BESTPRACT-00019: DeploymentConfig/notriggers: has no triggers set. Could you use a k8s native Deployment? See: https://kubernetes.io/docs/concepts/workloads/controllers/deployment" ]
  [[ "${#lines[@]}" -eq 2 ]]
}

@test "policy/ocp/bestpractices/pod_hostnetwork" {
  tmp=$(split_files "policy/ocp/bestpractices/pod_hostnetwork/test_data/unit")

  cmd="conftest test ${tmp} --output tap --namespace ocp.bestpractices.pod_hostnetwork --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "1..2" ]
  [ "${lines[1]}" = "not ok 1 - ${tmp}/list.yml - ocp.bestpractices.pod_hostnetwork - RHCOP-OCP_BESTPRACT-00020: Deployment/hostnetworkisset: hostNetwork is present which gives the pod access to the loopback device, services listening on localhost, and could be used to snoop on network activity of other pods on the same node." ]
  [ "${lines[2]}" = "not ok 2 - ${tmp}/list.yml - ocp.bestpractices.pod_hostnetwork - RHCOP-OCP_BESTPRACT-00020: DeploymentConfig/hostnetworkisset: hostNetwork is present which gives the pod access to the loopback device, services listening on localhost, and could be used to snoop on network activity of other pods on the same node." ]
  [[ "${#lines[@]}" -eq 3 ]]
}

@test "policy/ocp/bestpractices/pod_replicas_below_one" {
  tmp=$(split_files "policy/ocp/bestpractices/pod_replicas_below_one/test_data/unit")

  cmd="conftest test ${tmp} --output tap --namespace ocp.bestpractices.pod_replicas_below_one --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "1..2" ]
  [ "${lines[1]}" = "not ok 1 - ${tmp}/list.yml - ocp.bestpractices.pod_replicas_below_one - RHCOP-OCP_BESTPRACT-00021: Deployment/replicaisone: replicas is 1 - expected replicas to be greater than 1 for HA guarantees." ]
  [ "${lines[2]}" = "not ok 2 - ${tmp}/list.yml - ocp.bestpractices.pod_replicas_below_one - RHCOP-OCP_BESTPRACT-00021: DeploymentConfig/replicaisone: replicas is 1 - expected replicas to be greater than 1 for HA guarantees." ]
  [[ "${#lines[@]}" -eq 3 ]]
}

@test "policy/ocp/bestpractices/pod_replicas_not_odd" {
  tmp=$(split_files "policy/ocp/bestpractices/pod_replicas_not_odd/test_data/unit")

  cmd="conftest test ${tmp} --output tap --namespace ocp.bestpractices.pod_replicas_not_odd --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "1..2" ]
  [ "${lines[1]}" = "not ok 1 - ${tmp}/list.yml - ocp.bestpractices.pod_replicas_not_odd - RHCOP-OCP_BESTPRACT-00022: Deployment/replicaiseven: replicas is 2 - expected an odd number for HA guarantees." ]
  [ "${lines[2]}" = "not ok 2 - ${tmp}/list.yml - ocp.bestpractices.pod_replicas_not_odd - RHCOP-OCP_BESTPRACT-00022: DeploymentConfig/replicaiseven: replicas is 2 - expected an odd number for HA guarantees." ]
  [[ "${#lines[@]}" -eq 3 ]]
}

@test "policy/ocp/bestpractices/rolebinding_roleref_apigroup_notset" {
  tmp=$(split_files "policy/ocp/bestpractices/rolebinding_roleref_apigroup_notset/test_data/unit")

  cmd="conftest test ${tmp} --output tap --namespace ocp.bestpractices.rolebinding_roleref_apigroup_notset --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "1..1" ]
  [ "${lines[1]}" = "not ok 1 - ${tmp}/example.yml - ocp.bestpractices.rolebinding_roleref_apigroup_notset - RHCOP-OCP_BESTPRACT-00023: RoleBinding/noapigroup: RoleBinding roleRef.apiGroup key is null, use rbac.authorization.k8s.io instead." ]
  [[ "${#lines[@]}" -eq 2 ]]
}

@test "policy/ocp/bestpractices/rolebinding_roleref_kind_notset" {
  tmp=$(split_files "policy/ocp/bestpractices/rolebinding_roleref_kind_notset/test_data/unit")

  cmd="conftest test ${tmp} --output tap --namespace ocp.bestpractices.rolebinding_roleref_kind_notset --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "1..1" ]
  [ "${lines[1]}" = "not ok 1 - ${tmp}/example.yml - ocp.bestpractices.rolebinding_roleref_kind_notset - RHCOP-OCP_BESTPRACT-00024: RoleBinding/nokind: RoleBinding roleRef.kind key is null, use ClusterRole or Role instead." ]
  [[ "${#lines[@]}" -eq 2 ]]
}

@test "policy/ocp/bestpractices/route_tls_termination_notset" {
  tmp=$(split_files "policy/ocp/bestpractices/route_tls_termination_notset/test_data/unit")

  cmd="conftest test ${tmp} --output tap --namespace ocp.bestpractices.route_tls_termination_notset --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "1..1" ]
  [ "${lines[1]}" = "not ok 1 - ${tmp}/example.yml - ocp.bestpractices.route_tls_termination_notset - RHCOP-OCP_BESTPRACT-00025: Route/tlsterminationnotset: TLS termination type not set. See https://docs.openshift.com/container-platform/4.6/networking/routes/secured-routes.html" ]
  [[ "${#lines[@]}" -eq 2 ]]
}

@test "policy/ocp/bestpractices/pod_antiaffinity_notset" {
  tmp=$(split_files "policy/ocp/bestpractices/pod_antiaffinity_notset/test_data/unit")

  cmd="conftest test ${tmp} --output tap --namespace ocp.bestpractices.pod_antiaffinity_notset --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "1..2" ]
  [ "${lines[1]}" = "not ok 1 - ${tmp}/list.yml - ocp.bestpractices.pod_antiaffinity_notset - RHCOP-OCP_BESTPRACT-00026: Deployment/podantiaffinitynotset: spec.affinity.podAntiAffinity not set. See: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#inter-pod-affinity-and-anti-affinity" ]
  [ "${lines[2]}" = "not ok 2 - ${tmp}/list.yml - ocp.bestpractices.pod_antiaffinity_notset - RHCOP-OCP_BESTPRACT-00026: DeploymentConfig/podantiaffinitynotset: spec.affinity.podAntiAffinity not set. See: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#inter-pod-affinity-and-anti-affinity" ]
  [[ "${#lines[@]}" -eq 3 ]]
}

####################
# ocp/deprecated
####################

@test "policy/ocp/deprecated/ocp3_11/buildconfig_v1" {
  tmp=$(split_files "policy/ocp/deprecated/ocp3_11/buildconfig_v1/test_data/unit")

  cmd="conftest test ${tmp} --output tap --namespace ocp.deprecated.ocp3_11.buildconfig_v1 --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "1..1" ]
  [ "${lines[1]}" = "not ok 1 - ${tmp}/example.yml - ocp.deprecated.ocp3_11.buildconfig_v1 - RHCOP-OCP_DEPRECATED-3.11-00001: BuildConfig/bar: API v1 for BuildConfig is no longer served by default, use build.openshift.io/v1 instead." ]
  [[ "${#lines[@]}" -eq 2 ]]
}

@test "policy/ocp/deprecated/ocp3_11/deploymentconfig_v1" {
  tmp=$(split_files "policy/ocp/deprecated/ocp3_11/deploymentconfig_v1/test_data/unit")

  cmd="conftest test ${tmp} --output tap --namespace ocp.deprecated.ocp3_11.deploymentconfig_v1 --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "1..1" ]
  [ "${lines[1]}" = "not ok 1 - ${tmp}/example.yml - ocp.deprecated.ocp3_11.deploymentconfig_v1 - RHCOP-OCP_DEPRECATED-3.11-00002: DeploymentConfig/bar: API v1 for DeploymentConfig is no longer served by default, use apps.openshift.io/v1 instead." ]
  [[ "${#lines[@]}" -eq 2 ]]
}

@test "policy/ocp/deprecated/ocp3_11/imagestream_v1" {
  tmp=$(split_files "policy/ocp/deprecated/ocp3_11/imagestream_v1/test_data/unit")

  cmd="conftest test ${tmp} --output tap --namespace ocp.deprecated.ocp3_11.imagestream_v1 --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "1..1" ]
  [ "${lines[1]}" = "not ok 1 - ${tmp}/example.yml - ocp.deprecated.ocp3_11.imagestream_v1 - RHCOP-OCP_DEPRECATED-3.11-00003: ImageStream/bar: API v1 for ImageStream is no longer served by default, use image.openshift.io/v1 instead." ]
  [[ "${#lines[@]}" -eq 2 ]]
}

@test "policy/ocp/deprecated/ocp3_11/projectrequest_v1" {
  tmp=$(split_files "policy/ocp/deprecated/ocp3_11/projectrequest_v1/test_data/unit")

  cmd="conftest test ${tmp} --output tap --namespace ocp.deprecated.ocp3_11.projectrequest_v1 --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "1..1" ]
  [ "${lines[1]}" = "not ok 1 - ${tmp}/example.yml - ocp.deprecated.ocp3_11.projectrequest_v1 - RHCOP-OCP_DEPRECATED-3.11-00004: ProjectRequest/bar: API v1 for ProjectRequest is no longer served by default, use project.openshift.io/v1 instead." ]
  [[ "${#lines[@]}" -eq 2 ]]
}

@test "policy/ocp/deprecated/ocp3_11/rolebinding_v1" {
  tmp=$(split_files "policy/ocp/deprecated/ocp3_11/rolebinding_v1/test_data/unit")

  cmd="conftest test ${tmp} --output tap --namespace ocp.deprecated.ocp3_11.rolebinding_v1 --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "1..1" ]
  [ "${lines[1]}" = "not ok 1 - ${tmp}/example.yml - ocp.deprecated.ocp3_11.rolebinding_v1 - RHCOP-OCP_DEPRECATED-3.11-00005: RoleBinding/bar: API v1 for RoleBinding is no longer served by default, use rbac.authorization.k8s.io/v1 instead." ]
  [[ "${#lines[@]}" -eq 2 ]]
}

@test "policy/ocp/deprecated/ocp3_11/route_v1" {
  tmp=$(split_files "policy/ocp/deprecated/ocp3_11/route_v1/test_data/unit")

  cmd="conftest test ${tmp} --output tap --namespace ocp.deprecated.ocp3_11.route_v1 --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "1..1" ]
  [ "${lines[1]}" = "not ok 1 - ${tmp}/example.yml - ocp.deprecated.ocp3_11.route_v1 - RHCOP-OCP_DEPRECATED-3.11-00006: Route/bar: API v1 for Route is no longer served by default, use route.openshift.io/v1 instead." ]
  [[ "${#lines[@]}" -eq 2 ]]
}

@test "policy/ocp/deprecated/ocp3_11/securitycontextconstraints_v1" {
  tmp=$(split_files "policy/ocp/deprecated/ocp3_11/securitycontextconstraints_v1/test_data/unit")

  cmd="conftest test ${tmp} --output tap --namespace ocp.deprecated.ocp3_11.securitycontextconstraints_v1 --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "1..1" ]
  [ "${lines[1]}" = "not ok 1 - ${tmp}/example.yml - ocp.deprecated.ocp3_11.securitycontextconstraints_v1 - RHCOP-OCP_DEPRECATED-3.11-00007: SecurityContextConstraints/bar: API v1 for SecurityContextConstraints is no longer served by default, use security.openshift.io/v1 instead." ]
  [[ "${#lines[@]}" -eq 2 ]]
}

@test "policy/ocp/deprecated/ocp3_11/template_v1" {
  tmp=$(split_files "policy/ocp/deprecated/ocp3_11/template_v1/test_data/unit")

  cmd="conftest test ${tmp} --output tap --namespace ocp.deprecated.ocp3_11.template_v1 --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "1..1" ]
  [ "${lines[1]}" = "not ok 1 - ${tmp}/example.yml - ocp.deprecated.ocp3_11.template_v1 - RHCOP-OCP_DEPRECATED-3.11-00008: Template/bar: API v1 for Template is no longer served by default, use template.openshift.io/v1 instead." ]
  [[ "${#lines[@]}" -eq 2 ]]
}

@test "policy/ocp/deprecated/ocp4_1/buildconfig_custom_strategy" {
  tmp=$(split_files "policy/ocp/deprecated/ocp4_1/buildconfig_custom_strategy/test_data/unit")

  cmd="conftest test ${tmp} --output tap --namespace ocp.deprecated.ocp4_1.buildconfig_custom_strategy --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "1..1" ]
  [ "${lines[1]}" = "not ok 1 - ${tmp}/example.yml - ocp.deprecated.ocp4_1.buildconfig_custom_strategy - RHCOP-OCP_DEPRECATED-4.1-00001: BuildConfig/custombuild: 'spec.strategy.customStrategy.exposeDockerSocket' is deprecated. If you want to continue using custom builds, you should replace your Docker invocations with Podman or Buildah." ]
  [[ "${#lines[@]}" -eq 2 ]]
}

@test "policy/ocp/deprecated/ocp4_2/authorization_openshift" {
  tmp=$(split_files "policy/ocp/deprecated/ocp4_2/authorization_openshift/test_data/unit")

  cmd="conftest test ${tmp} --output tap --namespace ocp.deprecated.ocp4_2.authorization_openshift --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "1..1" ]
  [ "${lines[1]}" = "not ok 1 - ${tmp}/example.yml - ocp.deprecated.ocp4_2.authorization_openshift - RHCOP-OCP_DEPRECATED-4.2-00001: ClusterRole/bar: API authorization.openshift.io for ClusterRole, ClusterRoleBinding, Role and RoleBinding is deprecated, use rbac.authorization.k8s.io/v1 instead." ]
  [[ "${#lines[@]}" -eq 2 ]]
}

@test "policy/ocp/deprecated/ocp4_2/automationbroker_v1alpha1" {
  tmp=$(split_files "policy/ocp/deprecated/ocp4_2/automationbroker_v1alpha1/test_data/unit")

  cmd="conftest test ${tmp} --output tap --namespace ocp.deprecated.ocp4_2.automationbroker_v1alpha1 --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "1..1" ]
  [ "${lines[1]}" = "not ok 1 - ${tmp}/example.yml - ocp.deprecated.ocp4_2.automationbroker_v1alpha1 - RHCOP-OCP_DEPRECATED-4.2-00002: Bundle/bar: automationbroker.io/v1alpha1 is deprecated." ]
  [[ "${#lines[@]}" -eq 2 ]]
}

@test "policy/ocp/deprecated/ocp4_2/catalogsourceconfigs_v1" {
  tmp=$(split_files "policy/ocp/deprecated/ocp4_2/catalogsourceconfigs_v1/test_data/unit")

  cmd="conftest test ${tmp} --output tap --namespace ocp.deprecated.ocp4_2.catalogsourceconfigs_v1 --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "1..1" ]
  [ "${lines[1]}" = "not ok 1 - ${tmp}/example.yml - ocp.deprecated.ocp4_2.catalogsourceconfigs_v1 - RHCOP-OCP_DEPRECATED-4.2-00003: CatalogSourceConfigs/bar: operators.coreos.com/v1 is deprecated." ]
  [[ "${#lines[@]}" -eq 2 ]]
}

@test "policy/ocp/deprecated/ocp4_2/catalogsourceconfigs_v2" {
  tmp=$(split_files "policy/ocp/deprecated/ocp4_2/catalogsourceconfigs_v2/test_data/unit")

  cmd="conftest test ${tmp} --output tap --namespace ocp.deprecated.ocp4_2.catalogsourceconfigs_v2 --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "1..1" ]
  [ "${lines[1]}" = "not ok 1 - ${tmp}/example.yml - ocp.deprecated.ocp4_2.catalogsourceconfigs_v2 - RHCOP-OCP_DEPRECATED-4.2-00004: CatalogSourceConfigs/bar: operators.coreos.com/v2 is deprecated." ]
  [[ "${#lines[@]}" -eq 2 ]]
}

@test "policy/ocp/deprecated/ocp4_2/operatorsources_v1" {
  tmp=$(split_files "policy/ocp/deprecated/ocp4_2/operatorsources_v1/test_data/unit")

  cmd="conftest test ${tmp} --output tap --namespace ocp.deprecated.ocp4_2.operatorsources_v1 --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "1..1" ]
  [ "${lines[1]}" = "not ok 1 - ${tmp}/example.yml - ocp.deprecated.ocp4_2.operatorsources_v1 - RHCOP-OCP_DEPRECATED-4.2-00005: OperatorSource/bar: operators.coreos.com/v1 is deprecated." ]
  [[ "${#lines[@]}" -eq 2 ]]
}

@test "policy/ocp/deprecated/ocp4_2/osb_v1" {
  tmp=$(split_files "policy/ocp/deprecated/ocp4_2/osb_v1/test_data/unit")

  cmd="conftest test ${tmp} --output tap --namespace ocp.deprecated.ocp4_2.osb_v1 --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "1..1" ]
  [ "${lines[1]}" = "not ok 1 - ${tmp}/example.yml - ocp.deprecated.ocp4_2.osb_v1 - RHCOP-OCP_DEPRECATED-4.2-00006: TemplateServiceBroker/bar: osb.openshift.io/v1 is deprecated." ]
  [[ "${#lines[@]}" -eq 2 ]]
}

@test "policy/ocp/deprecated/ocp4_2/servicecatalog_v1beta1" {
  tmp=$(split_files "policy/ocp/deprecated/ocp4_2/servicecatalog_v1beta1/test_data/unit")

  cmd="conftest test ${tmp} --output tap --namespace ocp.deprecated.ocp4_2.servicecatalog_v1beta1 --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "1..1" ]
  [ "${lines[1]}" = "not ok 1 - ${tmp}/example.yml - ocp.deprecated.ocp4_2.servicecatalog_v1beta1 - RHCOP-OCP_DEPRECATED-4.2-00007: ClusterServiceBroker/bar: servicecatalog.k8s.io/v1beta1 is deprecated." ]
  [[ "${#lines[@]}" -eq 2 ]]
}

@test "policy/ocp/deprecated/ocp4_3/buildconfig_jenkinspipeline_strategy" {
  tmp=$(split_files "policy/ocp/deprecated/ocp4_3/buildconfig_jenkinspipeline_strategy/test_data/unit")

  cmd="conftest test ${tmp} --output tap --namespace ocp.deprecated.ocp4_3.buildconfig_jenkinspipeline_strategy --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "1..1" ]
  [ "${lines[1]}" = "not ok 1 - ${tmp}/example.yml - ocp.deprecated.ocp4_3.buildconfig_jenkinspipeline_strategy - RHCOP-OCP_DEPRECATED-4.3-00001: BuildConfig/jenkinspipeline: 'spec.strategy.jenkinsPipelineStrategy' is deprecated. Use Jenkinsfiles directly on Jenkins or OpenShift Pipelines instead." ]
  [[ "${#lines[@]}" -eq 2 ]]
}

####################
# ocp/requiresinventory
####################

@test "policy/ocp/requiresinventory/deployment_has_matching_poddisruptionbudget" {
  tmp=$(split_files "policy/ocp/requiresinventory/deployment_has_matching_poddisruptionbudget/test_data/unit")
  inventory="policy/ocp/requiresinventory/data_inventory.rego"

  cmd="conftest test ${tmp} --output tap --namespace ocp.requiresinventory.deployment_has_matching_poddisruptionbudget --data ${inventory} --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "1..1" ]
  [ "${lines[1]}" = "not ok 1 - ${tmp}/list.yml - ocp.requiresinventory.deployment_has_matching_poddisruptionbudget - RHCOP-OCP_REQ_INV-00001: Deployment/hasmissingpdb does not have a policy/v1:PodDisruptionBudget or its selector labels dont match. See: https://kubernetes.io/docs/tasks/run-application/configure-pdb/#specifying-a-poddisruptionbudget" ]
  [[ "${#lines[@]}" -eq 2 ]]
}

@test "policy/ocp/requiresinventory/deployment_has_matching_pvc" {
  tmp=$(split_files "policy/ocp/requiresinventory/deployment_has_matching_pvc/test_data/unit")
  inventory="policy/ocp/requiresinventory/data_inventory.rego"

  cmd="conftest test ${tmp} --output tap --namespace ocp.requiresinventory.deployment_has_matching_pvc --data ${inventory} --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "1..1" ]
  [ "${lines[1]}" = "not ok 1 - ${tmp}/list.yml - ocp.requiresinventory.deployment_has_matching_pvc - RHCOP-OCP_REQ_INV-00002: Deployment/hasmissingpvc has persistentVolumeClaim in its spec.template.spec.volumes but could not find corrasponding v1:PersistentVolumeClaim." ]
  [[ "${#lines[@]}" -eq 2 ]]
}

@test "policy/ocp/requiresinventory/deployment_has_matching_service" {
  tmp=$(split_files "policy/ocp/requiresinventory/deployment_has_matching_service/test_data/unit")
  inventory="policy/ocp/requiresinventory/data_inventory.rego"

  cmd="conftest test ${tmp} --output tap --namespace ocp.requiresinventory.deployment_has_matching_service --data ${inventory} --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "1..1" ]
  [ "${lines[1]}" = "not ok 1 - ${tmp}/list.yml - ocp.requiresinventory.deployment_has_matching_service - RHCOP-OCP_REQ_INV-00003: Deployment/hasmissingsvc does not have a v1:Service or its selector labels dont match. See: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#service-and-replicationcontroller" ]
  [[ "${#lines[@]}" -eq 2 ]]
}

@test "policy/ocp/requiresinventory/deployment_has_matching_serviceaccount" {
  tmp=$(split_files "policy/ocp/requiresinventory/deployment_has_matching_serviceaccount/test_data/unit")
  inventory="policy/ocp/requiresinventory/data_inventory.rego"

  cmd="conftest test ${tmp} --output tap --namespace ocp.requiresinventory.deployment_has_matching_serviceaccount --data ${inventory} --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "1..1" ]
  [ "${lines[1]}" = "not ok 1 - ${tmp}/list.yml - ocp.requiresinventory.deployment_has_matching_serviceaccount - RHCOP-OCP_REQ_INV-00004: Deployment/hasmissingsvcaccount has spec.serviceAccountName 'foo' but could not find corrasponding v1:ServiceAccount." ]
  [[ "${#lines[@]}" -eq 2 ]]
}

@test "policy/ocp/requiresinventory/service_has_matching_servicemonitor" {
  tmp=$(split_files "policy/ocp/requiresinventory/service_has_matching_servicemonitor/test_data/unit")
  inventory="policy/ocp/requiresinventory/data_inventory.rego"

  cmd="conftest test ${tmp} --output tap --namespace ocp.requiresinventory.service_has_matching_servicemonitor --data ${inventory} --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "1..1" ]
  [ "${lines[1]}" = "not ok 1 - ${tmp}/list.yml - ocp.requiresinventory.service_has_matching_servicemonitor - RHCOP-OCP_REQ_INV-00005: Service/hasmissingsvcmon does not have a monitoring.coreos.com/v1:ServiceMonitor or its selector labels dont match. See: https://docs.openshift.com/container-platform/4.6/monitoring/enabling-monitoring-for-user-defined-projects.html" ]
  [[ "${#lines[@]}" -eq 2 ]]
}

####################
# podman
####################

@test "policy/podman/history/contains_layer" {
  tmp=$(split_files "policy/podman/history/contains_layer/test_data/unit/jenkins-python-mising.json" "true")
  parameters="policy/podman/data_parameters.rego"

  cmd="conftest test ${tmp}/jenkins-python-mising.json --output tap --namespace podman.history.contains_layer --data ${parameters} --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "1..1" ]
  [ "${lines[1]}" = "not ok 1 - ${tmp}/jenkins-python-mising.json - podman.history.contains_layer - RHCOP-PODMAN-00001: quay.io/redhat-cop/jenkins-agent-python:has-missing-sha: did not find expected SHA." ]
  [[ "${#lines[@]}" -eq 2 ]]
}

@test "policy/podman/images/image_size_not_greater_than" {
  tmp=$(split_files "policy/podman/images/image_size_not_greater_than/test_data/unit" "true")
  parameters="policy/podman/data_parameters.rego"

  cmd="conftest test ${tmp} --output tap --namespace podman.images.image_size_not_greater_than --data ${parameters} --rego-version v0"
  run ${cmd}

  print_info "${status}" "${output}" "${cmd}" "${tmp}"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "1..1" ]
  [ "${lines[1]}" = "not ok 1 - ${tmp}/jenkins-base.json - podman.images.image_size_not_greater_than - RHCOP-PODMAN-00002: quay.io/openshift/origin-jenkins-agent-base:4.4: has a size of '692.095652Mi', which is greater than '512Mi' limit." ]
  [[ "${#lines[@]}" -eq 2 ]]
}
