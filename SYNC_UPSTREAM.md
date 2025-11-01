# Syncing Upstream Changes

This document explains how to keep your LibreChat fork synchronized with the upstream repository (`danny-avila/LibreChat`).

## Methods

### 1. 🤖 Automatic Sync (GitHub Actions) - Recommended

A GitHub Actions workflow automatically syncs upstream changes daily at 2 AM UTC.

**Features:**
- ✅ Runs automatically every day
- ✅ Creates issues if merge conflicts occur
- ✅ Can be triggered manually
- ✅ Provides sync summaries

**Manual Trigger:**
1. Go to: https://github.com/daviddiviny/LibreChat/actions/workflows/sync-upstream.yml
2. Click "Run workflow"
3. Select branch to sync (default: main)
4. Click "Run workflow"

**Configuration:**
The workflow is defined in `.github/workflows/sync-upstream.yml`

To change the schedule, edit the cron expression:
```yaml
schedule:
  - cron: '0 2 * * *'  # Daily at 2 AM UTC
  # Examples:
  # - cron: '0 */6 * * *'   # Every 6 hours
  # - cron: '0 0 * * 1'     # Every Monday
  # - cron: '0 0 1 * *'     # First day of month
```

### 2. 🔧 Manual Sync Script (Local)

Use the provided script for local syncing with interactive prompts.

**Usage:**
```bash
./sync-upstream.sh [branch]

# Examples:
./sync-upstream.sh              # Sync main branch
./sync-upstream.sh insights-dashboard  # Sync specific branch
```

**What it does:**
1. Checks for uncommitted changes (offers to stash)
2. Fetches latest upstream changes
3. Shows preview of changes
4. Asks for confirmation before merging
5. Handles merge conflicts gracefully
6. Optionally pushes to your fork

### 3. 🐱 GitHub UI (Web Interface)

**Steps:**
1. Go to: https://github.com/daviddiviny/LibreChat
2. Click "Sync fork" button (appears when behind upstream)
3. Click "Update branch"

**Limitations:**
- Only works if no conflicts
- Manual process
- No preview of changes

### 4. 📝 Manual Git Commands

For full control, use git directly:

**Basic sync:**
```bash
cd LibreChat
git fetch upstream
git merge upstream/main
git push origin main
```

**With preview:**
```bash
# Fetch latest
git fetch upstream

# Preview changes
git log --oneline HEAD..upstream/main

# See detailed diff
git diff HEAD..upstream/main

# Merge
git merge upstream/main

# Push
git push origin main
```

**Sync multiple branches:**
```bash
# Sync main
git checkout main
git merge upstream/main
git push origin main

# Sync insights-dashboard
git checkout insights-dashboard
git merge main  # Or upstream/main directly
git push origin insights-dashboard
```

## Handling Merge Conflicts

If you encounter merge conflicts:

### Using the Script
```bash
./sync-upstream.sh
# If conflicts occur, you'll see:
# - List of conflicting files
# - Instructions to resolve
```

### Manual Resolution
```bash
# 1. See conflicting files
git status

# 2. Edit files to resolve conflicts
# Look for markers:
# <<<<<<< HEAD
# Your changes
# =======
# Upstream changes
# >>>>>>> upstream/main

# 3. Stage resolved files
git add <resolved-file>

# 4. Complete the merge
git commit

# 5. Push
git push origin main
```

### Abort if needed
```bash
git merge --abort  # Cancels the merge
```

## Best Practices

### 1. Keep Custom Changes Isolated
- Custom features in separate branches
- Use `insights-dashboard` for Agent Insights customizations
- Keep `main` as close to upstream as possible

### 2. Regular Syncing
- Sync at least weekly
- More frequent = easier merges
- GitHub Actions handles this automatically

### 3. Review Changes Before Merging
```bash
# Always preview first
git log --oneline HEAD..upstream/main

# Check for breaking changes
git diff HEAD..upstream/main -- package.json
```

### 4. Test After Syncing
```bash
# After sync, rebuild and test
./deploy.sh
# Or manually:
docker-compose build
docker-compose up -d
```

### 5. Branch Strategy
```
upstream/main → your fork/main → your fork/insights-dashboard
                      ↓                      ↓
                  Custom changes      Agent Insights features
```

## Troubleshooting

### "Already up to date" but GitHub shows behind
```bash
git fetch upstream --force
git merge upstream/main
```

### Lost commits after sync
```bash
# Find lost commits
git reflog

# Recover if needed
git cherry-pick <commit-hash>
```

### Conflicts in generated files
```bash
# For package-lock.json conflicts
git checkout --theirs package-lock.json
npm install
git add package-lock.json
```

### Workflow not running
- Check: Actions > Sync Upstream LibreChat
- Enable if disabled
- Check repository permissions (Settings > Actions)

## Monitoring

### Check sync status
```bash
# How far behind upstream
git fetch upstream
git rev-list --count HEAD..upstream/main

# Last sync time
git log --oneline -1 --grep="Merge remote-tracking branch 'upstream/main'"
```

### GitHub Actions logs
- View at: https://github.com/daviddiviny/LibreChat/actions
- Shows sync history, conflicts, and errors

## Related Files

- `.github/workflows/sync-upstream.yml` - Automated sync workflow
- `sync-upstream.sh` - Manual sync script
- `SYNC_UPSTREAM.md` - This documentation

## Quick Reference

| Method | When to Use | Effort | Automation |
|--------|-------------|--------|------------|
| GitHub Actions | Daily syncing | None | Automatic |
| Sync Script | On-demand, preview changes | Low | Semi-auto |
| GitHub UI | Quick sync, no conflicts | Very Low | Manual |
| Git Commands | Full control, complex scenarios | High | Manual |

---

**Need Help?**
- Check workflow logs: https://github.com/daviddiviny/LibreChat/actions
- Review git documentation: `git help merge`
- LibreChat upstream: https://github.com/danny-avila/LibreChat
