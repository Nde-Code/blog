---
title: "How to Completely Reset a Git Repository's History"
date: 2026-06-25
draft: false
tags: ["Git", "GitHub", "DevOps"]
categories: ["Git"]
author: "Nathan Debilloëz"
description: "It may come as a surprise, but this is an operation you'll occasionally need to perform—more often than you might think. Since there is relatively little documentation on the subject, I decided to write this short tutorial."
---

# Introduction:

This guide explains how to completely reset a Git repository's history by removing the previous local Git history, recreating a clean repository, and then replacing the history of the remote repository.

Although this may seem like an unusual operation, it's more common than you might think. Typical use cases include:

* **Accidentally exposing secrets:** always revoke them first (API keys, access tokens, passwords, etc.). Resetting the repository history helps remove them from the repository's visible history, but it **does not** guarantee that the data has disappeared from existing clones, forks, or caches.
* **Cleaning up a project:** once the initial development phase is over, you may want to start with a clean history by removing the early work-in-progress commits.
* **Starting fresh after major changes:** following a significant refactor or a long period of development, resetting the history can provide a clean baseline and make the repository easier to understand.

> **⚠️ Warning:** this operation is irreversible. It will permanently overwrite the history of the remote `main` branch. If other people collaborate on this project, they should delete their local copy and clone the repository again to avoid major conflicts.

**Prerequisite:** make a backup of the repository before removing its commit history.

> **Note:** this guide assumes that your default branch is `main` and that you'll be resetting its history. While `main` is now the standard default branch on platforms such as GitHub and GitLab, you should verify your repository first. If your default branch has a different name, simply replace `main` with the appropriate branch name in the commands throughout this guide. I'll point out the steps where this matters.

# Procedure overview:

Make sure you fully understand the process and the implications of the actions that will be performed.

## 1. Local cleanup:

Start by cloning the repository containing the `main` branch you want to reset.

> Cloning allows you to retrieve the current state of the project's files before removing the previous Git history.

Then, open a terminal at the root of the project and follow the steps below, running the corresponding commands.

### Step 1, remove the `.git` directory:

* **Windows (using PowerShell):**
```powershell
Remove-Item -Recurse -Force .git
```

* **macOS / Linux:**
```bash
rm -rf .git
```

This removes the `.git` directory, which contains all Git metadata for the repository: commit history, local branches, tags, and associated configuration.

### Step 2, reinitialize the Git repository:

Once the previous history has been removed, you need to initialize a fresh Git repository.

Run the following command in your terminal to create the new repository:
```bash
git init
```

Then, add all project files to the staging area:
```bash
git add .
```

Finally, create the first commit of this new repository:
```bash
git commit -m "chore: reset repository history and initialize fresh project state"
```

## 2. Configure the main branch:

Rename the current branch to `main`:
```bash
git branch -M main
```

**Note:** this command renames the current branch to `main`. If your repository uses a different name for its main branch, adjust the command accordingly.

## 3. Configure the remote repository and force push the new history:

Add the remote repository:
> Replace the URL below with the URL of your GitHub repository.
```bash
git remote add origin https://github.com/<NAME>/<PROJECT_NAME>.git
```

Then, force push the new history to the remote repository:
```bash
git push -u origin main --force
```

> ⚠️ This command permanently replaces the remote repository's history. Make sure all collaborators are aware of this change before running it.

**Warning:** as mentioned earlier, this guide assumes that `main` is the branch being reset. Make sure you use the correct branch name according to your repository configuration.

**Note:** if you also want to remove the other remote branches, run the following command for each branch you want to delete: `git push origin --delete <branch_name>`

# Conclusion:

Once this operation is complete, the remote `main` branch will contain a single commit representing the new initial state of the project. The previous history will no longer be available from the remote `main` branch.