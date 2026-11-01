# Contributing

Thank you for your interest in contributing to this project. Contributions are welcome, whether they involve improving existing articles, correcting mistakes, adding new content, or fixing technical issues.

Before submitting a contribution, please read the following guidelines.

## Content contributions

This project is primarily a multilingual blog. Contributions should therefore focus mainly on the [`content/`](content/) directory, where all articles are stored.

The website currently supports **English** and **French**. All content contributions must be provided in every currently supported language.

This rule applies to both new articles and modifications to existing ones:

- If you propose a new article in English, you must also provide its French version.
- If you modify an existing article in one language, you must apply the equivalent changes to all other language versions.
- If you correct a mistake, update information, improve a paragraph, or make any other editorial change, the same modification must be reflected in every language.

In short, **one content change in one language means the corresponding change must be made in every other supported language.**

Additional languages may be introduced in the future. If that happens, the contribution requirements will be updated accordingly. Until then, contributions are only required in the languages currently supported by the project.

## Content quality

All submitted articles and editorial changes will be carefully reviewed before being accepted.

Contributions must meet the following requirements:

- Content must be clear, understandable, accurate, and well structured.
- Articles must be properly written and adapted to their target language.
- Spelling, grammar, punctuation, and formatting must be correct.
- Information must be relevant to the subject and properly explained.
- Translations must preserve the meaning and quality of the original content.

Content that is unclear, confusing, poorly written, inaccurate, or unnecessarily verbose will not be accepted.

AI-generated content submitted without proper human review, editing, and verification will also be rejected. Articles that appear generic, artificial, repetitive, or written solely to generate content rather than provide useful information will not be accepted.

The goal is to maintain a consistent level of quality across the entire website. Every contribution must bring genuine value to readers.

## Technical contributions

Although content contributions are the main focus, technical improvements and bug fixes are also welcome.

Please keep technical changes focused and avoid modifying unrelated parts of the project.

If a proposed change affects the website's structure, theme, configuration, deployment, or other core components, please make sure you understand the existing implementation before submitting it.

## Commit messages

Use clear and descriptive commit messages to keep the project history easy to follow.

This project uses a lightweight commit message convention inspired by [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/), with types and scopes adapted to the structure of the blog.

### Format

```text
<type>(<scope>): <description>
```

- **Type** indicates the kind of change.
- **Scope** identifies the part of the project affected (optional when not relevant).
- **Description** briefly summarizes what the commit does.

### Commit types

| Type       | Description                                   |
| ---------- | --------------------------------------------- |
| `content`  | New or updated articles and editorial content |
| `feat`     | New features or functionality                 |
| `fix`      | Bug fixes and corrections                     |
| `design`   | Visual appearance and styling                 |
| `seo`      | Search engine optimization                    |
| `media`    | Images, videos, and other media resources     |
| `config`   | Configuration changes                         |
| `refactor` | Code restructuring and improvements           |
| `docs`     | Documentation changes                         |

### Available scopes

| Scope        | Description                    |
| ------------ | ------------------------------ |
| `article`    | Articles and editorial content |
| `homepage`   | Homepage                       |
| `navigation` | Navigation and menus           |
| `category`   | Categories                     |
| `tags`       | Tags                           |
| `layout`     | Page layouts and templates     |
| `theme`      | Theme and visual styling       |

### Examples

```text
content(article): add a guide about Hugo modules.
content(article): update an existing article.
fix(navigation): correct an incorrect menu link.
design(homepage): improve article card spacing.
seo(article): improve article metadata.
docs: update contribution guidelines.
```

Keep descriptions short, specific, and written in English. Focus on what the commit changes rather than explaining how or why.

As a personal habit, I add a period (`.`) at the end of my commit messages to indicate that I have reviewed them before pushing. You're welcome to do the same, but it's entirely optional.

## Continuous integration

All submitted changes are automatically checked through the project's CI pipeline before they can be merged.

The pipeline includes the following checks:

- **Formatting:** [dprint](https://dprint.dev/) is used to check whether files follow the project's formatting rules. Passing this check is recommended but not mandatory. If you are able to run and fix the formatting checks, please do so before submitting your pull request. Otherwise, I will take care of any necessary formatting corrections myself. No additional setup instructions are provided for this check.
- **Links:** [Lychee](https://github.com/lycheeverse/lychee) is used to check links and identify broken or inaccessible URLs. All links must be valid and accessible before submitting a pull request. Contributors are responsible for checking their links.

Passing the automated checks does not guarantee that a contribution will be accepted. All submissions are also subject to manual review.

## Pull requests

Before opening a pull request, please make sure that:

- Your changes are focused and relevant to the project.
- All content changes are reflected in every currently supported language.
- Articles and modifications meet the content quality requirements.
- Formatting checks have been run if possible.
- All links are valid and accessible.
- Commit messages follow the recommended convention.

Please provide a clear description of your changes and explain their purpose.

Pull requests containing incomplete translations, low-quality content, unclear modifications, or changes that do not follow these guidelines will be rejected.

## Final notes

Every contribution is reviewed with care. Maintaining the quality, consistency, and reliability of this blog is more important than accepting a large number of contributions.

Thank you for taking the time to help improve this project.
