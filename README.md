# Install Zig Action

Installs Zig compiler in GitHub Actions runner.

## Inputs

- `version` (optional): Zig version. Default: latest stable. Use `dev` or `master` for latest development version.

## Example usage

```yaml
uses: jetsung/install-zig@v1
with:
  version: "0.14.1"
