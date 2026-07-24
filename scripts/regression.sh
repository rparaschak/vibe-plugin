#!/usr/bin/env bash
# regression.sh — mechanical regression checks for the vibe plugin templates.
# Plain bash + POSIX tools + git, no other dependencies. Run from anywhere;
# resolves the repo root itself. Prints PASS/FAIL per check; exits non-zero
# if any check fails.

set -uo pipefail

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT" || exit 1

PASS_COUNT=0
FAIL_COUNT=0

pass() { echo "PASS: $1"; PASS_COUNT=$((PASS_COUNT + 1)); }
fail() { echo "FAIL: $1"; FAIL_COUNT=$((FAIL_COUNT + 1)); }

echo "== vibe regression checks (root: $ROOT) =="
echo

# ---------------------------------------------------------------------------
# 1. Implement-preset identity: plan-implement/implement.md and
#    spec-plan-implement/implement.md are deliberately kept in sync. They may
#    differ only on line 1 (the template-version header names its own path).
# ---------------------------------------------------------------------------
A=presets/plan-implement/implement.md
B=presets/spec-plan-implement/implement.md
if [ -f "$A" ] && [ -f "$B" ]; then
  if diff -q <(tail -n +2 "$A") <(tail -n +2 "$B") >/dev/null; then
    pass "1. implement-preset identity ($A == $B past header line)"
  else
    fail "1. implement-preset identity — diverged past header line:"
    diff <(tail -n +2 "$A") <(tail -n +2 "$B") | sed 's/^/    /'
  fi
else
  fail "1. implement-preset identity — missing file(s): $A / $B"
fi
echo

# ---------------------------------------------------------------------------
# 2. No project-shape runtime branching in stamped surfaces. A hit is only
#    legitimate if explicitly whitelisted (one "path:line" per row) in
#    scripts/banned-phrases-whitelist.txt — that file does not exist today,
#    so every hit currently fails the check.
# ---------------------------------------------------------------------------
BANNED='if the project has|when a frontend exists|if your project uses|depending on the project'
WHITELIST="scripts/banned-phrases-whitelist.txt"
DIRS="presets templates/skeletons templates/agents templates/checklists templates/kernel"
HITS="$(grep -rniE "$BANNED" $DIRS 2>/dev/null || true)"
if [ -n "$HITS" ] && [ -f "$WHITELIST" ]; then
  KEPT=""
  while IFS= read -r line; do
    loc="$(echo "$line" | cut -d: -f1,2)"
    grep -qxF "$loc" "$WHITELIST" || KEPT="${KEPT}${line}"$'\n'
  done <<< "$HITS"
  HITS="$(echo "$KEPT" | sed '/^$/d')"
fi
if [ -z "$HITS" ]; then
  pass "2. no banned project-shape branching phrases in stamped surfaces"
else
  fail "2. banned project-shape phrases found (whitelist unmatched or absent):"
  echo "$HITS" | sed 's/^/    /'
fi
echo

