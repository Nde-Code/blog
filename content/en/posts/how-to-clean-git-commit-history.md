---
title: "Reset the Git history of a project's main branch"
date: 2026-06-25
draft: false
tags: ["Git", "GitHub", "DevOps"]
categories: ["Git"]
author: "Nathan Debilloëz"
description: "While it may seem surprising, this is an operation that needs to be performed from time to time, often more frequently than you might think. Given the lack of documentation on this topic, I decided to write a short tutorial."
---

# Introduction:

This guide explains how to completely remove the commit history of the main branch (`main`), reset the local repository by recreating a clean history for the `main` branch, and force the update to the remote repository.

This may seem like an unusual tutorial, but it is much more common than you might think, for example:

* **If you've exposed secrets:** in your source code, it's essential to perform a thorough cleanup, even if the credentials have already been revoked.
* **To keep the repository clean:** sometimes, when working on the foundations of a project, you may want to remove early experiments in order to keep the repository clean.
* **After a long period of inactivity:** following major changes, you may want to reset the history to reflect the project's new starting point.

**⚠️ Warning:** this operation is irreversible. It will permanently overwrite the history of the main branch on the remote repository. If other people collaborate on this project, they will have to delete their local version and re-clone the repository to avoid major conflicts.

**Prerequisite:** before proceeding, back up the repository.

> **Note:** this article assumes your main branch is named `main` and that this is the branch on which the cleanup will be performed. Although this is now the standard on platforms like GitHub or GitLab, please check your repository. If your default branch has a different name, simply adjust the commands accordingly. I will point out the steps where this requires extra attention.

# 1. Local cleanup:

Before anything else, clone the repository containing the `main` branch you want to reset.

Then open a terminal at the root of the project and run the following commands:

## 1. Remove the `.git` folder:

* **Windows (via PowerShell):**
```powershell
Remove-Item -Recurse -Force .git
```

* **Mac / Linux:**
```bash
rm -rf .git
```

This completely removes the local Git history, including commits, local branches, and repository configuration.

## 2. Reinitialize the repository:

```bash
# Initialize a new empty repository:
git init

# Add all current files:
git add .

# Create the new first commit:
git commit -m "chore: reset repository history and initialize fresh project state."
```

# 2. Configure the main branch:

Rename the current branch to `main`:
```bash
git branch -M main
```

**Note:** this command renames the current branch to `main`. If your repository uses a different name for its main branch, adjust the command accordingly.

# 3. Add the remote repository and force-push:

> Replace the URL below with your actual GitHub repository URL.

```bash
# Add the remote repository URL:
git remote add origin https://github.com/<OWNER>/<REPOSITORY>.git

# Overwrite the remote history with the new local commit:
git push -u origin main --force
```

**Warning:** once again, we are pushing to `main`, the main branch as explained earlier. It is essential to verify and provide the correct branch name as defined in your configuration.

**Note:** if you also want to remove **all** remote branches in addition to resetting the main branch history, you can run the following command before or after the *push*: `git push origin --delete <branch_name>`. Repeat this command for each branch you want to delete.

# Conclusion:

Once this operation is complete, the history of the main branch (`main`) on the remote repository will have been completely reset.