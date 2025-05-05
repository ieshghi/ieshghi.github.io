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
  git init
  git remote add origin https://github.com/your-username/your-repo.git
  git fetch origin gh-pages || echo "No existing gh-pages branch"
  git checkout -b gh-pages || git checkout gh-pages
else
  git checkout gh-pages
  git pull origin gh-pages
fi

# Add and commit changes
git add .
git commit -m "Deploy site" || echo "No changes to commit"
git push -f origin gh-pages
cd ..
