# Upstream Contribution Guide

This branch (`upstream-friendly`) contains commits curated for the
upstream project at [accso/SecureCheckPlus](https://github.com/accso/SecureCheckPlus).

It is maintained as a separate branch in this fork so upstream
maintainers can review and cherry-pick what they want.

## What's Included

### 3-tier Architecture (7 commits)
- `1439f23` Sponsored docker container for the frontend (Stefan Schubert)
- `3b4822d` refactor: implement 3-tier architecture (Stefan Schubert)
- `44743e6` refactor: migrate to 3-tier architecture (Stefan Schubert)
- `612cb25` chore: remove deprecated frontend/src/api/apiClient.ts
- `5258cc0` Migrate API routes to explicit api/ prefix
- `e7a6030` Add Docker 3-tier deployment configuration
- `062d2ae` Add 3-tier Docker deployment and frontend infrastructure (Stefan Schubert)

### Cleanup Commits (5 commits)
- `611f68e` chore: fix .gitignore conflict marker, restore render import
- `6790b49` docs: align preview/prod runtime guidance
- `e0092fb` fix(runtime): stabilize preview and align CI with prod
- `404edcb` test: mock NVD API calls, add nvd_integration marker
- `8021630` fix: address PR review comments

### E2E Test Infrastructure (3 commits)
- `9e592b7` test: add e2e marker to pytest config
- `0e5bf12` test: add end-to-end report analysis tests
- `d964cc8` ci: add e2e_test job to CI pipeline

### Bug Fixes (2 commits)
- `f9dbe39` fix: add missing HtmlView/AppView import in urls.py
- `a43e840` ci: fix requirements-dev.txt reference in e2e job

### Security Fixes (9 commits)
- `0cecfbe` security: fix timing attack on API key verification (C1)
- `b7465e1` security: prevent LDAP injection via username escaping (C2)
- `a930cb2` security: guard dev auth with IS_DEV check (C3)
- `e9a7a44` security: add permission check to DeleteProjectAPI (H1)
- `35967e1` security: validate CVE ID format and add request timeouts (H2)
- `8b267d9` security: whitelist templates in HtmlView (H5)
- `8f820e0` security: remove duplicate api_404_view function (M4)
- `5446d66` security: improve Docker security configuration (L1/L2/L3)
- `a1784bb` security: rate limiting, dev creds, CORS, HTTPS settings (H3/H4/M2/M3)

### Parser Bug Fixes + Tests (5 commits)
- `0f9cad3` fix(parser): handle dict input in cyclonedx parser
- `a9f190f` fix(parser): dedupe CVEs by (name, version) in trivy parser
- `6ddd720` test: add unit tests for trivy and cyclonedx parsers
- `12c8320` test(e2e): add e2e tests for trivy and cyclonedx report upload
- `8683b55` test: add trivy and cyclonedx test fixtures

### Doc Updates (1 commit)
- `a09bd39` docs: update outdated content to match 3-tier architecture and current parsers

## What's Excluded

### Already in upstream (10 commits)
These were cherry-picked from upstream and are already part of their history:
- Cherry-picked upstream PRs (#10, #22, #38, #44) and related fixes
- Profile picture fix, row clickable, CVSS tooltips, field lengths

### Operational/Personal (4 commits)
- `3464060` chore: attribute CSP dicebear fix to upstream PR #45 (internal bookkeeping)
- `00e9d84` chore: attribute gunicorn reactivation to upstream PR #54 (internal bookkeeping)
- `e018a73` devx: add dev-up.sh wrapper (dev preference)
- `b767eb8` docs: fix broken link to renamed Server Installation Readme (our fork cleanup)

### Preview Seeding (1 commit)
- `66e5b3d` feat: add preview data seeding (dev preference, not for upstream)

### German Documentation (1 commit)
- `3a80f15` Add deployment documentation (contains PROJEKTUEBERSICHT_3TIER.md, German-only)

## How to Use This Branch

To cherry-pick specific commits into upstream:

```bash
git remote add xminhx https://github.com/xMinhx/SecureCheckNext.git
git fetch xminhx upstream-friendly
git cherry-pick <commit-sha>
```

Or to review the full set of changes:

```bash
git diff upstream/main..xminhx/upstream-friendly
```

## Security Fix Details

The security fixes (C1, C2, C3, H1, H2, H5, M4, L1-L3, H3+H4+M2+M3) were
identified during a security audit of the codebase. Each commit is
a minimal, targeted change with a clear security justification in
its commit message.

**Recommended order for upstream review:**
1. C1 (timing attack) - simplest, highest impact
2. C2 (LDAP injection) - simple, high impact
3. H1 (IDOR) - 2 lines
4. M4 (duplicate view) - pure deletion
5. C3, H2, H5, L1-L3, H3+H4+M2+M3 - review individually

## Test Coverage

- 75 unit tests pass
- 7 end-to-end tests pass (including trivy and cyclonedx upload)
- All security fixes covered by tests where applicable
