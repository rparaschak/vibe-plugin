#!/usr/bin/env bash
# compose-check.sh — mechanical composition-budget regression check.
#
# IMPORTANT — this is a SIMULATION, not the builder. It approximates what
# `/vibe:build-harness` would stamp for each preset by mechanically injecting
# a preset's FLOW block into templates/skeletons/command-skeleton.md and
# stripping builder-facing annotations, so we can regression-check the two
# numbers standards/command-standard.md rule 1 makes mechanical: (a) zero
# unresolved {{PLACEHOLDER}} tokens survive composition, and (b) the composed
# line count stays within budget. It does NOT reproduce every builder rule
# (see "Known simplifications" below) — for the real thing, run
# /vibe:build-harness.
#
# Files read at RUN TIME (never snapshotted here), so this always checks
# the current tree:
#   - templates/skeletons/command-skeleton.md
#   - presets/plan-implement/{plan,implement}.md
#   - presets/spec-plan-implement/{spec,plan,implement}.md
#
# Composition rules modeled, quoting standards/composition-standard.md:
#   - FLOW extraction: "Presets live at `presets/<preset>/*.md`; ... and one
#     FLOW block (between `<!-- FLOW … -->` and `<!-- FLOW END -->`),
#     injected into `command-skeleton.md`'s single `{{FLOW}}` slot." We pull
#     exactly the lines strictly between those two marker lines.
#   - W-E (strip): "strip **every** builder-facing annotation from output in
#     ALL cases: ... every `<!-- BUILDER… -->` / `<!-- FILL… -->` / rationale
#     comment, and every `>` blockquote meta-note ... These are authoring-time
#     notes, never runtime text." We strip every HTML comment (multi-line
#     aware) and every line starting with `>`, EXCEPT the two comment lines
#     that command-standard.md rule 3 and composition-standard.md's "Regen
#     stamp" bullet require to survive as literal (resolved) output: the
#     `<!-- vibe-template: ... -->` header and the `<!-- vibe:regen ... -->`
#     stamp. Those are not builder annotations — they are mandatory generated
#     headers — so assertion (c) below allows only those two, and fails on
#     any other surviving `<!--`.
#   - W-H (blank lines): "emit exactly one blank line immediately above and
#     below the injected {{FLOW}} content, regardless of the source file's
#     blank lines." We approximate this, plus the blank lines left behind by
#     stripped annotation lines, by squeezing runs of blank lines to one
#     (`cat -s`) across the whole composed body.
#   - Placeholder resolution: DESCRIPTION/OPT_OUTS/PRESET/FLOW_SPEC/
#     ROLE_SUMMARY are "filled from project context at stamp time" (not from
#     the preset file), and FLOW-embedded ones (e.g. {{PLAN_TEMPLATE_PATH}},
#     or {{CMD_PLAN}}/{{CMD_IMPLEMENT}}/{{CMD_SPEC}} resolved by the real
#     builder from COMMAND_PREFIX) per W-A "still resolve every embedded
#     {{PLACEHOLDER}}". We dummy-fill every remaining `{{TOKEN}}` generically
#     — real values don't matter for a budget/placeholder-count regression
#     check; CMD_* tokens are covered by that same generic fill.
#
# Known simplifications (deliberately NOT modeled — none affect pass/fail
# for the current tree; flagged here for honesty):
#   - W-F (opt-out line omission when OPT_OUTS is empty, e.g. both implement
#     presets) is not modeled: we always emit a dummy non-empty `opt-out:`
#     line. Real /implement composition omits this line, so this simulation
#     over-counts /implement by up to 1 line versus the true builder output
#     — a conservative (safe) direction for a ≤80 budget check.
#   - The "Generated-command header" rule (composition-standard.md: the
#     stamped header must name `presets/<preset>/<cmd>.md`, never the
#     skeleton) is not rewritten — we pass the skeleton's own header line
#     through unchanged. It carries no `{{...}}` token so this does not
#     affect either assertion.
#   - The regen stamp's "one side must be the empty string" rule is not
#     modeled; both {{PRESET}} and {{FLOW_SPEC}} get non-empty dummies. Same
#     line either way — no effect on line count or placeholder assertions.
#
# Budget classification (standards/command-standard.md rule 1): "implement-
# ation-loop-shaped = its `## Outline` contains a repeat/until step over a
# work ledger; all others are entry commands." Of the 5 presets, only the two
# `implement.md` files are implementation-loop-shaped (they walk /implement's
# task ledger) => budget 80. The three `plan.md`/`spec.md` files are design-
# phase entry commands => budget 200 (command-standard.md rule 1 upper bound;
# we don't enforce its 50-line floor here — this script only checks what the
# task requires).
#
# Style: plain bash + POSIX tools (awk/sed/grep/cat), set -uo pipefail,
# pass/fail counters, resolves repo root via git rev-parse, exits non-zero on
# any failure — matching scripts/regression.sh.

