#!/bin/bash

#=====================================================================#
#                   Upstream Sync Script for LibreChat                #
#=====================================================================#
# Syncs changes from danny-avila/LibreChat into your fork            #
#=====================================================================#

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default branch
BRANCH="${1:-main}"

# Print functions
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

print_info "Starting upstream sync for branch: $BRANCH"
echo

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    print_error "Not in a git repository!"
    exit 1
fi

# Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
    print_warning "You have uncommitted changes!"
    echo
    git status --short
    echo
    read -p "Do you want to stash these changes? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git stash push -m "Auto-stash before upstream sync"
        print_success "Changes stashed"
        STASHED=true
    else
        print_error "Please commit or stash your changes first"
        exit 1
    fi
fi

# Ensure upstream remote exists
print_info "Checking upstream remote..."
if ! git remote get-url upstream > /dev/null 2>&1; then
    print_info "Adding upstream remote..."
    git remote add upstream https://github.com/danny-avila/LibreChat.git
    print_success "Upstream remote added"
else
    print_success "Upstream remote already configured"
fi

# Fetch latest from upstream
print_info "Fetching latest changes from upstream..."
git fetch upstream
print_success "Fetched upstream changes"

# Switch to target branch
print_info "Switching to branch: $BRANCH"
git checkout "$BRANCH"

# Check how far behind we are
COMMITS_BEHIND=$(git rev-list --count HEAD..upstream/$BRANCH)

if [ "$COMMITS_BEHIND" -eq 0 ]; then
    print_success "Already up to date with upstream!"

    # Pop stash if we stashed earlier
    if [ "$STASHED" = true ]; then
        print_info "Restoring stashed changes..."
        git stash pop
    fi

    exit 0
fi

print_info "Your branch is $COMMITS_BEHIND commits behind upstream/$BRANCH"
echo

# Show what will be merged
print_info "Preview of upstream changes:"
git log --oneline --graph HEAD..upstream/$BRANCH | head -20
echo

# Ask for confirmation
read -p "Do you want to merge these changes? (y/N): " -n 1 -r
echo

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_warning "Sync cancelled"

    # Pop stash if we stashed earlier
    if [ "$STASHED" = true ]; then
        print_info "Restoring stashed changes..."
        git stash pop
    fi

    exit 0
fi

# Try to merge
print_info "Merging upstream/$BRANCH..."
if git merge upstream/$BRANCH --no-edit; then
    print_success "Successfully merged upstream changes!"

    # Push to origin
    read -p "Do you want to push to origin? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_info "Pushing to origin/$BRANCH..."
        git push origin "$BRANCH"
        print_success "Pushed to origin/$BRANCH"
    fi

    # Pop stash if we stashed earlier
    if [ "$STASHED" = true ]; then
        print_info "Restoring stashed changes..."
        git stash pop
    fi

    print_success "Sync complete!"
else
    print_error "Merge conflicts detected!"
    echo
    print_info "Conflicts in the following files:"
    git diff --name-only --diff-filter=U
    echo
    print_info "To resolve conflicts:"
    echo "  1. Edit the conflicting files"
    echo "  2. Stage resolved files: git add <file>"
    echo "  3. Complete the merge: git commit"
    echo "  4. Push changes: git push origin $BRANCH"
    echo
    print_info "Or abort the merge: git merge --abort"

    exit 1
fi
