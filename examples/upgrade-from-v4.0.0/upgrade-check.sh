TF=$(command -v tofu || command -v terraform || true)
[ -n "$TF" ] && [ -x "$TF" ] || { echo "FAIL: neither tofu nor terraform found on PATH ($PATH)"; exit 1; }
echo "using $TF ($("$TF" version | head -n 1))"
#!/bin/sh
# Temporary ER-10 check, runs as an after_apply hook of the "Upgrade from v4.0.0" test case.
# The example was just applied with the v4.0.0 release. This swaps the module source to the
# branch code (../..), re-inits and plans: anything but moves is a failure. Then it restores
# the v4.0.0 source, so the destroy phase runs on the code that created the resources.
# Prints only resource addresses and plan summaries, never attribute values.
set -eu
TF=$(command -v tofu || command -v terraform || true)
[ -n "$TF" ] && [ -x "$TF" ] || { echo "FAIL: neither tofu nor terraform found on PATH ($PATH)"; exit 1; }
echo "using $TF ($("$TF" version | head -n 1))"
OLD='source = "github.com/spacelift-io/terraform-azure-spacelift-selfhosted?ref=v4.0.0"'
NEW='source = "../.."'
PLAN=$(mktemp)
PLANFILE=$(mktemp)
PENDING=$(mktemp)
trap 'rm -f "$PLAN" "$PLANFILE" "$PENDING"' EXIT
fail=0

plan() { # <label>; sets rc, writes the plan to $PLANFILE and the text to $PLAN
  set +e
  "$TF" plan -input=false -lock=false -no-color -detailed-exitcode -out="$PLANFILE" >"$PLAN" 2>&1
  rc=$?
  set -e
  echo "== $1: plan exit code $rc"
  grep -E '^  # |^Plan:|^No changes|^Error|^│ Error' "$PLAN" || true
}

# Passes when nothing but moves is pending: a moves-only plan exits 2, so the exit code alone is not enough.
# Reads only actions and addresses from the JSON plan, never values (the plan holds secrets).
no_changes() {
  [ "$rc" = "0" ] && return 0
  [ "$rc" = "2" ] || return 1
  "$TF" show -json "$PLANFILE" | jq -r '
    (.resource_changes // [])[] | select(.change.actions != ["no-op"]) | "  pending: \(.change.actions | join(",")) \(.address)"' >"$PENDING"
  "$TF" show -json "$PLANFILE" | jq -r '
    (.output_changes // {}) | to_entries[] | select(.value.actions != ["no-op"]) | "  pending output: \(.value.actions | join(",")) \(.key)"' >>"$PENDING"
  cat "$PENDING"
  [ ! -s "$PENDING" ]
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
  echo "moved resources: $("$TF" show -json "$PLANFILE" | jq '[(.resource_changes // [])[] | select(.previous_address != null)] | length')"
else
  echo "FAIL: the branch plans changes on a v4.0.0 install"
  fail=1
fi

cp main.tf.orig main.tf && rm main.tf.orig
"$TF" init -input=false -no-color >/dev/null
echo "restored the v4.0.0 source for the destroy phase"

[ "$fail" = "0" ] && echo "ALL CHECKS PASSED" || { echo "SOME CHECKS FAILED"; exit 1; }
