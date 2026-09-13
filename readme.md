# colibri-bin

AUR package for [colibri](https://github.com/JustVugg/colibri) prebuilt Linux releases.

## Always

Generate .SRCINFO

`makepkg --printsrcinfo > .SRCINFO`

## release package

``` bash

makepkg --printsrcinfo > .SRCINFO
git add PKGBUILD .SRCINFO
git commit -m "useful commit message"
git push aur master

```

## Auto-update (GitHub Actions)

Scheduled workflow (every 6 hours) plus manual `workflow_dispatch`:

1. `find_release.sh` checks GitHub releases for a newer `pkgver`
2. bumps `pkgver` / resets `pkgrel`, regenerates checksums via `./test`
3. pushes `PKGBUILD` + `.SRCINFO` to the AUR
4. commits the same bump back to `main`

Required repository secret:

- `AUR_SSH_PRIVATE_KEY` — private key registered on your AUR account
