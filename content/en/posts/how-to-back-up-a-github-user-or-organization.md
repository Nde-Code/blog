---
title: "How to Back Up a GitHub User or Organization on Linux"
date: 2026-10-19
draft: false
tags: ["GitHub", "Python", "pipx", "Linux", "DevOps"]
categories: ["GitHub"]
author: "Nathan Debilloëz"
description: "Back up a GitHub user account or organization on Linux using pipx and python-github-backup, with a fine-grained personal access token."
---

# Introduction:

This article explains how to back up the data of a GitHub user account or organization on Linux.

We will use `pipx` to install `python-github-backup`, a Python tool that can retrieve a wide range of GitHub data, including repositories, Gists, _issues_, _pull requests_, and more. We will then automate the procedure with a Bash script that bundles the retrieved data into a ZIP archive.

The goal is to end up with a solution that is simple, reproducible, and reasonably complete.

Although the method can be adapted to an organization, this tutorial mainly uses a personal account as its example. GitLab and other online development platforms will not be covered here.

# Prerequisites:

Before you begin, make sure you have the following:

- **A Linux machine**: I will be using Ubuntu on WSL (_Windows Subsystem for Linux_), a convenient solution if you use Windows and want a Linux environment.

- **Basic knowledge of the terminal**: you need to be able to run Linux commands and edit configuration files.

- **An up-to-date system**: on Ubuntu, you can use the following commands: `sudo apt update && sudo apt full-upgrade -y`.

The procedure has been tested on Ubuntu 24.04 and Ubuntu 26.04.

> **Note:** `apt full-upgrade` may install or remove some packages in order to resolve dependencies. If you prefer a more cautious update, you can use `sudo apt update && sudo apt upgrade -y`.

# Installation procedure:

## 1. Install `pipx`:

`pipx` is a tool that lets you install Python applications in isolated virtual environments.

Unlike a global installation with `pip`, this approach generally avoids mixing the dependencies of different Python applications or modifying the Python packages managed by the system. It is particularly well suited to `python-github-backup`, since we simply want to install and use the command-line program.

Let's start by installing the required packages:

```bash
sudo apt install pipx python3-full python3-venv git git-lfs zip -y
```

We are also installing Git, which is used to retrieve the repositories, and `zip`, which will be used to create the final archive.

Next, let's add the directory of the applications installed by `pipx` to the `PATH`:

```bash
pipx ensurepath
```

If necessary, close and reopen your terminal so that the change takes effect.

Finally, check that `pipx` is available:

```bash
pipx --version
```

A version number should be displayed in the terminal.

## 2. Check the Python version:

`python-github-backup` requires Python 3.10 or a more recent version.

Let's check the installed version:

```bash
python3 --version
```

For example, an output such as `Python 3.12.3` is fine. If your version is older than Python 3.10, install a compatible version before continuing.

## 3. Install `python-github-backup`:

