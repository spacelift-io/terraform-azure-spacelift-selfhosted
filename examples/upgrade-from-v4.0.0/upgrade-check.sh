#!/bin/sh
# Temporary ER-10 check, runs as an after_apply hook of the "Upgrade from v4.0.0" test case.
# The example was just applied with the v4.0.0 release. This swaps the module source to the
# branch code (../..), re-inits and plans: anything but moves is a failure. Then it restores
# the v4.0.0 source, so the destroy phase runs on the code that created the resources.
# Prints only resource addresses and plan summaries, never attribute values.
set -eu
TF=$(command -v tofu || command -v terraform)
OLD='source = "github.com/spacelift-io/terraform-azure-spacelift-selfhosted?ref=v4.0.0"'
NEW='source = "../.."'
PLAN=$(mktemp)
fail=0

plan() { # <label>; sets rc
  set +e
  "$TF" plan -input=false -lock=false -no-color -detailed-exitcode >"$PLAN" 2>&1
  rc=$?
  set -e
  echo "== $1: plan exit code $rc"
  grep -E '^  # |^Plan:|^No changes|^Error|^│ Error' "$PLAN" || true
}

no_changes() { # rc 0, or rc 2 with nothing to add, change or destroy (moves only)
  [ "$rc" = "0" ] || { [ "$rc" = "2" ] && grep -q 'Plan: 0 to add, 0 to change, 0 to destroy' "$PLAN"; }
}

cp main.tf main.tf.orig
grep -qF "$OLD" main.tf

plan "baseline on v4.0.0"
no_changes || echo "WARN: the v4.0.0 baseline is not clean, changes below are not caused by the branch"

sed -i "s|$OLD|$NEW|" main.tf
grep -F 'source =' main.tf
"$TF" init -input=false -no-color >/dev/null
plan "upgrade to the branch"
if no_changes; then
  echo "ok: the branch plans no changes on a v4.0.0 install"
  moved=$(grep -c 'has moved to' "$PLAN" || true)
  echo "moved resources: $moved"
else
  echo "FAIL: the branch plans changes on a v4.0.0 install"
  fail=1
fi

cp main.tf.orig main.tf && rm main.tf.orig
"$TF" init -input=false -no-color >/dev/null
echo "restored the v4.0.0 source for the destroy phase"

[ "$fail" = "0" ] && echo "ALL CHECKS PASSED" || { echo "SOME CHECKS FAILED"; exit 1; }
