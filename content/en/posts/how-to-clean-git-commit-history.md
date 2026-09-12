---
title: "Rebuilding a Git Project's History from Its Current State"
date: 2026-06-25
draft: false
tags: ["Git", "GitHub", "DevOps"]
categories: ["Git"]
author: "Nathan Debilloëz"
description: "It may sound unusual, but this is an operation that can sometimes be necessary, more often than you might think. Due to the lack of content on this topic, I decided to put together a short tutorial."
---

# Introduction:

This guide explains how to **start fresh from a project's current state while removing its existing Git history**. The goal is to keep the files exactly as they are today, then rebuild the repository history from that state with a single initial *commit*.

While this is not something you would normally do on a daily basis, it can be useful in a few specific situations, for example:

- **If you have exposed secrets:** always revoke them first (API keys, tokens, passwords, etc.). Resetting the repository removes this information from the visible history, but it **does not guarantee** that the data has disappeared from every existing clone, *fork*, or cache.

- **For the sake of cleanliness:** after the initial setup of a project, you may want to start with a clean history by removing the first few *commits* associated with the initial development phase.

- **To start fresh after a long development period:** following significant changes, you may want to reset the history in order to establish a clean baseline and avoid unnecessary confusion.

The procedure consists of creating a new Git repository locally from the project's current state, setting `main` as the primary branch, and then replacing the `main` branch of the remote repository with this new branch.

**Prerequisite:** make sure to create a backup of the repository whose *commit* history you intend to reset.

**⚠️ Warning:** this operation rewrites the history of the remote `main` branch. Once the `push` has been performed, the old history will no longer be accessible from that branch. If other people collaborate on the project, make sure to inform them about the operation so they can delete their local copy and clone the repository again once the reset is complete.

# Procedure:

Make sure you fully understand what this operation does and the implications of carrying it out.

For this guide, I will use a repository hosted on GitHub as an example, which is currently one of the most well-known and widely used Git hosting platforms.

## 1. Remove the `.git` directory:

Start by cloning the GitHub repository to retrieve the current state of the project locally:

```bash
git clone https://github.com/<NAME>/<PROJECT_NAME>.git
```

Cloning retrieves the project's files in their current state, including the `.git` directory.

Next, open a terminal at the **root of the project** and run one of the following commands, depending on your operating system, to remove the existing `.git` directory:

- **On Windows (via PowerShell):**

```powershell
Remove-Item -Recurse -Force .git
```

- **On macOS / Linux:**

```bash
rm -rf .git
```

This removes the `.git` directory, which contains the repository's Git metadata, including its *commit* history, local branches, *tags*, and associated configuration.

> This only affects your local copy of the repository. The remote repository and its history remain unchanged until the `push` performed in step 4.

## 2. Initialize a new `.git`:

Once the old `.git` directory has been removed, initialize a new, clean `.git` and add all the project's files to it.

Run the following command in your terminal to initialize a new `.git`:

```bash
git init
```

Then add all the project's files:

```bash
git add .
```

Finally, create the first *commit*:

```bash
git commit -m "chore: reset repository history and initialize fresh project state"
```

## 3. Set the primary branch:

Rename the repository's current branch to `main`:

```bash
git branch -M main
```

> **Note:** if your repository uses a different name for its primary branch, adjust the command accordingly.

## 4. Connect the remote repository and force-push the new history:

Add the remote repository:

```bash
git remote add origin https://github.com/<NAME>/<PROJECT_NAME>.git
```

Then force-push the new history to the remote repository:

```bash
git push -u origin main --force
```

This command permanently replaces the history of the remote repository. Make sure all collaborators are aware of this before running it. Existing *forks* and local clones may retain a copy of the old history even after it has been rewritten on the remote repository.

> **Note:** the push targets `main`, which is the remote branch you want to reset. Make absolutely sure that the branch name matches your repository configuration.

## 5. Bonus: remove the other remote branches:

If you also want to remove the other remote branches, run the following command for each one:

```bash
git push origin --delete <branch_name>
```

# Conclusion:

Once these steps are complete, the `main` branch of the remote repository will point to the new initial *commit* created from the project's current state. The old history will no longer be accessible from that branch.

Any other remote branches, if they exist, are not affected by this operation. If necessary, they will need to be deleted (see step 5) or rewritten separately.