set -uo pipefail

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT" || exit 1

SKELETON="templates/skeletons/command-skeleton.md"

PASS_COUNT=0
FAIL_COUNT=0

pass() { echo "PASS: $1"; PASS_COUNT=$((PASS_COUNT + 1)); }
fail() { echo "FAIL: $1"; FAIL_COUNT=$((FAIL_COUNT + 1)); }

echo "== vibe compose-check: composed-command budget simulation (root: $ROOT) =="
echo

if [ ! -f "$SKELETON" ]; then
  fail "compose-check — missing skeleton: $SKELETON"
  echo
  echo "== Summary: $PASS_COUNT passed, $FAIL_COUNT failed =="
  exit 1
fi

TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

# Strip every HTML comment (multi-line aware) from a file, passed on stdin,
# written to stdout. Consumes lines with getline until a comment closes.
strip_comments() {
  awk '
  {
    line = $0
    out = ""
    while (1) {
      start = index(line, "<!--")
      if (start == 0) { out = out line; break }
      out = out substr(line, 1, start - 1)
      rest = substr(line, start)
      endpos = index(rest, "-->")
      if (endpos > 0) {
        line = substr(rest, endpos + 3)
        continue
      } else {
        closed = 0
        while ((getline nextline) > 0) {
          endpos2 = index(nextline, "-->")
          if (endpos2 > 0) {
            line = substr(nextline, endpos2 + 3)
            closed = 1
            break
          }
        }
        if (!closed) { line = "" }
        continue
      }
    }
    print out
  }
  '
}

