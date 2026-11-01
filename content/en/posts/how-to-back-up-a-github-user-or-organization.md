---
title: "How to Back Up a GitHub User or Organization on Linux"
date: 2026-10-19
draft: false
tags: ["GitHub", "Python", "pipx", "Linux", "DevOps"]
categories: ["GitHub"]
author: "Nathan Debilloëz"
description: "Back up a GitHub user or organization account on Linux with pipx and python-github-backup, using a fine-grained personal access token."
---

# Introduction:

This article explains how to back up the data of a GitHub user or organization account on Linux.

We will use `pipx` to install `python-github-backup`, a Python tool that can retrieve a wide range of GitHub data: repositories, Gists, _issues_, _pull requests_, and more. We will then automate the process with a Bash script that bundles the retrieved data into a ZIP archive.

The goal is a solution that is simple, reproducible and reasonably complete.

The method can be adapted to an organization, but this tutorial mainly uses a personal account as its example. GitLab and other online development platforms are not covered.

# Prerequisites:

Before you start, make sure you have the following:

- **A Linux machine**: I will use Ubuntu on WSL (_Windows Subsystem for Linux_), a convenient option if you run Windows and want a Linux environment.
- **Basic familiarity with the terminal**: you need to be able to run Linux commands and edit configuration files.
- **An up-to-date system**: on Ubuntu, you can use `sudo apt update && sudo apt full-upgrade -y`.

The procedure was tested on Ubuntu 24.04 and Ubuntu 26.04.

> **Note:** `apt full-upgrade` may install or remove packages to resolve dependencies. If you prefer a more conservative update, use `sudo apt update && sudo apt upgrade -y`.

# Installing the Tools:

## 1. Install `pipx`:

`pipx` installs Python applications in isolated virtual environments. Unlike a global installation with `pip`, this approach generally avoids mixing the dependencies of different applications or modifying the Python packages managed by the system. It is a good fit for `python-github-backup`, since we only want to install and run a command-line program.

Let's start by installing the required packages:

```bash
sudo apt install pipx python3-full python3-venv git git-lfs zip -y
```

Git is used to fetch the repositories, and `zip` to create the final archive.

Next, add the directory of applications installed by `pipx` to your `PATH`:

```bash
pipx ensurepath
```

If necessary, close and reopen your terminal for the change to take effect.

Finally, check that `pipx` is available:

```bash
pipx --version
```

A version number should be displayed in the terminal.

## 2. Check the Python version:

`python-github-backup` requires Python 3.10 or later. Let's check the installed version:

```bash
python3 --version
```

An output such as `Python 3.12.3` is fine. If your version is older than Python 3.10, install a compatible version before continuing.

## 3. Install `python-github-backup`:

