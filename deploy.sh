#!/bin/bash

set -e

# Ensure modules are downloaded
hugo mod tidy
hugo mod vendor

# Build the site
hugo --minify

# Move into public and set up gh-pages deployment
cd public

# If .git exists, reuse it; otherwise initialize
if [ ! -d .git ]; then
  git init -q
  git remote add origin git@github.com:ieshghi/ieshghi.github.io.git
  git fetch origin gh-pages
  # Attach the fresh build to the existing gh-pages history (keeps the built files in the working tree)
  git checkout -q -b gh-pages
  git reset -q origin/gh-pages
else
  git checkout gh-pages
  git fetch origin gh-pages
  git reset -q origin/gh-pages
fi

# Add and commit changes (-A also records files removed from the build)
git add -A
git commit -m "Deploy site" || echo "No changes to commit"
git push origin gh-pages
cd ..
