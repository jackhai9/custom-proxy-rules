# Custom Proxy Rules

<p align="center">
  <a href="README.zh-CN.md">简体中文</a> | English
</p>

> Legacy: this workflow targeted the old `~/.config/clash` profile layout and is no longer used by the current ClashX Meta setup. The repository is kept as historical reference.

This repository keeps custom Clash proxy rules in Git and applies them to local Clash YAML profiles through a pre-commit hook. It is designed for personal rule maintenance when subscription updates would otherwise overwrite manual edits.

## Problem

Clash profiles are often regenerated from provider subscriptions. Manual edits to those generated YAML files are easy to lose after the next subscription refresh.

## Approach

Keep personal rules in this repository, then let the hook merge those rules into local Clash config files before commit.

Current source rule file:

- `custom-rules.yaml`

Local target directory:

- `$HOME/.config/clash/*.yaml`

## Setup

```bash
bash setup-hooks.sh
chmod +x .git/hooks/pre-commit
chmod +x merge2config.sh
```

After setup, edit `custom-rules.yaml` and commit the change. The pre-commit hook runs `merge2config.sh`, which inserts missing rules under the `rules:` section of local Clash YAML files.

If Clash does not pick up the changes automatically, reload the config from the Clash UI.

## Notes

- Rule insertion is additive.
- Removing or changing a rule in `custom-rules.yaml` does not automatically remove or rewrite existing local Clash profile entries.
- Review the generated local Clash config before relying on new routing behavior.

## License

MIT. See [LICENSE](LICENSE).
