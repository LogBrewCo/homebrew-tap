# LogBrew Homebrew Tap Agent Guide

This public guide applies to the whole repository. Keep every file, branch
name, commit, pull request, check log, and release note suitable for permanent
public history.

## Ownership and Source of Truth

- This tap owns `Formula/logbrew.rb` and its public installation metadata.
  `README.md` owns the repository purpose.
- The protected `LogBrewCo/cli` release and its published platform artifacts
  own version, URL, archive, and SHA-256 truth. Normal formula updates come
  from that repository's release workflow.
- Do not change versions, URLs, checksums, aliases, installation behavior, or
  release metadata from a draft, local build, inferred value, or unverified
  artifact.

## Working and Verification

- Start with `git status --short --branch`, inspect current `main` and the
  focused diff, and preserve unrelated work.
- For a formula change, verify the exact public release tag and every referenced
  artifact before editing. Keep platform entries aligned as one release.
- Run `ruby -c Formula/logbrew.rb` and `brew style Formula/logbrew.rb`.
  Release-affecting formula changes also require
  `brew audit --strict --online --formula Formula/logbrew.rb` plus the owning
  CLI release workflow's install evidence.
- Do not publish, retag, dispatch another release, or alter registry state
  unless the task explicitly owns that action.

## Code Review Rules

- Flag a formula not bound to one verified public CLI release, any
  platform/version/URL/checksum mismatch, generated structure changed without
  its source workflow, or an install claim without exact artifact evidence.
- The safe path is to correct the CLI release owner and regenerate the formula.
  A manual tap repair is an exception only when the task explicitly owns
  recovery, verifies every digest, and records how generated state is
  reconciled.
- Keep formatting and other mechanical policy in Homebrew checks rather than
  expanding this guide.

## Simplicity

- Write the least code that fully meets the requirement. Prefer deleting,
  reusing, or extending the existing owner over adding wrappers, helpers, or
  parallel paths.
- Report each change's net handwritten line count. Never trade required
  behavior, tests, validation, or security for fewer lines, and never
  manufacture reductions through formatting or generated-code moves.

## Public Boundary

Never add credentials, private paths or hosts, customer or account data,
internal architecture or operations, private plans, research, task state,
agent prompts, or non-public release evidence. Use product-facing commit and
pull-request text without agent attribution unless the user requests it.

Commits, pull-request titles and bodies, branch names, READMEs, and release
notes describe user-visible behavior only. Do not name hosting, network,
storage, or deployment internals, non-public repositories, local paths,
plans, agent sessions, costs, or real user data. Do not add AI attribution.

`scripts/public-guard.sh` enforces this. The required `Public guard` status
scans every new commit, commit message, changed path, branch name, and
pull-request title and body. Run `bash scripts/public-guard.sh install` once
per checkout to scan commit messages and pushes locally. Never use
`--no-verify`. If a finding is a false positive, change the rule in its own
pull request first; never split, encode, or reword text only to pass the
guard.

Formula updates from the CLI release arrive on a `formula/<version>` branch.
The `Promote formula update` job scans the branch, reports the status, and
fast-forwards `main`.
