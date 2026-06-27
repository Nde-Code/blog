---
title: "Reset the Git history of a project's main branch."
date: 2026-06-25
draft: false
tags: ["Git", "GitHub", "DevOps"]
categories: ["Git"]
author: "Nathan Debilloëz"
description: "This may be surprising, but it is an intervention that must sometimes be carried out, often more than one assumes. Given the lack of content on this topic, I took the initiative to write a short tutorial on this subject."
---

# Introduction:

This guide explains how to completely remove the commit history of the main branch (`main`), reset the local repository by recreating a clean history for the `main` branch, and force the update to the remote repository.

This may seem like an unusual tutorial, but it is much more common than one might think, for example:

* **If you expose secrets:** in your source code, it is essential to perform a deep cleanup, even if the keys have already been revoked.
* **For cleanliness reasons:** sometimes, when working on the foundations of a project, you may want to remove early experiments in order to keep the repository clean.
* **To start fresh after a long period:** after major changes following a long period of inactivity, you may want to reset the history on these new foundations to avoid confusion.

**⚠️ Warning:** this operation is irreversible. It will permanently overwrite the history of the main branch on the remote repository. If other people collaborate on this project, they will have to delete their local version and re-clone the repository to avoid major conflicts.

**Prerequisite:** make a backup of the repository whose commit history you intend to delete.

> **Note:** this article assumes that the project's main branch is `main` and that this is the branch on which the cleanup will be performed. Since a few years ago (on GitHub), the default branch has typically been `main`, but this may vary. Check your repository as well as your remote platform settings (GitHub, GitLab, ...).

# 1. Local cleanup:

Before anything else, clone the repository containing the `main` branch you want to reset.

Then open a terminal at the root of the project and follow and execute the following commands:

## To remove the `.git` folder:

* **Windows (via PowerShell):**
```powershell
Remove-Item -Recurse -Force .git
```

* **Mac / Linux:**
```bash
rm -rf .git
```

This completely removes the local Git history, including commits, local branches, and repository configuration.

## To reinitialize the repository:

```bash
# Initialize a new empty repository:
git init

# Add all current files:
git add .

# Create the new first commit:
git commit -m "chore: reset repository history and initialize fresh project state."
```

# 2. Configure the main branch:

We rename the repository's main branch to `main`:
```bash
git branch -M main
```

**Note:** this command renames the current branch to `main`. If your repository uses a different name for its main branch, adjust the command accordingly.

# 3. Link the remote repository and force push:

> Replace the URL below with your actual GitHub repository URL.

```bash
# Add the remote repository URL:
git remote add origin https://github.com/<NOM>/<NOM_PROJET>.git

# Overwrite the remote history with the new local commit:
git push -u origin main --force
```

**Warning:** here again, we are pushing to `main`, the main branch as explained earlier. It is essential to verify and provide the correct branch name as defined in your configuration.

**Note:** if the goal is to clean **all** remote branches and tags at the same time as the push, you can add this command before or after your push: `git push origin --delete <branch_name>`. This operation must be repeated for each branch.

# Conclusion:

Once this operation is completed, the history of the main branch (`main`) will have been completely rewritten on the remote repository.
