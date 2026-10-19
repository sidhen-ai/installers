# SIDHEN Installers

Public bootstrap scripts for SIDHEN software. Each installer lives in its own
directory and is fetched with `curl` from this repository.

## Installers

| Directory | What it installed | Status |
|---|---|---|
| [`rath-deploy/`](./rath-deploy/README.md) | The SIDHEN local stack on macOS: clones the private `rath-deploy` repository and the service repositories it needs into `~/rath-deploy`, and adds the `rath` command | **Retired (2026-10-19).** A SIDHEN device now runs its services through cairn-shell; do not use this installer for new machines. Kept for history. |

There is no installer here that is in current use.

## GitHub token

The `rath-deploy` installer asks for a GitHub fine-grained personal access
token with read access (Contents, Metadata) to the private SIDHEN repositories
it clones. Its README has the steps.

## Support

For issues or questions, contact the SIDHEN engineering team.