We will now install the backup tool. The project is available on GitHub: [https://github.com/josegonzalez/python-github-backup](https://github.com/josegonzalez/python-github-backup).

It offers many options for choosing which data to retrieve. We will use them in our Bash script later on.

To install the tool directly from its GitHub repository with `pipx`, run:

```bash
pipx install git+https://github.com/josegonzalez/python-github-backup.git
```

Once the installation is complete, check that the command is available:

```bash
github-backup --help
```

The help output displays the available options. If the command is not found, check that the `pipx` applications directory is present in your `PATH`.

> **Note:** this command installs the version available in the repository at the time of installation. Options may change; therefore, check the output of `github-backup --help` and the project documentation before adapting the script.

## 4. Create a GitHub _fine-grained personal access token_:

To access the data of a GitHub account, the tool must be able to authenticate with the GitHub API.

We will use a _fine-grained personal access token_. It lets you restrict access to a specific account or organization and to specific repositories, and choose which permissions are granted.

### 4.1. Create the token:

In GitHub, open your account settings and go to:

_Settings_ → _Developer settings_ → _Personal access tokens_ → _Fine-grained tokens_

You can also go directly to this page: [https://github.com/settings/personal-access-tokens](https://github.com/settings/personal-access-tokens).

Create a new token and give it a descriptive name, for example `github-backup-linux`. Then choose the account that owns the data to be backed up.

Set an expiration date that suits how you will use it. An expiration date means you will have to renew the token, but it limits how long a compromised token remains usable.

### 4.2. Choose the accessible repositories:

In the _Repository access_ section, choose the repositories the token should have access to.

To back up all the accessible repositories of your account, select all repositories if this option is available and fits your needs.

If you want to back up an organization, select the organization concerned and the appropriate repositories. Some organizations impose restrictions or require administrator approval for tokens.

> **Warning:** the token only grants access to authorized resources. It cannot be used to back up data that your account does not have access to.

### 4.3. Configure the permissions:

For the procedure presented in this article, the permissions to configure are as follows.

**User account permissions (_Account permissions_):**

| Permission  | Access level     |
| ----------- | ---------------- |
| _Followers_ | _Read_           |
| _Starring_  | _Read_           |
| _Gists_     | _Read and write_ |

**Repository permissions (_Repository permissions_):**

| Permission              | Access level |
| ----------------------- | ------------ |
| _Contents_              | _Read_       |
| _Discussions_           | _Read_       |
| _Issues_                | _Read_       |
| _Metadata_              | _Read_       |
| _Pull requests_         | _Read_       |
| _Repository advisories_ | _Read_       |
| _Webhooks_              | _Read_       |

The `Contents: Read` permission is particularly important for accessing the contents of repositories. The `Metadata: Read` permission is generally granted automatically when a token has access to repositories.

These permissions are a baseline for the data targeted by this tutorial. Depending on the options used, the version of the tool, the type of account, and the restrictions imposed by an organization, additional permissions may be required.

### 4.4. Why these permissions?

The backup script does not only retrieve the repositories' files. Depending on the options enabled and the permissions granted, it may also attempt to retrieve:

- private repositories and _forks_;
- Gists;
- _issues_ and their comments;
- _pull requests_, their comments, and their reviews;
- discussions;
- wikis and Git LFS data;
- _release_ information and their files;
- starred repositories, subscriptions, and followers;
- _webhooks_ and security advisories;
- attachments associated with certain _issues_, _pull requests_, or
  discussions.

Not all of this data necessarily relies on the same permissions. A backup may therefore be partial if some permissions are missing.

> **Important:** the permissions listed above do not guarantee that every option of the script will work in every context. If you want to retrieve additional data, consult the `python-github-backup` documentation, check the required permissions, and add the corresponding options when they are supported. GitHub API limitations, restrictions on fine-grained tokens, and organization policies may also prevent some data from being retrieved.

Once the configuration is complete, generate the token and immediately copy it to a safe temporary location. GitHub generally does not let you view the full value of the token again after it has been created.

### 4.5. Save the token in the `.bashrc` file:

We will store the token in an environment variable named `GITHUB_TOKEN_BACKUP`.

This name is simply a convention: you could use a different one, but you would then need to use exactly the same name in the `.bashrc` file and in the Bash script.

Open the file:

```bash
nano ~/.bashrc
```

Add the following line at the end of the file, replacing `YOUR_TOKEN_HERE` with the token you have just created:

```bash
export GITHUB_TOKEN_BACKUP="YOUR_TOKEN_HERE"
```

Save the file and exit the editor. With Nano, use `Ctrl + O`, then `Enter`, and finally `Ctrl + X`.

Reload the configuration:

```bash
source ~/.bashrc
```

You can check that the variable is set without displaying its value:

```bash
if [[ -n "${GITHUB_TOKEN_BACKUP:-}" ]]; then
    echo "The token is configured."
else
    echo "The token is not configured."
fi
```

The `.bashrc` file now contains a secret in plain text. Make sure the permissions on your home directory and on this file are appropriate. You can restrict the file's permissions with:

```bash
chmod 600 ~/.bashrc
```

> **Security tip:** never share your `.bashrc` file, your token, or a screenshot that would reveal its value. If the token is exposed, revoke it and create a new one.

## 5. Create the Bash backup script:

We now have everything we need to automate the backup.

The script will:

1. check that the token is present;
2. create a temporary directory and a log file;
3. run `github-backup` with the chosen options;
4. compress the retrieved data into a ZIP archive;
5. verify the integrity of the archive;
6. copy the archive to the destination directory;
7. delete the temporary data if the backup completed
   successfully;
8. delete archives older than 30 days.

This method keeps a dated archive for each run, while avoiding the endless accumulation of old backups.

### 5.1. Choose the destination directory:

So that the script remains usable across different Linux distributions and machines, we will save the archives in `~/github-backups` by default.

If you prefer another location, you can change the `GITHUB_BACKUP_DIR` variable. For example, on WSL, you can use a OneDrive folder that is accessible from Linux. This depends on your own setup: the Windows path mounted under `/mnt/c/Users/...` is not the same on every machine.

### 5.2. Write the script:

Create a file named `save-github.sh`:

```bash
nano ~/save-github.sh
```

Paste the following complete script into it:

```bash
#!/usr/bin/env bash
set -Eeuo pipefail

# GitHub account to back up
GITHUB_USER="Nde-Code"

# Token provided by the environment
TOKEN="${GITHUB_TOKEN_BACKUP:-}"

if [[ -z "$TOKEN" ]]; then
    echo "ERROR: the GITHUB_TOKEN_BACKUP variable is empty or missing."
    exit 1
fi

# Directories and files
DATE="$(date +%Y-%m-%d_%H%M%S)"
TEMP_DIR="$(mktemp -d /tmp/github_backup_temp.XXXXXX)"
ARCHIVE_NAME="github_backup_full_${DATE}.zip"
ARCHIVE_PATH="/tmp/${ARCHIVE_NAME}"
LOGFILE="/tmp/github_backup_${DATE}.log"

# Destination directory: generic default location.
# You can set GITHUB_BACKUP_DIR to use a different location.
DEST_PATH="${GITHUB_BACKUP_DIR:-"$HOME/github-backups"}"

mkdir -p "$DEST_PATH"

# Log standard output and errors
exec > >(tee -a "$LOGFILE") 2>&1

echo "GitHub backup started: $(date)"
echo "Account: $GITHUB_USER"
echo "Destination directory: $DEST_PATH"
echo "Log: $LOGFILE"

# Retrieving GitHub data
github-backup -f "$TOKEN" \
    -o "$TEMP_DIR" \
    -P -F \
    --repositories --gists \
    --issues --issue-comments --issue-events \
    --pulls --pull-comments --pull-reviews --pull-commits --pull-details \
    --labels --milestones --discussions \
    --wikis --lfs \
    --releases --assets \
    --starred \
    --followers \
    --following \
    --hooks \
    --security-advisories \
    --attachments \
    --throttle-limit 100 \
    --throttle-pause 60 \
    "$GITHUB_USER"

# Refuse to produce an empty archive
if [[ -z "$(find "$TEMP_DIR" -mindepth 1 -print -quit)" ]]; then
    echo "ERROR: no data was retrieved."
    echo "The temporary data has been kept in: $TEMP_DIR"
    exit 1
fi

# Creating the archive
echo "Creating archive: $ARCHIVE_PATH"

(
    cd "$TEMP_DIR"
    zip -r "$ARCHIVE_PATH" .
)

# Integrity check
echo "Verifying the archive..."
zip -T "$ARCHIVE_PATH"

# Copying the archive to the destination
echo "Copying the archive to $DEST_PATH"
cp "$ARCHIVE_PATH" "$DEST_PATH/"

# Cleanup after a successful backup
rm -rf -- "$TEMP_DIR"
rm -f -- "$ARCHIVE_PATH"

# Deleting archives older than 30 days
find "$DEST_PATH" \
    -maxdepth 1 \
    -type f \
    -name 'github_backup_full_*.zip' \
    -mtime +30 \
    -delete

echo "Backup completed successfully."
echo "Archive: $DEST_PATH/$ARCHIVE_NAME"
echo "Log: $LOGFILE"
```

### 5.3. Understand how the script works:

Even though the script may look long, how it works is fairly simple.

#### The first lines:

```bash
#!/usr/bin/env bash
set -Eeuo pipefail
```

The first line indicates that the script must be run with Bash. The second enables several options designed to improve error detection: the script stops, in particular, when a command fails, when an undefined variable is used, or when a command in a _pipeline_ fails.

#### The account and token configuration:

```bash
GITHUB_USER="Nde-Code"
TOKEN="${GITHUB_TOKEN_BACKUP:-}"
```

`GITHUB_USER` is the name of the GitHub account to back up. Replace `Nde-Code` with your own username or that of the targeted organization.

The token is read from the `GITHUB_TOKEN_BACKUP` environment variable, defined earlier in `.bashrc`. The expression `${GITHUB_TOKEN_BACKUP:-}` returns an empty string if the variable does not exist, rather than immediately triggering an error because of `set -u`.

#### The creation of paths and files:

```bash
DATE="$(date +%Y-%m-%d_%H%M%S)"
TEMP_DIR="$(mktemp -d /tmp/github_backup_temp.XXXXXX)"
ARCHIVE_NAME="github_backup_full_${DATE}.zip"
ARCHIVE_PATH="/tmp/${ARCHIVE_NAME}"
LOGFILE="/tmp/github_backup_${DATE}.log"
DEST_PATH="${GITHUB_BACKUP_DIR:-"$HOME/github-backups"}"
```

Each run uses a timestamp to tell backups apart.

- `TEMP_DIR`: temporary directory in which the tool downloads the data.
- `ARCHIVE_NAME`: name of the final ZIP archive.
- `ARCHIVE_PATH`: temporary location of the archive before it is copied.
- `DEST_PATH`: directory in which the backups are kept.
- `LOGFILE`: file containing the script's output and error messages.

By default, archives are placed in `~/github-backups`. The `GITHUB_BACKUP_DIR` environment variable lets you choose a different location without having to modify the script.

#### Logging:

```bash
exec > >(tee -a "$LOGFILE") 2>&1
```

This instruction sends the script's output to the terminal and appends it to the log file. It lets you follow the progress and makes it easier to track down the cause of a problem.

#### The call to `github-backup`:

This is the heart of the script. The command retrieves the data accessible on GitHub according to the options provided.

The `-f "$TOKEN"` and `-o "$TEMP_DIR"` options set the authentication token and the output directory, respectively.

The `-P` and `-F` options tell the tool to include private repositories and _forks_. The other options enable the retrieval of various categories of data.

This script already covers a large amount of data: repositories, Gists, _issues_, _pull requests_, discussions, wikis, _releases_, and several kinds of metadata. It is therefore a fairly broad backup, but not necessarily an exhaustive one.

If you want to back up other data or fine-tune exactly what is retrieved, consult `github-backup --help` and the project documentation. Add the necessary permissions to the token as well as the corresponding options when they exist. Not all categories are accessible with every type of token or every account.

#### Creating and verifying the archive:

```bash
(
    cd "$TEMP_DIR"
    zip -r "$ARCHIVE_PATH" .
)

zip -T "$ARCHIVE_PATH"
```

The script moves into the temporary directory and then compresses its contents. The `zip -T` command verifies the integrity of the resulting archive.

This check is useful, but it does not prove that all the expected data has been downloaded. You still need to review the log and check the contents of the archive.

#### Copying and cleanup:

```bash
cp "$ARCHIVE_PATH" "$DEST_PATH/"
```

Once the archive has been created and verified, it is copied to the backup directory.

The temporary files are only deleted after this step. Finally, the `find` command deletes archives matching the `github_backup_full_*.zip` pattern whose modification date is more than 30 days old.

This retention policy is deliberately simple. Adapt it if you want to keep more history or protect certain backups from accidental deletion.

> **Warning:** if retrieval, compression, verification, or copying fails, `set -e` interrupts the script. The temporary data may then remain in `/tmp` to make diagnosis easier. Check the log before deleting it manually.

### 5.4. Use OneDrive or another location:

The `~/github-backups` location is a generic choice that suits most Linux environments.

If you use Ubuntu on WSL and your OneDrive folder is accessible from Linux, you can choose that folder without modifying the script. For example, adapt the path below to your own Windows username and to the actual location of your OneDrive folder:

```bash
export GITHUB_BACKUP_DIR="/mnt/c/Users/YOUR_USERNAME/OneDrive/GitHub"
```

Add this line to `~/.bashrc`, then reload the configuration:

```bash
source ~/.bashrc
```

The script will now use this folder as its destination. If the variable is not set, it will continue to use `~/github-backups`.

> **Keep in mind:** OneDrive synchronization is convenient, but it is not a substitute for an independent backup strategy. A synchronized deletion or corruption can also affect the remote copies. For important data, keep another copy on a separate medium or in a separate location whenever possible.

### 5.5. Make the script executable:

Save the file, then give it the necessary permissions:

```bash
chmod +x ~/save-github.sh
```

You can now run it directly:

```bash
~/save-github.sh
```

The first run can take quite a long time, especially if you own many private repositories, Git LFS files, or many _issues_ and _pull requests_.

The `--throttle-limit 100 --throttle-pause 60` setting may cause pauses when the API limit is approaching. You can adjust these values after consulting the documentation and the execution logs.

## 6. Create a Linux alias to launch the backup:

So that you don't have to type the full path of the script every time, we will create an alias named `save-github`.

Open the `.bashrc` file:

```bash
nano ~/.bashrc
```

Add the following at the end of the file:

```bash
alias save-github="$HOME/save-github.sh"
```

Save, then reload the configuration:

```bash
source ~/.bashrc
```

You can now launch the backup from your terminal with a simple command:

```bash
save-github
```

The alias works in Bash sessions that load this configuration file. If you use a different shell, the configuration will need to be adapted.

## 7. Run your first backup:

Everything is now ready for your first backup.

Simply run:

```bash
save-github
```

The script will retrieve the data accessible on GitHub, create a ZIP archive, and copy it to the destination directory.

By default, you will find it in:

```text
~/github-backups/
```

If you have set `GITHUB_BACKUP_DIR`, the archive will be saved at that location. Its name will look like this:

```text
github_backup_full_2026-10-19_130000.zip
```

The date and time will, of course, depend on when you run the command.

Logs are saved in `/tmp`, in the form `github_backup_DATE.log`. If a problem occurs, check the log corresponding to the run in question.

## 8. A few checks after the first run:

Before considering the backup operational, I recommend checking the following points:

- The ZIP archive exists and can be opened.
- The expected repositories are present.
- The additional data you were looking for, such as Gists, _issues_, and _pull requests_, has been retrieved.
- The log contains no authentication or permission errors.
- You have enough disk space for successive backups.

Finally, test restoring some of the data into a separate directory. A backup is only truly useful if the retrieved data can actually be used.

# Conclusion:

We have set up a GitHub backup solution on Linux based on three elements: `pipx` to install the Python application, `python-github-backup` to retrieve the data, and a Bash script to automate the procedure and create a ZIP archive.

The advantage of this approach is that it requires no particular infrastructure and can be run on demand. The script can also serve as a basis for later automation.

However, keep in mind that a backup made on the same computer does not protect against every data-loss scenario. To go further, you can copy the archives to an external drive or another independent location.

Finally, the backup remains limited by the token's permissions, the account's rights, and the features supported by the tool. The provided script already enables many options, but it does not guarantee a complete copy of all GitHub data. If you want to retrieve additional items, consult the official documentation, add the necessary permissions to the token, and enable the corresponding options when they are supported.
