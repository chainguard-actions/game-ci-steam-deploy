<!-- markdownlint-disable -->

# Hardening Report: game-ci--steam-deploy/v3.2.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **game-ci--steam-deploy/v3.2.0** was hardened automatically. 2 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### missing-permissions (severity: medium)

The workflow file has no top-level `permissions:` key and no job-level `permissions:` keys on any job. Without explicit permissions, the GITHUB_TOKEN is granted default (potentially write) permissions, violating the principle of least privilege.

Locations:

- `.github/workflows/main.yml:1`
- `.github/workflows/versioning.yml:1`

### unpinned-uses (severity: high)

One or more `uses:` references are pinned to mutable tags rather than immutable 40-character commit SHAs, making the workflow vulnerable to supply-chain attacks if the tag is moved. Failing references: `actions/checkout@v3` (main.yml) and `Actions-R-Us/actions-tagger@v2` (versioning.yml).

Locations:

- `.github/workflows/main.yml:28`
- `.github/workflows/versioning.yml:9`

## Iteration Notes

### Iteration 1

**Fixes applied:** missing-permissions, unpinned-uses

**Notes:**

Fixed both workflow files: (1) Added `permissions: {}` at the top level of main.yml and versioning.yml to enforce least-privilege defaults. In versioning.yml, added a job-level `permissions: contents: write` override for the updateMajorTag job since actions-tagger needs to push tags. (2) Pinned `actions/checkout@v3` → `@a37ce9120846195fa4ece8f58b268e6043cb2f26 # v3` in main.yml, and `Actions-R-Us/actions-tagger@v2` → `@330ddfac760021349fef7ff62b372f2f691c20fb # v2` in versioning.yml.

