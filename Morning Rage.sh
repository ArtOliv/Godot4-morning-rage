#!/bin/sh
echo -ne '\033c\033]0;Morning Rage\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Morning Rage.x86_64" "$@"