The project is hosted on GitHub: [https://github.com/josegonzalez/python-github-backup](https://github.com/josegonzalez/python-github-backup). It offers many options for choosing which data to retrieve, and we will use them in our Bash script.

To install the tool directly from its repository with `pipx`, run:

```bash
pipx install git+https://github.com/josegonzalez/python-github-backup.git
```

Once the installation is complete, check that the command is available:

```bash
github-backup --help
```

The help output lists the available options. If the command is not found, make sure the `pipx` application directory is in your `PATH`.

> **Note:** this command installs the version available in the repository at the time of installation. Since options may change, check the output of `github-backup --help` and the project documentation before adapting the script.

# Authenticating with GitHub:

## 4. Create a fine-grained personal access token:

To access the data of a GitHub account, the tool needs to authenticate with the GitHub API. We will use a _fine-grained personal access token_. It lets you restrict access to a given account or organization and to specific repositories, and gives you precise control over the permissions granted.

### 4.1. Create the token:

In GitHub, open your account settings and go to:

_Settings_ > _Developer settings_ > _Personal access tokens_ > _Fine-grained tokens_

You can also go directly to this page: [https://github.com/settings/personal-access-tokens](https://github.com/settings/personal-access-tokens).

Create a new token and give it a descriptive name, for example `github-backup-linux`. Then choose the resource owner, meaning the account whose data you want to back up.

Set an expiration date that suits your use. An expiration date means you will have to renew the token, but it limits how long a compromised token remains usable.

### 4.2. Choose the accessible repositories:

In the _Repository access_ section, choose the repositories the token should be able to access. To back up all the repositories your account can access, select all repositories if that option is available and matches your needs.

To back up an organization, select the relevant organization and the appropriate repositories. Some organizations impose restrictions or require administrator approval for tokens.

> **Warning:** the token only grants access to the resources it is authorized for. It cannot back up data that your account itself cannot access.

### 4.3. Configure the permissions:

For the procedure described in this article, configure the following permissions.

**Account permissions**

| Permission  | Access level     |
| ----------- | ---------------- |
| _Followers_ | _Read_           |
| _Starring_  | _Read_           |
| _Gists_     | _Read and write_ |

**Repository permissions**

| Permission              | Access level |
| ----------------------- | ------------ |
| _Contents_              | _Read_       |
| _Discussions_           | _Read_       |
| _Issues_                | _Read_       |
| _Metadata_              | _Read_       |
| _Pull requests_         | _Read_       |
| _Repository advisories_ | _Read_       |
| _Webhooks_              | _Read_       |

The `Contents: Read` permission is essential for accessing repository contents. The `Metadata: Read` permission is usually granted automatically when a token has access to repositories.

These permissions are a baseline for the data covered by this tutorial. Depending on the options you use, the version of the tool, the type of account and any restrictions imposed by an organization, additional permissions may be required.

### 4.4. Why these permissions?

The backup script does not only retrieve repository files. Depending on the options enabled and the permissions granted, it can also try to retrieve:

- private repositories and _forks_;
- Gists;
- _issues_ and their comments;
- _pull requests_, their comments and their reviews;
- discussions;
- wikis and Git LFS data;
- _release_ information and release files;
- starred repositories, followed accounts and followers;
- _webhooks_ and security advisories;
- attachments associated with certain _issues_, _pull requests_ or discussions.

Not all of this data relies on the same permissions, so a backup may be partial if some permissions are missing.

> **Important:** the permissions listed above do not guarantee that every option of the script will work in every context. To retrieve additional data, consult the `python-github-backup` documentation, check the required permissions and add the corresponding options where they are supported. GitHub API limitations, restrictions on fine-grained tokens and organization policies can also prevent some data from being retrieved.

Once the configuration is complete, generate the token and immediately copy it to a safe temporary location. GitHub generally does not let you view the full token value again after it has been created.

### 4.5. Store the token in your `.bashrc` file:

We will store the token in an environment variable named `GITHUB_TOKEN_BACKUP`. The name is just a convention: you can use another one, as long as you use exactly the same name in the `.bashrc` file and in the Bash script.

Open the file:

```bash
nano ~/.bashrc
```

Add the following line at the end of the file, replacing `YOUR_TOKEN_HERE` with the token you just created:

```bash
export GITHUB_TOKEN_BACKUP="YOUR_TOKEN_HERE"
```

Save the file and exit the editor. In Nano, press `Ctrl + O`, then `Enter`, and finally `Ctrl + X`.

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

The `.bashrc` file now contains a plaintext secret. Make sure the permissions on your home directory and on this file are appropriate. You can restrict the file's permissions with:

```bash
chmod 600 ~/.bashrc
```

> **Security tip:** never share your `.bashrc` file, your token, or a screenshot that reveals its value. If the token is exposed, revoke it and create a new one.

# Automating the Backup:

## 5. Create the Bash backup script:

We now have everything we need to automate the backup. The script will:

1. check that the token is present;
2. create a temporary directory and a log file;
3. run `github-backup` with the chosen options;
4. compress the retrieved data into a ZIP archive;
5. verify the integrity of the archive;
6. copy the archive to the destination directory;
7. delete the temporary data if the backup completed successfully;
8. delete archives older than 30 days.

This approach keeps a dated archive for each run while preventing old backups from piling up indefinitely.

### 5.1. Choose the destination directory:

To keep the script usable across different Linux distributions and machines, archives are saved to `~/github-backups` by default.

If you prefer another location, you can change the `GITHUB_BACKUP_DIR` variable. On WSL, for example, you can use a OneDrive folder that is accessible from Linux. This depends on your own setup: the Windows path mounted under `/mnt/c/Users/...` is not the same on every machine.

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
echo "Log file: $LOGFILE"

# Retrieve GitHub data
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
    echo "Temporary data has been kept in: $TEMP_DIR"
    exit 1
fi

# Create the archive
echo "Creating archive: $ARCHIVE_PATH"

(
    cd "$TEMP_DIR"
    zip -r "$ARCHIVE_PATH" .
)

# Integrity check
echo "Verifying archive..."
zip -T "$ARCHIVE_PATH"

# Copy the archive to the destination
echo "Copying archive to $DEST_PATH"
cp "$ARCHIVE_PATH" "$DEST_PATH/"

# Cleanup after a successful backup
rm -rf -- "$TEMP_DIR"
rm -f -- "$ARCHIVE_PATH"

# Delete archives older than 30 days
find "$DEST_PATH" \
    -maxdepth 1 \
    -type f \
    -name 'github_backup_full_*.zip' \
    -mtime +30 \
    -delete

echo "Backup completed successfully."
echo "Archive: $DEST_PATH/$ARCHIVE_NAME"
echo "Log file: $LOGFILE"
```

### 5.3. Understand how the script works:

Although it looks long, the script is fairly simple. Here is a walkthrough of its parts.

#### The first lines:

```bash
#!/usr/bin/env bash
set -Eeuo pipefail
```

The first line tells the system to run the script with Bash. The second enables several options that improve error detection: the script stops when a command fails, when an undefined variable is used, or when a command fails inside a _pipeline_.

#### Account and token configuration:

```bash
GITHUB_USER="Nde-Code"
TOKEN="${GITHUB_TOKEN_BACKUP:-}"
```

`GITHUB_USER` is the name of the GitHub account to back up. Replace `Nde-Code` with your own username or with the name of the target organization.

The token is read from the `GITHUB_TOKEN_BACKUP` environment variable, defined earlier in `.bashrc`. The expression `${GITHUB_TOKEN_BACKUP:-}` returns an empty string if the variable does not exist, instead of immediately triggering an error because of `set -u`.

#### Creating paths and files:

```bash
DATE="$(date +%Y-%m-%d_%H%M%S)"
TEMP_DIR="$(mktemp -d /tmp/github_backup_temp.XXXXXX)"
ARCHIVE_NAME="github_backup_full_${DATE}.zip"
ARCHIVE_PATH="/tmp/${ARCHIVE_NAME}"
LOGFILE="/tmp/github_backup_${DATE}.log"
DEST_PATH="${GITHUB_BACKUP_DIR:-"$HOME/github-backups"}"
```

Each run uses a timestamp to tell backups apart.

- `TEMP_DIR`: temporary directory where the tool downloads the data.
- `ARCHIVE_NAME`: name of the final ZIP archive.
- `ARCHIVE_PATH`: temporary location of the archive before it is copied.
- `DEST_PATH`: directory where backups are kept.
- `LOGFILE`: file containing the script's output and error messages.

By default, archives are stored in `~/github-backups`. The `GITHUB_BACKUP_DIR` environment variable lets you choose another location without modifying the script.

#### Logging:

```bash
exec > >(tee -a "$LOGFILE") 2>&1
```

This instruction sends the script's output to the terminal and appends it to the log file. It lets you follow progress and makes it easier to track down the cause of a problem.

#### The `github-backup` call:

This is the core of the script. The command retrieves the data accessible on GitHub according to the options provided.

The `-f "$TOKEN"` and `-o "$TEMP_DIR"` options set the authentication token and the output directory respectively. The `-P` and `-F` options include private repositories and _forks_. The remaining options enable the retrieval of various categories of data.

The script already covers a large amount of data: repositories, Gists, _issues_, _pull requests_, discussions, wikis, _releases_ and several kinds of metadata. The backup is therefore fairly broad, though not necessarily exhaustive.

To back up other data or fine-tune what is retrieved, consult `github-backup --help` and the project documentation. Add the necessary permissions to the token along with the corresponding options where they exist: not every category is accessible with every type of token or account.

#### Creating and verifying the archive:

```bash
(
    cd "$TEMP_DIR"
    zip -r "$ARCHIVE_PATH" .
)

zip -T "$ARCHIVE_PATH"
```

The script moves into the temporary directory and compresses its contents. The `zip -T` command checks the integrity of the resulting archive. This check is useful, but it does not prove that all the expected data was downloaded: you still need to review the log and inspect the archive contents.

#### Copying and cleaning up:

```bash
cp "$ARCHIVE_PATH" "$DEST_PATH/"
```

Once the archive has been created and verified, it is copied to the backup directory. Temporary files are only deleted after this step. Finally, the `find` command deletes archives matching the `github_backup_full_*.zip` pattern whose modification date is more than 30 days old.

This retention policy is deliberately simple. Adapt it if you want to keep more history or protect certain backups from accidental deletion.

> **Warning:** if retrieval, compression, verification or copying fails, `set -e` stops the script. The temporary data may then remain in `/tmp` to help with diagnosis. Check the log before deleting it manually.

### 5.4. Use OneDrive or another location:

The `~/github-backups` location is a generic choice that suits most Linux environments.

If you use Ubuntu on WSL and your OneDrive folder is accessible from Linux, you can choose it without modifying the script. Adapt the path below to your own Windows username and to the actual location of your OneDrive folder:

```bash
export GITHUB_BACKUP_DIR="/mnt/c/Users/YOUR_USERNAME/OneDrive/GitHub"
```

Add this line to `~/.bashrc`, then reload the configuration:

```bash
source ~/.bashrc
```

The script will now use this folder as its destination. If the variable is not set, it will keep using `~/github-backups`.

> **Keep in mind:** OneDrive synchronization is convenient, but it is not a substitute for an independent backup strategy. A synchronized deletion or corruption can also affect the remote copies. For important data, keep another copy on a separate medium or in a separate location if possible.

### 5.5. Make the script executable:

Save the file, then give it the necessary permissions:

```bash
chmod +x ~/save-github.sh
```

You can now run it directly:

```bash
~/save-github.sh
```

The first run can take quite a while, especially if you own many private repositories, Git LFS files, or a large number of _issues_ and _pull requests_.

The `--throttle-limit 100 --throttle-pause 60` settings may cause pauses as the API rate limit approaches. You can adjust these values after reviewing the documentation and your execution logs.

## 6. Create a Linux alias to run the backup:

To avoid typing the full path of the script every time, we will create an alias named `save-github`.

Open the `.bashrc` file:

```bash
nano ~/.bashrc
```

Add the following at the end of the file:

```bash
alias save-github="$HOME/save-github.sh"
```

Save the file, then reload the configuration:

```bash
source ~/.bashrc
```

You can now start the backup from your terminal with a single command:

```bash
save-github
```

The alias works in Bash sessions that load this configuration file. If you use another shell, you will need to adapt the configuration.

# First Backup and Checks:

## 7. Run your first backup:

Everything is ready. Simply run:

```bash
save-github
```

The script retrieves the data accessible on GitHub, creates a ZIP archive and copies it to the destination directory. By default, you will find it in:

```text
~/github-backups/
```

If you have set `GITHUB_BACKUP_DIR`, the archive will be saved there instead. Its name will look like this:

```text
github_backup_full_2026-10-19_130000.zip
```

The date and time will of course depend on when you run the command.

Logs are saved in `/tmp`, in the form `github_backup_DATE.log`. If something goes wrong, check the log for the run in question.

## 8. Check the result:

Before considering the backup operational, I recommend checking the following points:

- The ZIP archive exists and can be opened.
- The expected repositories are present.
- The additional data you are after, such as Gists, _issues_ and _pull requests_, has been retrieved.
- The log contains no authentication or permission errors.
- You have enough disk space for successive backups.

Finally, test restoring a few items into a separate directory: a backup is only really useful if you can make use of the data it contains.

# Conclusion:

We have set up a GitHub backup solution for Linux built on three elements: `pipx` to install the Python application, `python-github-backup` to retrieve the data, and a Bash script to automate the process and create a ZIP archive.

This approach requires no special infrastructure and can be run on demand. The script can also serve as a basis for further automation.

Keep in mind, however, that a backup stored on the same computer does not protect against every data-loss scenario. To go further, you can copy the archives to an external drive or to another independent location.

Finally, the backup remains limited by the token's permissions, the account's access rights and the features supported by the tool. The script provided already enables many options, but it does not guarantee a complete copy of all GitHub data. To retrieve additional items, consult the official documentation, add the necessary permissions to the token and enable the corresponding options where they are supported.
