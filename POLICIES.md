# Policies

|API Groups|Kinds|Description|
|---|---|---|
|apps.openshift.io/v1, apps|DeploymentConfig, DaemonSet, Deployment, StatefulSet|violation: Check if all kinds contain labels as suggested by https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels|
|apps.openshift.io/v1|DeploymentConfig|violation: Check if 'spec.triggers' is set|
|rbac.authorization.k8s.io/v1|RoleBinding|violation: Check if 'roleRef.apiGroup' is set|
|rbac.authorization.k8s.io/v1|RoleBinding|violation: Check if 'roleRef.kind' is set|
|automationbroker.io/v1alpha1|*|violation: Check for deprecated apiVersion: https://docs.openshift.com/container-platform/4.2/release_notes/ocp-4-2-release-notes.html#ocp-4-2-deprecated-features|
|catalogsourceconfigs.operators.coreos.com|v1*|violation: Check for deprecated apiVersion: https://docs.openshift.com/container-platform/4.2/release_notes/ocp-4-2-release-notes.html#ocp-4-2-deprecated-features|
|catalogsourceconfigs.operators.coreos.com|v2*|violation: Check for deprecated apiVersion: https://docs.openshift.com/container-platform/4.2/release_notes/ocp-4-2-release-notes.html#ocp-4-2-deprecated-features|
|operatorsources.operators.coreos.com|v1*|violation: Check for deprecated apiVersion: https://docs.openshift.com/container-platform/4.2/release_notes/ocp-4-2-release-notes.html#ocp-4-2-deprecated-features|
|osb.openshift.io|v1*|violation: Check for deprecated apiVersion: https://docs.openshift.com/container-platform/4.2/release_notes/ocp-4-2-release-notes.html#ocp-4-2-deprecated-features|
|servicecatalog.k8s.io/v1beta1|*|violation: Check for deprecated apiVersion: https://docs.openshift.com/container-platform/4.2/release_notes/ocp-4-2-release-notes.html#ocp-4-2-deprecated-features|
|v1|BuildConfig|violation: Check for deprecated apiVersion. Expect build.openshift.io/v1|
|v1|DeploymentConfig|violation: Check for deprecated apiVersion. Expect apps.openshift.io/v1|
|v1|ImageStream|violation: Check for deprecated apiVersion. Expect image.openshift.io/v1|
|v1|ProjectRequest|violation: Check for deprecated apiVersion. Expect project.openshift.io/v1|
|v1|RoleBinding|violation: Check for deprecated apiVersion. Expect rbac.authorization.k8s.io/v1|
|v1|Route|violation: Check for deprecated apiVersion. Expect route.openshift.io/v1|
|v1|SecurityContextConstraints|violation: Check for deprecated apiVersion. Expect security.openshift.io/v1|
|v1|Template|violation: Check for deprecated apiVersion. Expect template.openshift.io/v1|
|containers-cop.redhat.com/v1|PodmanHistory|warn: Check the image contains a SHA in its layers|
|containers-cop.redhat.com/v1|PodmanImages|warn: Check the image size is not greater than a value in Mi|
