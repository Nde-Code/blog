<div align="center">

# ✍️ Nathan Debilloëz — Blog

**Source code of my static website dedicated to articles and tutorials.**

Built with [Hugo](https://gohugo.io/) and the [`go.ngs.io/hugo-primer-blog`](https://go.ngs.io/hugo-primer-blog) theme, using Hugo Modules.

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://github.com/Nde-Code/blog?tab=GPL-3.0-1-ov-file)
[![Built with Hugo](https://img.shields.io/badge/Built%20with-Hugo-ff4088.svg)](https://gohugo.io/)

</div>

---

The website is available in both **English** and **French**. Each article is planned to be published in these two languages, with potentially more languages added in the future. Content relies on a simple structure: standard YAML metadata and Markdown for writing articles.

## 📑 Table of contents

- [⚡ Quick installation](#-quick-installation)
  - [Using GitHub Codespaces](#using-github-codespaces)
  - [Local installation](#local-installation)
  - [Online deployment](#online-deployment)
- [🏗️ Content creation](#️-content-creation)
  - [Creating a new article](#creating-a-new-article)
  - [Publishing the article](#publishing-the-article)
- [⚖️ License](#️-license)
- [🎯 Author](#-author)

---

## ⚡ Quick installation

### Using GitHub Codespaces

You can run the project directly using [GitHub Codespaces](https://docs.github.com/en/codespaces/about-codespaces/what-are-codespaces), without installing Git, Go, or Hugo locally. This is the **recommended** option if you want to get started quickly.

The repository includes a preconfigured development environment for GitHub Codespaces. When launching the Codespace:

1. The container is automatically initialized, and all the required prerequisites are installed.
2. The Hugo theme is updated (if necessary) using the `hugo mod get -u` command.
3. You can start the local server directly from the container using `hugo server`.

### Local installation

If you prefer to work locally, make sure you have the following installed before running the project:

| Tool | Description |
| --- | --- |
| **[Git](https://git-scm.com/)** | The version control tool used to clone repositories and push updates. |
| **[Go](https://go.dev/)** | The programming language required to use this project, as it relies on Hugo Modules. |
| **[Hugo](https://gohugo.io/)** (standard, v0.146.0 or later) | The Hugo edition and minimum version required to build and run the project. |

> 🐧 Working on Linux is recommended for this project. If you are using Windows, use [WSL](https://github.com/microsoft/WSL).

**Linux setup:**

1. Open a terminal if you don't already have one open.
2. Check your environment by running:
   ```bash
   bash env.sh
   ```
3. If the script indicates that everything is correct, you can continue; otherwise, install the missing tools.
4. Clone the repository:
   ```bash
   git clone https://github.com/Nde-Code/blog.git
   ```
5. Go to the project directory:
   ```bash
   cd blog
   ```
6. Update the theme if a newer version is available:
   ```bash
   hugo mod get -u
   ```
7. Start the local development server:
   ```bash
   hugo server
   ```

### Online deployment

The project includes a workflow powered by [GitHub Actions](https://docs.github.com/en/actions) that automatically deploys the website to [GitHub Pages](https://docs.github.com/en/pages) every time a new change is pushed to the `main` branch, without requiring any additional configuration.

The deployment file can be viewed here: [`.github/workflows/build_and_deploy.yaml`](.github/workflows/build_and_deploy.yaml).

> ⚠️ Since its structure is not trivial, it is strongly recommended to fully understand how it works before making any modifications.

## 🏗️ Content creation

Articles are stored in the [`content/`](content/) folder and rely on a predefined *archetype* to simplify the initial configuration.

- Each new article must include YAML metadata in its header (*front matter*).
- The default *archetype* is located at [`archetypes/default.md`](archetypes/default.md).
- It automatically generates:
  - the title (based on the filename),
  - the article creation date,
  - the author,
  - the draft status (`draft: true`),
  - empty tags, categories, and description fields ready to be completed.

### Creating a new article

There are two ways to create a new article.

**Method 1 — Using the Hugo command:**

Run the following command in your terminal (make sure to replace `<language>` with the appropriate language code):

```text
hugo new content/<language>/posts/my-super-article.md
```

For example, for an English article:

```bash
hugo new content/en/posts/my-english-article.md
```

For a French article:

```bash
hugo new content/fr/posts/my-french-article.md
```

Hugo automatically generates the file with the required *front matter*. You only need to complete the YAML *front matter* and write the content.

**Method 2 — Manually:**

1. Create a new Markdown file in [`content/en/posts/`](content/en/posts/) or [`content/fr/posts/`](content/fr/posts/).
2. Add a YAML header structured as follows, and complete it as needed:

   ```yaml
   ---
   title: "My first Hugo article"
   date: YYYY-MM-DD
   draft: true
   tags: ["Hugo", "Tutorial"]
   categories: ["Development", "Documentation"]
   author: "Your name"
   description: "A short description explaining the purpose and content of this article."
   ---
   ```

3. Write your content in Markdown directly below the YAML header.

### Publishing the article

When the article is ready to be published, change:

```yaml
draft: true
```

to:

```yaml
draft: false
```

## ⚖️ License

This project is distributed under the **[GNU General Public License v3.0](https://github.com/Nde-Code/blog?tab=GPL-3.0-1-ov-file)**.

## 🎯 Author

This project is created and maintained by **[Nde-Code](https://nde-code.github.io/)**.

> Feel free to help me by correcting any spelling mistakes, inaccuracies, or other issues by opening an issue or a pull request.
