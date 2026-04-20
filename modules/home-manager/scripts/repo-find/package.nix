{ writeShellApplication
, fzf
, fd
}: writeShellApplication {
  name = "repo-find";

  runtimeInputs = [
    fzf
    fd
  ];

  # written by chatty p
  text = ''
# Set the root directory (default to the current directory if not provided)
ROOT_DIR="$${1:-$(pwd)}"
ROOT_DIR="$${ROOT_DIR%/}"

# Find all directories containing .git using fd, then use fzf to select one
SELECTED_DIR=$(fd -HI -t d '^\.git$' "$ROOT_DIR" -x dirname \
  | sed "s|^$ROOT_DIR/||;s|^/||" \
  | fzf --layout reverse --prompt="repos: ")

# Check if a directory was selected
if [ -n "$SELECTED_DIR" ]; then
  echo "$ROOT_DIR/$SELECTED_DIR"
else
  echo "No directory selected." >&2
  exit 1
fi
  '';
}
