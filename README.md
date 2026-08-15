# AnubisQuantumCipher Homebrew Tap

The native R2 developer preview builds the exact tagged source locally:

```bash
brew trust --formula anubisquantumcipher/tap/desktidy-r2-preview
brew install anubisquantumcipher/tap/desktidy-r2-preview
desktidy-r2-preview
```

This preview is ad-hoc signed, not Developer ID signed or notarized. Homebrew
installation does not load, unload, register, replace, or enable a Desktop
service. It does not require a Gatekeeper bypass or `--no-quarantine`.
The trust command is deliberately limited to this formula, not the whole tap.

The old `desktidy` CLI formula is disabled because its `setup` command installs
the retired Desktop authority. Do not run it alongside native DeskTidy.

| Formula | Description |
|---|---|
| [`desktidy-r2-preview`](https://github.com/AnubisQuantumCipher/desktidy) | Source-built native developer preview for Apple silicon, macOS 14+ |
| `desktidy` | Disabled legacy CLI; do not install alongside native DeskTidy |
