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

## Continuous Simplification Gate

- Before each implementation step, record a reproducible handwritten source
  LOC baseline for its exact scope. Use the same command and scope afterward,
  then report the baseline, final count, and net change.
- Complete a step or run only when net maintained production and test source
  LOC decreases. Exclude generated, vendored, lock, cache, and build output.
- Offset additions by deleting more duplication, obsolete branches, wrappers,
  helpers, compatibility scaffolding, or parallel implementations. Prefer one
  canonical flow and fewer concepts over equivalent reorganization.
- Preserve required behavior, tests, type safety, coverage, compatibility,
  documentation, validation, security, observability, and error handling.
- Never manufacture reduction with minification, line packing, formatting
  tricks, generated-code moves, or deletion of valuable tests or docs. If safe
  reduction is not possible, leave the step incomplete and report the blocker.

## Public Boundary

Never add credentials, private paths or hosts, customer or account data,
internal architecture or operations, private plans, research, task state,
agent prompts, or non-public release evidence. Use product-facing commit and
pull-request text without agent attribution unless the user requests it.
