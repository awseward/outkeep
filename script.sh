#!/usr/bin/env bash

set -euo pipefail

_usage() { >&2 echo 'TODO: Document usage' && return 1; }

watch_test() {
  (
    # This error behavior in a subshell is needed for entr to be able to start
    # back up when a file is added or removed to any directories it's watching.
    set +e

    while true; do
      find src test -name '*.gleam' | entr -d ding gleam test
      >&2 echo '^C to exit…'
      sleep 2
    done
  )
}

pack_file() {
  local -r filename="$1"
  local -r file_basename="$(basename "$filename")"

  jq --compact-output --arg filename "$file_basename" -- '{
    $filename,
    content: .
  }' < "$filename"
}

pack_files() {
  local -r dir_path="$1"

  find "$dir_path" -type f -name '*.json' -print0 | xargs -0 -n1 -t "$0" pack_file
}

# ---

"${@:-_usage}"
