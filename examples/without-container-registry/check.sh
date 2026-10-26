#!/bin/sh
# Temporary ER-10 check, runs as an after_apply hook of the "No container registry" test case.
# Never prints output values: kubernetes_secrets holds the database password. Only key names are printed.
set -eu
TF=$(command -v tofu || command -v terraform)
fail=0

absent() { # <output> <regex>: no line of the output matches the regex
  if "$TF" output -raw "$1" | grep -qE "$2"; then
    echo "FAIL: $1 has keys matching '$2':"
    "$TF" output -raw "$1" | grep -oE "^[[:space:]]*(export )?[A-Za-z_]*($2)[A-Za-z_]*" || true
    fail=1
  else
    echo "ok: $1 has no keys matching '$2'"
  fi
}

present() { # <output> <fixed string>: sanity check that the output rendered at all
  if "$TF" output -raw "$1" | grep -qF "$2"; then
    echo "ok: $1 contains '$2'"
  else
    echo "FAIL: $1 does not contain '$2'"
    fail=1
  fi
}

is_null() { # <output>
  v=$("$TF" output -json "$1")
  if [ "$v" = "null" ]; then echo "ok: $1 is null"; else echo "FAIL: $1 is $v"; fail=1; fi
}

absent shell 'IMAGE|CONTAINER_REGISTRY'
absent kubernetes_secrets 'IMAGE'
absent helm_values '[Ii]mage'
present shell 'export AKS_CLUSTER_NAME='
present kubernetes_secrets 'name: spacelift-shared'
present helm_values 'serverHostname:'
is_null private_container_registry_name
is_null public_container_registry_name

n=$("$TF" state list | grep -c 'container_registry' || true)
if [ "$n" = "0" ]; then echo "ok: no container_registry resources in the state"; else echo "FAIL: $n container_registry resources in the state"; fail=1; fi
echo "resources in the state: $("$TF" state list | wc -l)"

# helm_values has no secrets: printed for the local helm template check.
echo "----- BEGIN helm_values -----"
"$TF" output -raw helm_values
echo "----- END helm_values -----"

[ "$fail" = "0" ] && echo "ALL CHECKS PASSED" || { echo "SOME CHECKS FAILED"; exit 1; }
