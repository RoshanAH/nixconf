{ writeShellApplication
, fzf
}: writeShellApplication {
  name = "repo-find";

  runtimeInputs = [
    fzf
  ];

  # written by chatty p
  text = ''
# Set the root directory (default to the current directory if not provided)
    ROOT_DIR="''${1:-$(pwd)}"
    ROOT_DIR="''${ROOT_DIR%/}"
# Find all directories containing .git, then use fzf to select one
    SELECTED_DIR=$(find "$ROOT_DIR" -type d -name .git -prune 2>/dev/null \
      | sed "s|$ROOT_DIR/||" \
      | sed 's|/\.git$||' \
      | fzf --layout reverse --prompt="repos: ")

# Check if a directory was selected
    if [ -n "$SELECTED_DIR" ]; then
      # Change to the selected directory
      echo "$ROOT_DIR/$SELECTED_DIR"
    else
      echo "No directory selected." >&2
      exit 1
    fi
  '';
}
