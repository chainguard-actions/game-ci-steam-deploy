<!-- markdownlint-disable -->

# Hardening Report: game-ci--steam-deploy/v3.0.3

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **game-ci--steam-deploy/v3.0.3** was hardened automatically. 2 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

Workflow files reference GitHub Actions using mutable version tags instead of pinned full-length SHA commit hashes. This exposes the workflow to supply-chain attacks if the tag is moved to a malicious commit. Failing references: `actions/checkout@v3` in main.yml and `Actions-R-Us/actions-tagger@v2` in versioning.yml.

Locations:

- `.github/workflows/main.yml:27`
- `.github/workflows/versioning.yml:11`

### missing-permissions (severity: medium)

Neither `.github/workflows/main.yml` nor `.github/workflows/versioning.yml` has a top-level `permissions:` key, and no individual job within either file defines a `permissions:` block. Without explicit permissions, the GITHUB_TOKEN is granted its default (potentially broad) permissions, violating the principle of least privilege.

Locations:

- `.github/workflows/main.yml:1`
- `.github/workflows/versioning.yml:1`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses, missing-permissions

**Notes:**

Fixed both workflow files:

1. `.github/workflows/main.yml`:
   - Added `permissions: {}` top-level block (no GitHub token permissions needed)
   - Pinned `actions/checkout@v3` → `actions/checkout@f43a0e5ff2bd294095638e18286ca9a3d1956744 # v3`

2. `.github/workflows/versioning.yml`:
   - Added `permissions: contents: write` top-level block (required for actions-tagger to create/update git tags)
   - Pinned `Actions-R-Us/actions-tagger@v2` → `Actions-R-Us/actions-tagger@330ddfac760021349fef7ff62b372f2f691c20fb # v2`

