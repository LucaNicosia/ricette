#!/usr/bin/env bash

# Usage: ./tree_no_hidden.sh [directory]
# Default to current directory if none provided
DIR="${1:-.}"

# Check if directory exists
if [ ! -d "$DIR" ]; then
  echo "Error: '$DIR' is not a valid directory"
  exit 1
fi

print_tree() {
  local dir="$1"
  local prefix="$2"

  # Get list of non-hidden files/directories
  local items=()
  while IFS= read -r item; do
    items+=("$item")
  done < <(find "$dir" -mindepth 1 -maxdepth 1 ! -name ".*" | sort)

  local count=${#items[@]}
  local i=0

  for item in "${items[@]}"; do
    ((i++))
    local name
    name=$(basename "$item")

    if [ $i -eq $count ]; then
      echo "${prefix}└── $name"
      new_prefix="${prefix}    "
    else
      echo "${prefix}├── $name"
      new_prefix="${prefix}│   "
    fi

    # Recurse into directories
    if [ -d "$item" ]; then
      print_tree "$item" "$new_prefix"
    fi
  done
}

# Print root directory
echo "$DIR"
print_tree "$DIR" ""
