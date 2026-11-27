#!/usr/bin/env bash
# Copy the book from the private working repository into this public
# repository, then commit and push.
#
# Usage:
#   scripts/publish.sh                 # default commit message
#   scripts/publish.sh "Commit message"
#
# What is published:
#   <source>/chapters/      -> chapters/   (mirrored, deletions included)
#   <source>/dist/          -> dist/       (mirrored, if the build exists)
#   README.md                              (maintained here, not copied)
#
# Build the book first in the source repository if it should be updated:
#   .venv/bin/build-book

set -euo pipefail

SOURCE="${SOURCE:-/home/wiegard/openspec/openspec-tutorial-working-repo}"
TARGET="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

die() { echo "error: $*" >&2; exit 1; }

[ -d "$SOURCE/chapters" ] || die "no chapters/ in $SOURCE"
[ -d "$TARGET/.git" ]     || die "$TARGET is not a Git repository"

# Publish only committed chapter text, so every public state matches a
# commit in the working repository.
if [ -n "$(git -C "$SOURCE" status --porcelain -- chapters)" ]; then
    die "chapters/ in $SOURCE has uncommitted changes; commit them first"
fi
SOURCE_REF="$(git -C "$SOURCE" rev-parse --short HEAD)"
SOURCE_BRANCH="$(git -C "$SOURCE" rev-parse --abbrev-ref HEAD)"

echo "Copying chapters from $SOURCE ($SOURCE_BRANCH @ $SOURCE_REF)"
rsync -a --delete "$SOURCE/chapters/" "$TARGET/chapters/"

shopt -s nullglob
built=("$SOURCE"/dist/*)
if [ ${#built[@]} -gt 0 ]; then
    # A build older than the last chapter commit does not show that text.
    chapters_time="$(git -C "$SOURCE" log -1 --format=%ct -- chapters)"
    for f in "${built[@]}"; do
        if [ "$(stat -c %Y "$f")" -lt "$chapters_time" ]; then
            echo "warning: $f is older than the last chapter commit; rebuild it" >&2
        fi
    done
    echo "Copying ${#built[@]} file(s) from $SOURCE/dist"
    rsync -a --delete "$SOURCE/dist/" "$TARGET/dist/"
else
    echo "warning: no build in $SOURCE/dist; dist/ is left unchanged" >&2
fi

cd "$TARGET"
git add -A -- .gitignore README.md chapters
if [ -d dist ]; then git add -A -- dist; fi

if git diff --cached --quiet; then
    echo "Nothing changed; nothing to publish."
    exit 0
fi

echo "Changes to publish:"
git diff --cached --stat

MESSAGE="${1:-Publish the book from $SOURCE_BRANCH at $SOURCE_REF}"
git commit -q -m "$MESSAGE"
git push -u origin main
echo "Published."
