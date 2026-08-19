<!-- markdownlint-disable -->

# Hardening Report: game-ci--steam-deploy/v3.1.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **game-ci--steam-deploy/v3.1.0** was hardened automatically. 2 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

Workflow files reference actions pinned to mutable tags rather than full 40-character commit SHAs. This exposes the workflow to supply-chain attacks if the tag is moved. Failing references: `actions/checkout@v3` (main.yml) and `Actions-R-Us/actions-tagger@v2` (versioning.yml). These should be pinned to their full SHA digests, e.g. `actions/checkout@<40-hex-sha> # v3`.

Locations:

- `.github/workflows/main.yml:22`
- `.github/workflows/versioning.yml:9`

### missing-permissions (severity: medium)

Neither workflow file declares a top-level `permissions:` key, and no individual job within them declares job-level `permissions:` either. Without explicit permissions, workflows run with the repository's default token permissions, which may be overly broad (e.g. write access to contents). A minimal `permissions:` block should be added at the top level or per job.

Locations:

- `.github/workflows/main.yml:1`
- `.github/workflows/versioning.yml:1`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses, missing-permissions

**Notes:**

Fixed both workflow files: (1) Pinned actions/checkout@v3 to full SHA a37ce9120846195fa4ece8f58b268e6043cb2f26 in main.yml; (2) Pinned Actions-R-Us/actions-tagger@v2 to full SHA 330ddfac760021349fef7ff62b372f2f691c20fb in versioning.yml; (3) Added `permissions: {}` to main.yml (no GITHUB_TOKEN permissions needed); (4) Added `permissions: contents: write` to versioning.yml (the actions-tagger action requires write access to push/update tags).

