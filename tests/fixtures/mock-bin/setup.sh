#!/usr/bin/env bash
# Sets up PATH shims so the action can run end-to-end under act without real
# Steam credentials or a real game-ci CLI:
#   - bash: intercepts only the game-ci install.sh invocation
#     (`bash <tmp>/game-ci-install-<ver>.sh <ver> <destDir>`) and installs a
#     fake game-ci binary into <destDir>, printing its path on stdout exactly
#     like the real install.sh. Every other bash invocation is passed through.
#   - tar: intercepts only the extraction of Valve's steamcmd archive and drops
#     a fake steamcmd.sh that exits 0. Every other tar invocation passes through.
# The fake game-ci records its argv and the STEAM_* env it received under
# /tmp/steam-deploy-mock/out so tests can assert on the input mapping.
set -euo pipefail

MOCK=/tmp/steam-deploy-mock
rm -rf "$MOCK"
mkdir -p "$MOCK/bin" "$MOCK/out"

REAL_BASH="$(command -v bash)"
REAL_TAR="$(command -v tar)"
{
  echo "REAL_BASH='$REAL_BASH'"
  echo "REAL_TAR='$REAL_TAR'"
} > "$MOCK/real.env"

# Fake game-ci CLI
cat > "$MOCK/game-ci" <<'EOF'
#!/bin/sh
OUT=/tmp/steam-deploy-mock/out
mkdir -p "$OUT"
: > "$OUT/args.txt"
for a in "$@"; do
  printf '%s\n' "$a" >> "$OUT/args.txt"
done
{
  echo "STEAM_USERNAME=${STEAM_USERNAME-<unset>}"
  echo "STEAM_PASSWORD=${STEAM_PASSWORD-<unset>}"
  echo "STEAM_TOTP=${STEAM_TOTP-<unset>}"
  echo "STEAM_CONFIG_VDF_BASE64=${STEAM_CONFIG_VDF_BASE64-<unset>}"
  echo "STEAM_HOME=${STEAM_HOME-<unset>}"
} > "$OUT/env.txt"
echo "fake game-ci invoked: $*"
if [ -n "${FAKE_GAME_CI_FAIL:-}" ]; then
  echo "Steam deployment failed (simulated)" >&2
  exit 1
fi
if [ -n "${FAKE_GAME_CI_NO_BUILDID:-}" ]; then
  echo "Steam deployment finished without a build id (simulated)"
  exit 0
fi
echo "Steam deployment succeeded. BuildID: 987654"
exit 0
EOF
chmod 755 "$MOCK/game-ci"

# bash shim
cat > "$MOCK/bin/bash" <<'EOF'
#!/bin/sh
. /tmp/steam-deploy-mock/real.env
case "${1:-}" in
  *game-ci-install-*.sh)
    dest="${3:-/tmp/steam-deploy-mock/install}"
    mkdir -p "$dest"
    cp /tmp/steam-deploy-mock/game-ci "$dest/game-ci"
    chmod 755 "$dest/game-ci"
    echo "${2:-}" > /tmp/steam-deploy-mock/out/install-version.txt
    echo "fake install.sh: installed game-ci ${2:-} into $dest" >&2
    echo "$dest/game-ci"
    exit 0
    ;;
esac
exec "$REAL_BASH" "$@"
EOF
chmod 755 "$MOCK/bin/bash"

# tar shim
cat > "$MOCK/bin/tar" <<'EOF'
#!/bin/sh
. /tmp/steam-deploy-mock/real.env
archive=""
dir=""
prev=""
for a in "$@"; do
  case "$prev" in
    -xf|-f|-xzf|-zxf|-xvf|-xzvf|--file) archive="$a" ;;
    -C|--directory) dir="$a" ;;
  esac
  prev="$a"
done
case "$archive" in
  *steamcmd*)
    target="${dir:-.}"
    mkdir -p "$target"
    printf '#!/bin/sh\necho "fake steamcmd $*"\nexit 0\n' > "$target/steamcmd.sh"
    chmod 755 "$target/steamcmd.sh"
    echo "fake tar: wrote fake steamcmd.sh into $target"
    exit 0
    ;;
esac
exec "$REAL_TAR" "$@"
EOF
chmod 755 "$MOCK/bin/tar"

echo "$MOCK/bin" >> "$GITHUB_PATH"
echo "Mock shims installed in $MOCK/bin (real bash: $REAL_BASH, real tar: $REAL_TAR)"
