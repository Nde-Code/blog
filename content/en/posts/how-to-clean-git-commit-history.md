---
title: "Resetting a project's Git history."
date: 2026-06-25
draft: false
tags: ["Git", "GitHub", "DevOps"]
categories: ["Git"]
author: "Nathan Debilloëz"
description: "This might seem obvious, but we occasionally need to do it (even more often than one might think). Considering the lack of literature on this particular procedure, I opted to pen one myself."
---

# Introduction:

This guide explains how to completely delete commit history, reset the repository locally, and force-push the updates to GitHub (or any other remote service).

This tutorial might seem unusual, but the need arises much more frequently than one might think. For example:

* **If you expose secrets:** if sensitive data leaks into your source code, a deep cleanup is absolutely necessary, even if the keys have already been revoked.
* **For cleanliness:** when working on the foundations of a project, it is often desirable to erase the initial trial-and-error phases to keep a clean repository.
* **To start fresh after a long period:** following major changes after a long period of inactivity, you might want to reset the history based on these new changes to avoid confusion.

**⚠️ Warning:** this operation is irreversible. It will permanently overwrite the history of the main branch on the remote repository. If others are collaborating on this project, they must delete their local version and re-clone the repository to avoid major conflicts.

**Prerequisite:** back up the repository whose commit history you wish to delete before proceeding.

## 1. Local cleanup:

To begin with, clone the repository onto your computer.

Next, open a terminal at the root of the project and execute the following commands:

### To delete the `.git` folder:

* **Windows (PowerShell):**
```powershell
Remove-Item -Recurse -Force .git
```

* **Mac / Linux:**
```bash
rm -rf .git
```

### To reset the repository:

```bash
# Initialize a new empty repository
git init

# Add all current files
git add .

# Create the new initial commit
git commit -m "chore: reset repository history and initialize fresh project state"
```

## 2. Configure the `main` branch:

Ensure that the default branch is correctly named `main`:
```bash
git branch -M main
```

## 3. Link to the remote repository and force push:

> Replace the URL below with your actual GitHub repository URL.

```bash
# Add your remote repository address
git remote add origin https://github.com/<NAME>/<PROJECT_NAME>.git

# Overwrite the remote history with the new local commit
git push -u origin main --force
```

**Note:** if your goal is to clean up **all** remote branches and tags alongside this push, you can delete other branches individually using the following command: `git push origin --delete <branch_name>`.

## 4. Conclusion:

After this operation, the repository will be completely cleaned up and fresh as day one.
