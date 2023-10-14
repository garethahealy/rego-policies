package lib.konstraint.rbac

import future.keywords.in

import data.lib.konstraint.core

rule_has_verb(rule, verb) {
    verbs := ["*", lower(verb)]
    verbs[_] == lower(rule.verbs[_])
}

rule_has_resource_type(rule, type) {
    types := ["*", lower(type)]
    types[_] == lower(rule.resources[_])
}

rule_has_resource_name(rule, name) {
    name in rule.resourceNames
}

rule_has_resource_name(rule, name) {
    core.missing_field(rule, "resourceNames")
}
