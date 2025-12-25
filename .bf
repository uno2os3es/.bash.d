#!/bin/sh

dupwhl() {
  fd -e whl | sed -E 's/-[0-9].*//' | sort | uniq -d

}

mp32ogg() {
  fd -e mp3 -i . | while read -r f; do
    out="${f%.mp3}.ogg"
    mkdir -p "$(dirname "$out")"
    oggenc -q 6 -o "$out" "$f"
  done
}

readf() {
  if [ -z "$1" ]; then
    echo "Usage: readf <filename>"
    return 1
  fi

  if [ ! -f "$1" ]; then
    echo "File not found: $1"
    return 1
  fi

  while IFS= read -r line; do
    termux-tts-speak "$line"
    sleep 0.3 # optional: small pause between lines
  done <"$1"
}

mp32opus() {
  fd -e mp3 -i . | while read -r f; do
    out="${f%.mp3}.opus"
    mkdir -p "$(dirname "$out")"
    opusenc --bitrate 128 "$f" "$out"
  done
}
fdelc() {

  fd -t d -i -g --hidden "$1" | while read -r dir; do
    read -p "Delete '$dir'? [y/N] " ans
    if [[ "$ans" =~ ^[Yy]$ ]]; then
      rm -rf "$dir"
      echo "Deleted: $dir"
    fi
  done
}

fdel() {
  fd -t d -i -g --hidden "$1" -x rm -rf {}
}

