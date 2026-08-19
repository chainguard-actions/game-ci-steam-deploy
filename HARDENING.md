<!-- markdownlint-disable -->

# Hardening Report: game-ci--steam-deploy/v3.2.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **game-ci--steam-deploy/v3.2.1** was hardened automatically. 2 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

Both workflow files reference external actions by mutable tag rather than a full 40-character commit SHA. This means a compromised or force-pushed tag could silently substitute malicious code. Affected references: `actions/checkout@v3` in main.yml and `Actions-R-Us/actions-tagger@v2` in versioning.yml. Pin each to its full SHA, e.g. `actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v3`.

Locations:

- `.github/workflows/main.yml:30`
- `.github/workflows/versioning.yml:12`

### missing-permissions (severity: medium)

Neither workflow file declares a top-level `permissions:` block, and no individual job within either file declares job-level permissions. Without explicit permissions, the default GITHUB_TOKEN grants broad access (read on most scopes, write on contents for workflows triggered by push/PR). Both files should declare minimal required permissions at the top level or per job.

Locations:

- `.github/workflows/main.yml:1`
- `.github/workflows/versioning.yml:1`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses, missing-permissions

**Notes:**

Fixed both workflow files: (1) Pinned actions/checkout@v3 → @a37ce9120846195fa4ece8f58b268e6043cb2f26 # v3 in main.yml; pinned Actions-R-Us/actions-tagger@v2 → @330ddfac760021349fef7ff62b372f2f691c20fb # v2 in versioning.yml. (2) Added top-level `permissions: {}` to both files. In versioning.yml, granted `contents: write` at the job level for the updateMajorTag job since actions-tagger needs to push/update tags.

