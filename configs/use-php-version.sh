#!/bin/bash

# This script switches PHP version via brew if a .php-version file is present.

find_php_version_file() {
  local dir="$PWD"
  while [[ "$dir" != "/" ]]; do
    if [[ -f "$dir/.php-version" ]]; then
      echo "$dir/.php-version"
      return 0
    fi
    dir="$(dirname "$dir")"
  done
  return 1
}

php_version_file=$(find_php_version_file)
if [[ -n "$php_version_file" ]]; then
  php_version=$(cat "$php_version_file" | tr -d '[:space:]')
  brew_formula="php@$php_version"
  if brew list "$brew_formula" &>/dev/null || brew info "$brew_formula" &>/dev/null; then
    echo "Switching to PHP version: $php_version (from $php_version_file)"
    brew unlink php &>/dev/null
    brew link --overwrite --force "$brew_formula"
    php -v
  else
    echo "PHP version $php_version is not installed via Homebrew. Installing now..."
    brew install "$brew_formula"
    brew unlink php &>/dev/null
    brew link --overwrite --force "$brew_formula"
    php -v
  fi
fi
