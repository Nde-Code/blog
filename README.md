# Nathan Debilloëz - blog:

This repository contains the source code of my static website dedicated to my articles and tutorials, built with Hugo and the `go.ngs.io/hugo-primer-blog` theme using Hugo modules.

The website is available in both English and French. I plan to publish each article in these two languages, and potentially add more languages in the future. The content is based on a simple structure: standard YAML metadata and Markdown for writing articles.

## ⚡ Quick installation:

### Prerequisites:

Before running the project, make sure you have installed:

- **Go** ([https://go.dev/](https://go.dev/)): the programming language required for Hugo (v0.146.0 or later) to work.

- **Hugo Extended** ([https://gohugo.io/getting-started/quick-start/](https://gohugo.io/getting-started/quick-start/)): which includes additional features compared to the standard version.

- **Node.js** ([https://nodejs.org/en](https://nodejs.org/en)): used to provide access to development tools and dependencies distributed through npm when required.

- **Git** ([https://git-scm.com/](https://git-scm.com/)): the version control tool used to clone repositories and push updates.

> You only need to install these if you want to work locally instead of using GitHub Codespaces, as explained below.

### Installation via GitHub Codespaces:

The repository includes a preconfigured development environment for GitHub Codespaces. When launching the Codespace:

1. The container is automatically initialized, and all the required prerequisites are installed.

2. The Hugo theme is updated (if necessary) using the `hugo mod get -u` command.

3. You can start the local server directly from the container using `hugo server`.

### Local installation (on Linux/WSL):

1. Open a terminal at the root of the project.

2. Check your environment by running: `bash env.sh`.

3. If the script indicates that everything is correct, you can continue; otherwise, install the missing tools.

4. Update the Hugo theme: `hugo mod get -u`.

5. Start the local development server: `hugo server`.

### Online deployment:

The project includes a workflow powered by [GitHub Actions]([https://docs.github.com/fr/actions](https://docs.github.com/fr/actions)) that automatically deploys the website to [GitHub Pages]([https://docs.github.com/en/pages](https://docs.github.com/en/pages)) every time a new change is pushed to the `main` branch, without requiring any additional configuration.

The deployment file can be viewed here: [.github/workflows/build_and_deploy.yaml](.github/workflows/build_and_deploy.yaml). Since its structure is not trivial, it is strongly recommended to fully understand how it works before making any modifications.

## 🏗️ Content creation:

Articles are stored in the [`content/`](content/) folder and rely on a predefined *archetype* to simplify the initial configuration.

- Each new article must include YAML metadata in its header (*front matter*).

- The default *archetype* is located at [`archetypes/default.md`](archetypes/default.md).

- It automatically generates:

  - the title (based on the filename),

  - the article creation date,

  - the author,

  - the draft status (`draft: true`),

  - empty tags, categories, and description fields ready to be completed.

### Creating a new article:

There are two different ways to proceed:

#### Method 1, automatically using the Hugo command:

Run the following command in your terminal:

```text
hugo new <language>/posts/my-super-article.md
````

> For an English article: `hugo new en/posts/my-english-article.md`.

Everything is generated automatically. You only need to complete the YAML *front matter* and write the content.

Do not forget to set `draft` to `false` when the article is ready to be published.

#### Method 2, manually:

1. Create a new Markdown file in [`content/en/posts/`](content/en/posts/) or [`content/fr/posts/`](content/fr/posts/).

2. Add a YAML header structured as follows (and complete it as needed):

```yaml
---
title: "My first Hugo article"
date: YYYY-MM-DD
draft: true
tags: ["hugo", "tutorial", "web development"]
categories: ["Development", "Documentation"]
author: "Your name"
description: "A short description explaining the purpose and content of this article."
---
```

3. Write your content in Markdown directly below this header.

4. Change the value to `draft: false` when the article is ready for publication.

## 📁 Project structure:

The project folders and files are organized as follows:

```text
├── .github/
│   ├── workflows/
│   │   └── build_and_deploy.yaml  # GitHub Actions workflow to build and publish the blog.
│   └── dependabot.yaml            # Configuration for automatic dependency updates.
│
├── .vscode/
│   └── settings.json              # Very simple VS Code configuration to hide unnecessary files.
│
├── archetypes/
│   └── default.md                 # Template for automatically creating new articles.
│
├── assets/
│   └── css/custom.css             # Theme style overrides to add custom elements if needed.
│
├── content/
│   ├── en/posts/                  # Blog articles in English (main language).
│   └── fr/posts/                  # Blog articles in French.
│
├── i18n/
│   ├── en.toml                    # English interface string translations.
│   └── fr.toml                    # French interface string translations.
│
├── layouts/                       # Custom HTML templates or theme overrides.
│
├── static/                        # Static files (images, favicons, robots.txt, ...).
│
├── .devcontainer.json             # GitHub Codespaces environment configuration.
├── .gitignore                     # Files and folders ignored by Git (public/, node_modules/, ...).
├── LICENSE                        # Project distribution license.
├── README.md                      # Project documentation.
├── env.sh                         # Local development environment verification script.
├── go.mod                         # Go module declaration and theme version.
├── go.sum                         # Security checksums for Go modules.
└── hugo.toml                      # Main Hugo website configuration file.
```

## ⚖️ License:

This project is distributed under the **[GNU General Public License v3.0](https://github.com/Nde-Code/blog?tab=GPL-3.0-1-ov-file)**.

## 🎯 Author:

This project is created and maintained by [Nde-Code](https://nde-code.github.io/).

> Feel free to help me by correcting any spelling mistakes, inaccuracies, or other issues by opening an issue or a pull request.
