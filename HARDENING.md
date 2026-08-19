<!-- markdownlint-disable -->

# Hardening Report: game-ci--steam-deploy/v3.0.4

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **game-ci--steam-deploy/v3.0.4** was hardened automatically. 2 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

Workflow files reference actions using mutable tag refs instead of pinned full-length SHA digests, making them vulnerable to supply-chain attacks if the tag is moved. Failing references: `actions/checkout@v3` in main.yml and `Actions-R-Us/actions-tagger@v2` in versioning.yml.

Locations:

- `.github/workflows/main.yml:30`
- `.github/workflows/versioning.yml:10`

### missing-permissions (severity: medium)

Neither workflow file defines a top-level `permissions:` key, and no job in either file defines job-level permissions. Without explicit permissions, workflows run with the default (potentially broad) token permissions, violating the principle of least privilege.

Locations:

- `.github/workflows/main.yml:1`
- `.github/workflows/versioning.yml:1`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses, missing-permissions

**Notes:**

Fixed both workflow files: (1) Pinned actions/checkout@v3 to SHA a37ce9120846195fa4ece8f58b268e6043cb2f26 in main.yml and Actions-R-Us/actions-tagger@v2 to SHA 330ddfac760021349fef7ff62b372f2f691c20fb in versioning.yml, preserving original tags as comments. (2) Added top-level `permissions: {}` to main.yml (no token permissions needed for test deployment workflow) and `permissions: contents: write` to versioning.yml (required for the actions-tagger to push/update Git tags on release).