movie2mp3() {
  if [ $# -lt 1 ]; then
    echo "Usage: movie2mp3 <movie-file>"
    return 1
  fi

  # Input file (quoted to handle spaces)
  FNAME="$1"

  # Remove extension and append .mp3
  OUT="${FNAME%.*}.mp3"

  # Convert using ffmpeg
  ffmpeg -i "$FNAME" -vn -acodec libmp3lame -b:a 320k "$OUT"
}

f10() {
  find . -type f -mmin -10 -printf '%f  %s bytes\n'
}

f20() {
  find . -type f -mmin -20 -printf '%f  %s bytes\n'
}

f30() {
  find . -type f -mmin -30 -printf '%f  %s bytes\n'
}

f40() {
  find . -type f -mmin -40 -printf '%f  %s bytes\n'
}

f50() {
  find . -type f -mmin -50 -printf '%f  %s bytes\n'
}

f61() {
  find . -type f -mmin -60 -printf '%f  %s bytes\n'
}

f70() {
  find . -type f -mmin -70 -printf '%f  %s bytes\n'
}

f80() {
  find . -type f -mmin -80 -printf '%f  %s bytes\n'
}

f90() {
  find . -type f -mmin -90 -printf '%f  %s bytes\n'
}

f100() {
  find . -type f -mmin -100 -printf '%f  %s bytes\n'
}

f120() {
  find . -type f -mmin -120 -printf '%f  %s bytes\n'
}

dmp2() {
  fd --type d --empty --exec rmdir {}
}

pyempty() {
  fd --type f --extension py --size 0B --exclude '__init__.py'
  #    fd --type f --extension py --size 0B --exclude '__init__.py'
}

ex_tar() {
  for f in *; do bash -c "cd $f && tar -xzvf *.tar.gz"; done
}

zz7() {
  local name="$(basename "$PWD")"
  local archive="../${name}.7z"

  echo "🗜️ Compressing '$name' into '$archive'..."
  7z a -mx9 "$archive" "../$name" || {
    echo "❌ Compression failed."
    return 1
  }

  #    read -p "Delete original folder '$PWD'? [y/N] " ans
  #    [[ "$ans" =~ ^[Yy]$ ]] || {
  #        echo "Skipped deletion."
  #        return 0
  #    }

  cd .. || {
    echo "❌ Failed to change directory."
    return 1
  }

  rm -rf "$name"
  echo "✅ Done: created '$archive' and removed '$name/'"
}

z7er() {
  7z a -mx9 "../$(basename "$PWD").7z" "../$(basename "$PWD")"
}
stree() {
  tree -h --du | sort -hr
}
atree() {
  tree -d -L 2 | tail -n 1
}
dtree() {
  tree -d -L 2
}

btree() {
  tree -a -L 4 -h /path/to/backup | grep "GB"

}
ftree() {
  tree -a -I "__pycache__|.git" -L 3 -h
}

gtree() {
  tree -a -I "node_modules|.git|dist|build" -L 3 -h
}

la() {
  ls -a
}
lu() {
  ls -hla
}
pss() {
  ff="/sdcard/pip.txt"
  grep "$@" "$ff"
}

mdr() {
  mkdir -p "$@" && cd "$_"
}
mkdr() {
  mkdir -p "$@" && cd "$_"
}

lj() {
  ls -la | awk 'NR>1 && !/^d/ {printf "%s %.2f MB\n", $9, $5/1024/1024}'
}

# Function to list files and directories with human-readable sizes

rmaa() {
  read -p "Are you sure you want to delete all files except .git? [y/N]: " yn
  if [[ "$yn" == "y" || "$yn" == "Y" ]]; then
    find . -mindepth 1 -not -name '.git' -not -path './.git/*' -exec rm -rf {} +
    echo "All files except .git deleted."
  else
    echo "Aborted."
  fi
}

# --------- C++ Programming Shortcuts ---------
cpprun() {
  if [ $# -eq 0 ]; then
    echo "Usage: cpprun <file.cpp>"
    return 1
  fi
  file="$1"
  exe="${file%.cpp}"
  g++ -std=c++17 -Wall -Wextra -O2 "$file" -o "$exe" && ./"$exe"
}
cppnew() {
  if [ $# -eq 0 ]; then
    echo "Usage: cppnew <filename.cpp>"
    return 1
  fi
  file="$1"
  cat >"$file" <<'EOF'
#include <bits/stdc++.h>
using namespace std;

int main() {
    ios::sync_with_stdio(false);
    cin.tie(nullptr);

    // Your code here

    return 0;
}
EOF
  echo "Created $file with basic C++ template"
  nano "$file"
}

# --------- Python Shortcuts ---------
# Run Python scripts easily

# Create new Python script with basic template
pynew() {
  if [ $# -eq 0 ]; then
    echo "Usage: pynew <script.py>"
    return 1
  fi
  file="$1"
  cat >"$file" <<'EOF'
#!/usr/bin/env python3

import sys
import dh

def main():
    dir='.'
    filez=[]
    files=dh.get_files(dir)
    for f in files:
        if dh.get_ext(f)=='':
            filez.append(f)


if __name__ == "__main__":
    sys.exit(main())
EOF
  chmod +x "$file"
  echo "$file created"
  #	nano "$file"
}

g2() {
  # Clone only the default branch (main/master/whatever) as a bare repo.
  # Usage: mygit2 <repo-url> [target-dir]

  if [ -z "$1" ]; then
    echo "Usage: g2 <repo-url> [target-dir]"
    return 1
  fi

  local url="$1"
  local target="${2:-}"

  # Get default branch from remote (e.g. main or master)
  local branch
  branch=$(git ls-remote --symref "$url" HEAD 2>/dev/null | awk '/^ref:/ {print $2}' | sed 's|refs/heads/||')

  if [ -z "$branch" ]; then
    echo "❌ Could not determine default branch for $url"
    return 1
  fi

  # Derive repo name if no custom folder name given
  local repo
  repo=$(basename "$url" .git)

  # Determine target directory
  if [ -z "$target" ]; then
    target="${repo}.git"
  fi

  echo "🔍 Default branch: $branch"
  echo "📦 Cloning only '$branch' from $url into $target ..."
  git clone --single-branch --branch "$branch" --bare "$url" "$target" || return 1

  echo "✅ Done!"
  echo "   To update later: cd $target && git fetch origin $branch"
}

trr() {
  local name="$(basename "$PWD")"
  local archive="../${name}.tar"

  echo "🗜️ Compressing '$name' into '$archive'..."
  tar -cf "$archive" -C .. "$name" || {
    echo "❌ Compression failed."
    return 1
  }

  # Optional deletion (currently commented out)
  # read -p "Delete original folder '$PWD'? [y/N] " ans
  # [[ "$ans" =~ ^[Yy]$ ]] || {
  #     echo "Skipped deletion."
  #     return 0
  # }

  cd .. || {
    echo "❌ Failed to change directory."
    return 1
  }
  zstd --rm "${basename}"
  rm -rf "$name"
  echo "✅ Done: created '$archive' and removed '$name/'"
}

txz() {
  local name="$(basename "$PWD")"
  local archive="../${name}.tar.xz"

  echo "🗜️ Compressing '$name' into '$archive' (xz -e -9)..."
  tar -c --xz -I "xz -e -9" -f "$archive" -C .. "$name" || {
    echo "❌ Compression failed."
    return 1
  }

  # Optional deletion (currently commented out)
  # read -p "Delete original folder '$PWD'? [y/N] " ans
  # [[ "$ans" =~ ^[Yy]$ ]] || {
  #     echo "Skipped deletion."
  #     return 0
  # }

  cd .. || {
    echo "❌ Failed to change directory."
    return 1
  }
  rm -rf "$name"
  echo "✅ Done: created '$archive' and removed '$name/'"
}

zx77() {
  local file
  for file in *; do
    # Only regular files that 7z can handle
    if [[ -f "$file" ]] && 7z l "$file" >/dev/null 2>&1; then
      echo "=== Extracting: $file ==="
      7z x "$file" -y # -y = assume Yes on all queries
    fi
  done
}

gtop() {
  local file
  file=$(
    python3 - <<'EOF'
import os
from pathlib import Path

start = Path(".").resolve()
largest = None

for p in start.rglob("*"):
    if p.is_file():
        try:
            size = p.stat().st_size
            if largest is None or size > largest[1]:
                largest = (p, size)
        except:
            continue

if largest:
    print(largest[0])
EOF
  )

  if [ -z "$file" ]; then
    echo "No files found."
    return 1
  fi

  echo "Largest file: $file"
  local dir
  dir=$(dirname "$file")
  echo "Directory: $dir"

  cd "$dir" || return
  pwd
}

mcd() { mkdir -p "$1" && cd "$1"; }

extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2) tar xjf "$1" ;;
      *.tar.gz) tar xzf "$1" ;;
      *.tar.xz) tar -xJf "$1" ;;
      *.bz2) bunzip2 "$1" ;;
      *.rar) unrar x "$1" ;;
      *.gz) gunzip "$1" ;;
      *.tar) tar xf "$1" ;;
      *.tbz2) tar xjf "$1" ;;
      *.tgz) tar xzf "$1" ;;
      *.zip) unzip "$1" ;;
      *.7z) 7z x "$1" ;;
      *) echo "Unknown archive: $1" ;;
    esac
  else
    echo "'$1' is not a file"
  fi
}
dowhl() {
  for f in *; do bash -c "cd $f && unzip *.whl && rm -v *.whl"; done
}
dowhl2() {
  for f in *; do bash -c "cd $f && ww && rm -rf *"; done
}

pipallwhl() {
  for f in *.whl; do python -m pip install --no-deps $f; done
}

# Put this in ~/.bashrc
clean_exec() {
  "$@" 2>&1 | grep -v 'unsupported flags DT_FLAGS_1'
}

# Now you can run anything through it:
# clean_exec ./dirinfo --help
cleanlog() {
  if [ -f "$1" ]; then
    # 1. Strips ANSI color/format codes
    # 2. 'col -b' removes backspaces and carriage returns (^M)
    sed 's/\x1b\[[0-9;]*[a-zA-Z]//g' "$1" | col -b >"${1%.log}_clean.txt"
    echo "Cleaned log saved to ${1%.log}_clean.txt"
  else
    echo "File not found."
  fi
}
