# METADATA
# title: 'RHCOP-OCP_DEPRECATED-4_2-00006: osb openshift io v1 is deprecated'
# description: |-
#   'osb.openshift.io/v1' is deprecated in OCP 4.2 and removed in 4.5.
#   See: https://docs.openshift.com/container-platform/4.2/release_notes/ocp-4-2-release-notes.html#ocp-4-2-deprecated-features
#   See: https://docs.openshift.com/container-platform/4.5/release_notes/ocp-4-5-release-notes.html#ocp-4-5-deprecated-removed-features
# custom:
#   matchers:
#     kinds:
#     - apiGroups:
#       - osb.openshift.io
#       kinds:
#       - AutomationBroker
#       - TemplateServiceBroker
#   skipConstraint: true
package ocp.deprecated.ocp4_2.osb_v1

import data.lib.konstraint.core as konstraint_core

violation[msg] {
	contains(lower(konstraint_core.api_version), "osb.openshift.io/v1")

	msg := konstraint_core.format_with_id(sprintf("%s/%s: osb.openshift.io/v1 is deprecated.", [konstraint_core.kind, konstraint_core.name]), "RHCOP-OCP_DEPRECATED-4.2-00006")
}
