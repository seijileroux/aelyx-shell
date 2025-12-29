#!/usr/bin/env bash
set -Eeuo pipefail

CONFIG="$HOME/.local/share/aelyx/user/config.json"
QS_DIR="$HOME/.config/quickshell"
REPO="xZepyx/aelyx-shell"
API="https://api.github.com/repos/$REPO/releases/latest"

figlet "Updating"

if [[ ! -f "$CONFIG" ]]; then
    echo "config.json not found"
    exit 1
fi

current="$(jq -r '.shellInfo.version // empty' "$CONFIG")"

if [[ -z "$current" ]]; then
    echo "version not found"
    exit 1
fi

latest_tag="$(curl -fsSL "$API" | jq -r '.name // .tag_name')"

if [[ -z "$latest_tag" ]]; then
    echo "failed to fetch latest version"
    exit 1
fi

latest="${latest_tag#v}"

if [[ "$current" == "$latest" ]]; then
    echo "already up to date ($current)"
    exit 0
fi

tmp="$(mktemp -d)"
zip="$tmp/aelyx-shell.zip"

curl -fL \
    "https://github.com/$REPO/releases/download/$latest_tag/aelyx-shell.zip" \
    -o "$zip"

unzip -q "$zip" -d "$tmp"

if [[ ! -d "$tmp/quickshell" ]]; then
    echo "quickshell folder not found"
    exit 1
fi

rm -rf "$QS_DIR"
mkdir -p "$QS_DIR"
cp -r "$tmp/quickshell/"* "$QS_DIR/"

tmp_cfg="$(mktemp)"
jq --arg v "$latest" '.shellInfo.version = $v' "$CONFIG" > "$tmp_cfg"
mv "$tmp_cfg" "$CONFIG"
killall quickshell; killall qs
quickshell -c ae-qs
echo "Updated $current -> $latest"
