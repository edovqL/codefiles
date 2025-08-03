#!/bin/bash

# Switches Node.js version using nvm if a .node-version or .nvmrc file is present in the current or parent directories.

find_node_version_file() {
  local dir="$PWD"
  while [[ "$dir" != "/" ]]; do
    if [[ -f "$dir/.node-version" ]]; then
      echo "$dir/.node-version"
      return 0
    elif [[ -f "$dir/.nvmrc" ]]; then
      echo "$dir/.nvmrc"
      return 0
    fi
    dir="$(dirname "$dir")"
  done
  return 1
}

node_version_file=$(find_node_version_file)
if [[ -n "$node_version_file" ]]; then
  node_version=$(cat "$node_version_file" | tr -d '[:space:]')
  if command -v nvm > /dev/null; then
    echo "Switching to Node.js version: $node_version (from $node_version_file)"
    nvm install "$node_version"
    nvm use "$node_version"
  else
    echo "nvm is not installed. Please install nvm first."
    exit 1
  fi
fi
