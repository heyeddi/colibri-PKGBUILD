#!/usr/bin/env bash
set -euo pipefail

# Detect a newer JustVugg/colibri GitHub release than PKGBUILD's pkgver.
# Writes build.env with pkgver=... when an update is available (CI dotenv style).

rm -f build.env

current_version=$(grep -Po "^pkgver=\K.*" PKGBUILD)
version=""

for _ in $(seq 1 5); do
  version=$(curl -fsSL https://api.github.com/repos/JustVugg/colibri/releases/latest | jq -r '.tag_name')
  if [ -n "$version" ] && [ "$version" != "null" ]; then
    break
  fi
  sleep 5
done

if [ -z "$version" ] || [ "$version" = "null" ]; then
  echo "Failed to get version from GitHub API" >&2
  exit 1
fi

version=${version#v}

echo "current version is $current_version"
echo "found version $version"

if [ "$current_version" = "$version" ]; then
  echo "No new version"
  exit 0
fi

# Ensure the Linux x86_64 asset exists for this tag before bumping.
asset="colibri-v${version}-linux-x86_64.tar.gz"
asset_url="https://github.com/JustVugg/colibri/releases/download/v${version}/${asset}"
if ! curl -fsSIL "$asset_url" >/dev/null; then
  echo "Release v${version} has no ${asset} yet; skipping" >&2
  exit 0
fi

echo "Found version $version"
echo "pkgver=$version" > build.env
