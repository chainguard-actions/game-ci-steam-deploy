<!-- markdownlint-disable -->

# Hardening Report: game-ci--steam-deploy/v3.0.2

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **game-ci--steam-deploy/v3.0.2** was hardened automatically. 2 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### permissions (severity: medium)

missing-permissions: The workflow file has no top-level `permissions:` key and no job-level `permissions:` keys on any job. Without explicit permissions, the GITHUB_TOKEN is granted its default (often broad) permissions. All jobs in this workflow lack a permissions block.

Locations:

- `.github/workflows/main.yml:1`
- `.github/workflows/versioning.yml:1`

### unpinned-uses (severity: high)

One or more `uses:` references are pinned to a mutable tag rather than an immutable 40-character commit SHA, making the workflow vulnerable to supply-chain attacks if the tag is moved. Failing references: `actions/checkout@v3` (main.yml line ~30) and `Actions-R-Us/actions-tagger@v2` (versioning.yml line ~10).

Locations:

- `.github/workflows/main.yml:30`
- `.github/workflows/versioning.yml:10`

## Iteration Notes

### Iteration 1

**Fixes applied:** permissions, unpinned-uses

**Notes:**

Fixed both findings across two workflow files:

1. **missing-permissions** (main.yml & versioning.yml): Added `permissions: {}` at the top level of both files. In main.yml, both jobs also received `permissions: {}` since they require no special GITHUB_TOKEN access. In versioning.yml, the `updateMajorTag` job received `permissions: { contents: write }` because the actions-tagger action needs to write git tags.

2. **unpinned-uses** (main.yml & versioning.yml): Pinned `actions/checkout@v3` → `actions/checkout@a37ce9120846195fa4ece8f58b268e6043cb2f26 # v3` in main.yml, and pinned `Actions-R-Us/actions-tagger@v2` → `Actions-R-Us/actions-tagger@330ddfac760021349fef7ff62b372f2f691c20fb # v2` in versioning.yml. Original tags preserved as comments for readability.