# ---------------------------------------------------------------------------
# 3. Agent budget: every templates/agents/*.md is <=70 lines and its
#    frontmatter has name:, description:, effort:.
# ---------------------------------------------------------------------------
CHECK3_FAIL=0
for f in templates/agents/*.md; do
  [ -f "$f" ] || continue
  lines=$(wc -l < "$f" | tr -d ' ')
  fm=$(awk '/^---$/{c++; next} c==1' "$f")
  missing=""
  echo "$fm" | grep -q '^name:'        || missing="$missing name"
  echo "$fm" | grep -q '^description:' || missing="$missing description"
  echo "$fm" | grep -q '^effort:'      || missing="$missing effort"
  if [ "$lines" -gt 70 ] || [ -n "$missing" ]; then
    CHECK3_FAIL=1
    echo "    FAIL detail: $f (lines=$lines, missing frontmatter:${missing:- none})"
  fi
done
if [ "$CHECK3_FAIL" -eq 0 ]; then
  pass "3. agent budget (templates/agents/*.md <=70 lines, name/description/effort present)"
else
  fail "3. agent budget — see FAIL detail lines above"
fi
echo

# ---------------------------------------------------------------------------
# 4. Kernel naming: every templates/kernel/*.md has a frontmatter name: from
#    the closed kernel set (unprefixed since the vibe-* rename) and is <=80
#    lines.
# ---------------------------------------------------------------------------
CHECK4_FAIL=0
for f in templates/kernel/*.md; do
  [ -f "$f" ] || continue
  lines=$(wc -l < "$f" | tr -d ' ')
  name=$(awk -F': ' '/^name:/{print $2; exit}' "$f")
  case "$name" in
    team-protocol|research-protocol|review-protocol|task-ledger|loop-protocol) named=1 ;;
    *) named=0 ;;
  esac
  if [ "$lines" -gt 80 ] || [ "$named" -eq 0 ]; then
    CHECK4_FAIL=1
    echo "    FAIL detail: $f (lines=$lines, name='$name')"
  fi
done
if [ "$CHECK4_FAIL" -eq 0 ]; then
  pass "4. kernel naming (templates/kernel/*.md name: in the kernel set, <=80 lines)"
else
  fail "4. kernel naming — see FAIL detail lines above"
fi
echo

# ---------------------------------------------------------------------------
# 5. Kernel reference integrity: every task-ledger / research-protocol
#    / team-protocol / review-protocol / loop-protocol reference in presets/,
#    templates/skeletons/, templates/agents/ resolves to a templates/kernel/
#    file whose frontmatter name matches. Stamped project-specific skills
#    (e.g. <domain>-review) are out of scope.
# ---------------------------------------------------------------------------
CHECK5_FAIL=0
KNAMES=$(grep -rhoE '(task-ledger|research-protocol|team-protocol|review-protocol|loop-protocol)' \
  presets templates/skeletons templates/agents 2>/dev/null | sort -u)
if [ -z "$KNAMES" ]; then
  CHECK5_FAIL=1
  echo "    FAIL detail: no kernel-skill references found at all (unexpected)"
else
  for kname in $KNAMES; do
    match=$(grep -rl "^name: $kname\$" templates/kernel/*.md 2>/dev/null)
    if [ -z "$match" ]; then
      CHECK5_FAIL=1
      echo "    FAIL detail: $kname is referenced but no templates/kernel/*.md declares it"
    fi
  done
fi
if [ "$CHECK5_FAIL" -eq 0 ]; then
  pass "5. kernel reference integrity (all referenced kernel skills resolve)"
else
  fail "5. kernel reference integrity — see FAIL detail lines above"
fi
echo

# ---------------------------------------------------------------------------
# 6. Anti-packing (WARN-only): command-standard's packing rule bans bundling
#    multiple sequential steps into one line, not raw line length — a single
#    dense clause or long gate line is legal. Length is only a review pointer,
#    so long lines are listed as warnings and never fail the run.
# ---------------------------------------------------------------------------
OFFENDERS=$(awk 'length > 500 {print FILENAME":"FNR" ("length" chars)"}' presets/*/*.md)
if [ -z "$OFFENDERS" ]; then
  pass "6. anti-packing pointer (no presets/*/*.md line exceeds 500 chars)"
else
  pass "6. anti-packing pointer — WARN: long lines worth a packing review (not a failure):"
  echo "$OFFENDERS" | sed 's/^/    WARN /'
fi
echo

# ---------------------------------------------------------------------------
# 7. Skeleton slot integrity: command-skeleton.md contains exactly the
#    expected {{PLACEHOLDER}} slots, and {{FLOW}} — the one flow slot per
#    standards/composition-standard.md — appears exactly once.
# ---------------------------------------------------------------------------
SKEL=templates/skeletons/command-skeleton.md
EXPECTED="DESCRIPTION FLOW FLOW_SPEC OPT_OUTS PRESET ROLE_SUMMARY"
if [ -f "$SKEL" ]; then
  ACTUAL=$(grep -oE '\{\{[A-Z_]+\}\}' "$SKEL" | tr -d '{}' | sort -u | tr '\n' ' ' | sed 's/ $//')
  FLOWCOUNT=$(grep -oE '\{\{FLOW\}\}' "$SKEL" | wc -l | tr -d ' ')
  if [ "$ACTUAL" = "$EXPECTED" ] && [ "$FLOWCOUNT" -eq 1 ]; then
    pass "7. skeleton slot integrity (slots: $ACTUAL; {{FLOW}} appears once)"
  else
    fail "7. skeleton slot integrity — expected [$EXPECTED], got [$ACTUAL], {{FLOW}} count=$FLOWCOUNT"
  fi
else
  fail "7. skeleton slot integrity — missing $SKEL"
fi
echo

echo "== Summary: $PASS_COUNT passed, $FAIL_COUNT failed =="
[ "$FAIL_COUNT" -eq 0 ]