# Args: preset_file budget label
check_preset() {
  local preset_file="$1" budget="$2" label="$3"

  if [ ! -f "$preset_file" ]; then
    fail "$label — missing preset file: $preset_file"
    echo
    return
  fi

  if ! grep -q '^<!-- FLOW: ' "$preset_file" || ! grep -q '^<!-- FLOW END -->' "$preset_file"; then
    fail "$label — no FLOW … / FLOW END markers found in $preset_file"
    echo
    return
  fi

  # 1. Extract the FLOW slice: strictly between the two marker lines.
  sed -n '/^<!-- FLOW: /,/^<!-- FLOW END -->/p' "$preset_file" | sed '1d;$d' > "$TMPDIR/flow.txt"

  # 2. Split the skeleton into HEAD (frontmatter + mandatory template-header +
  #    regen-stamp lines, which survive verbatim per command-standard rule 3
  #    and composition-standard's Regen-stamp bullet) and BODY (everything
  #    else, where {{FLOW}} lives and where builder annotations get stripped).
  local regen_line
  regen_line=$(grep -n '^<!-- vibe:regen' "$SKELETON" | head -1 | cut -d: -f1)
  if [ -z "$regen_line" ]; then
    fail "$label — no vibe:regen header line found in $SKELETON"
    echo
    return
  fi
  sed -n "1,${regen_line}p" "$SKELETON" > "$TMPDIR/head.txt"
  sed -n "$((regen_line + 1)),\$p" "$SKELETON" > "$TMPDIR/body.txt"

  # 3. Inject the FLOW slice in place of the {{FLOW}} line.
  sed -e '/^{{FLOW}}$/{' -e "r $TMPDIR/flow.txt" -e 'd' -e '}' \
    "$TMPDIR/body.txt" > "$TMPDIR/body_composed.txt"

  # 4. W-E: strip every builder annotation comment (BODY only — HEAD's two
  #    lines are mandatory generated headers, not annotations) and every `>`
  #    blockquote meta-note line.
  strip_comments < "$TMPDIR/body_composed.txt" | grep -v '^>' > "$TMPDIR/body_stripped.txt"

  # 5. Recombine, then squeeze blank-line runs to one (W-H's net effect, plus
  #    cleanup of blanks left by now-deleted annotation lines).
  cat "$TMPDIR/head.txt" "$TMPDIR/body_stripped.txt" > "$TMPDIR/composed_raw.txt"
  cat -s "$TMPDIR/composed_raw.txt" > "$TMPDIR/composed_squeezed.txt"

  # 6. Dummy-fill every remaining {{TOKEN}} generically (skeleton-level and
  #    any FLOW-embedded ones, e.g. {{PLAN_TEMPLATE_PATH}}).
  sed -E 's/\{\{([A-Za-z_]+)\}\}/DUMMY_\1/g' "$TMPDIR/composed_squeezed.txt" > "$TMPDIR/composed.txt"

  local composed="$TMPDIR/composed.txt"
  local line_count placeholder_count bad_comments bad_quotes ok=1

  line_count=$(wc -l < "$composed" | tr -d ' ')
  placeholder_count=$(grep -oE '\{\{[A-Za-z_]+\}\}' "$composed" | wc -l | tr -d ' ')
  bad_comments=$(grep -n '<!--' "$composed" | grep -vE '^[0-9]+:<!-- vibe-template:|^[0-9]+:<!-- vibe:regen' || true)
  bad_quotes=$(grep -n '^>' "$composed" || true)

  echo "  $label: composed line count = $line_count (budget: <= $budget)"

  if [ "$placeholder_count" -ne 0 ]; then
    ok=0
    echo "    detail: $placeholder_count unresolved {{...}} placeholder(s):"
    grep -noE '\{\{[A-Za-z_]+\}\}' "$composed" | sed 's/^/      /'
  fi

  if [ "$line_count" -gt "$budget" ]; then
    ok=0
    echo "    detail: line count $line_count exceeds budget $budget"
  fi

  if [ -n "$bad_comments" ]; then
    ok=0
    echo "    detail: builder annotation comment(s) survived stripping:"
    echo "$bad_comments" | sed 's/^/      /'
  fi

  if [ -n "$bad_quotes" ]; then
    ok=0
    echo "    detail: blockquote meta-note line(s) survived stripping:"
    echo "$bad_quotes" | sed 's/^/      /'
  fi

  if [ "$ok" -eq 1 ]; then
    pass "$label ($preset_file): $line_count lines, 0 unresolved placeholders, no surviving annotations"
  else
    fail "$label ($preset_file) — see detail lines above"
  fi
  echo
}

check_preset "presets/plan-implement/plan.md"                200 "plan-implement/plan (entry)"
check_preset "presets/plan-implement/implement.md"            80  "plan-implement/implement (implementation-loop)"
check_preset "presets/spec-plan-implement/spec.md"           200  "spec-plan-implement/spec (entry)"
check_preset "presets/spec-plan-implement/plan.md"           200  "spec-plan-implement/plan (entry)"
check_preset "presets/spec-plan-implement/implement.md"       80  "spec-plan-implement/implement (implementation-loop)"

echo "== Summary: $PASS_COUNT passed, $FAIL_COUNT failed =="
[ "$FAIL_COUNT" -eq 0 ]
