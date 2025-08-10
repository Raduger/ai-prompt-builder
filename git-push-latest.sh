#!/bin/bash
set -e

# Replace with your repo URL
REPO_URL="https://github.com/yourusername/yourrepo.git"

# Initialize git repo if not already
if [ ! -d .git ]; then
  echo "Initializing new git repo..."
  git init
fi

# Set remote if not set
if ! git remote | grep -q origin; then
  echo "Setting remote origin to $REPO_URL"
  git remote add origin $REPO_URL
fi

echo "Adding all changes..."
git add .

echo "Committing changes..."
git commit -m "Add AI Prompt Builder page with search and copy functionality" || echo "No changes to commit"

echo "Pushing to main branch..."
git branch -M main
git push -u origin main

echo "Done! Changes pushed to GitHub."
