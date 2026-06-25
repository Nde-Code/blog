# Nathan Debilloëz - blog:

Ce dépôt contient le code de mon site statique dédié à mes articles et didacticiels, construit avec Hugo et le thème `go.ngs.io/hugo-primer-blog` via les modules Hugo.

Le site est en français et en anglais (je vais essayer de publier les articles dans les deux langues, et si besoin, dans d'autres langues par la suite) et utilise une structure de contenu simple pour les articles, avec des métadonnées YAML standard et des modèles Hugo pour générer les pages.

> Le but de ce dépôt est de rédiger mes didacticiels/articles sans me prendre la tête à devoir tout coder en HTML, CSS et JS comme je le fais déjà avec mon site principal : [https://nde-code.github.io/](https://nde-code.github.io/). Je rédige en Markdown (un format que j'apprécie beaucoup, d'ailleurs) et le tout est compilé et publié en quelques secondes. 

## ⚡ Installation rapide:

### Prérequis:

Avant de lancer le projet, assurez-vous d'avoir installé :

- **Go** ([https://go.dev/](https://go.dev/)) : le langage de programmation nécessaire au fonctionnement de Hugo (version compatible avec ce dernier et les modules).
- **Hugo Extended** ([https://gohugo.io/getting-started/quick-start/](https://gohugo.io/getting-started/quick-start/)) : qui inclut des fonctionnalités supplémentaires par rapport à la version standard.
- **Node.js** ([https://nodejs.org/en](https://nodejs.org/en)) : pour les outils front-end éventuels.

### Installation via GitHub Codespaces ou Devcontainer:

Le dépôt dispose d'un environnement de développement préconfiguré pour GitHub Codespaces. À l'ouverture :

1. Le conteneur s'initialise automatiquement.
2. Le thème Hugo est téléchargé ou mis à jour via la commande `hugo mod get -u`.
3. Vous pouvez lancer le serveur local depuis le conteneur avec `hugo server`.

### Installation locale (depuis votre machine):

1. Ouvrez un terminal à la racine du projet.
2. Vérifiez votre environnement en exécutant : `bash env.sh`
3. Si le script indique que tout est correct, vous pouvez passer à la suite. Autrement, installez les outils manquants via les liens fournis dans les prérequis.
4. Téléchargez ou mettez à jour les modules Hugo : `hugo mod get -u`
5. Démarrez le serveur de développement local : `hugo server`

### Déploiement en ligne:

Le projet intègre un *workflow* [GitHub Actions](https://docs.github.com/fr/actions) qui déploie automatiquement le site sur GitHub Pages à chaque nouvelle modification poussée (*push*) sur la branche `main`, le tout sans configuration préalable. 

Le fichier de configuration est consultable ici: [.github/workflows/hugo.yaml](.github/workflows/hugo.yaml). Sa structure n'étant pas triviale, il est fortement recommandé de bien en comprendre le fonctionnement avant d'y apporter la moindre modification.

## 🏗️ Création de contenu:

Les articles sont stockés dans le dossier `content/` et s'appuient sur un *archetype* (voir la [documentation Hugo](https://gohugo.io/content-management/archetypes/#article)) prédéfini pour faciliter la configuration initiale.

- Chaque nouveau contenu doit inclure des métadonnées YAML dans son en-tête (*front matter*).
- L'*archetype* par défaut se trouve dans [`archetypes/default.md`](archetypes/default.md).
- Il génère automatiquement :
   - Le titre (basé sur le nom du fichier).
   - La date du jour.
   - L'auteur.
   - Le statut de brouillon (`draft: true`).

### Comment créer un nouvel article:

Vous pouvez procéder de deux manières différentes :

#### Méthode 1, automatiquement avec la commande Hugo:

Exécutez la commande suivante dans votre terminal :

```bash
hugo new <langue>/posts/mon-super-article.md
```

*Exemple pour un article en anglais:* `hugo new en/posts/my-english-article.md`

Tout est généré automatiquement, il ne vous reste plus qu'à compléter le front matter YAML et à rédiger le texte.

#### Méthode 2, manuellement:

1. Créez un nouveau fichier Markdown dans `content/en/posts/` ou `content/fr/posts/`.
2. Ajoutez un en-tête YAML structuré comme ceci :
```yaml
---
title: "{{ replace .File.ContentBaseName "-" " " | title }}"
date: {{ .Date }}
draft: true
tags: []
categories: []
author: "Nathan Debilloëz"
description: ""
---
```
3. Rédigez votre contenu en Markdown juste en dessous de cet en-tête.
4. Passez la valeur à `draft: false` lorsque l'article est prêt à être publié.

## 📁 Structure du projet:

Les dossiers et les fichiers du projet sont organisés comme suit:

```text
├── .github/
│   ├── workflows/
│   │   └── hugo.yaml      # Workflow GitHub Actions pour compiler et publier le blog
│   └── dependabot.yaml    # Configuration pour les mises à jour auto des dépendances
├── archetypes/
│   └── default.md         # Modèle pour la création automatique des nouveaux articles
├── content/
│   ├── en/posts/          # Articles du blog en Anglais
│   └── fr/posts/          # Articles du blog en Français (langue principale)
├── i18n/
│   ├── en.toml            # Traductions des chaînes de caractères en Anglais
│   └── fr.toml            # Traductions des chaînes de caractères en Français
├── layouts/               # Surcharges ou gabarits HTML personnalisés pour le thème
├── static/                # Fichiers statiques (images, favicons, robots.txt, etc.)
├── .devcontainer.json     # Configuration de l'environnement GitHub Codespaces
├── .gitignore             # Fichiers et dossiers ignorés par Git (public/, node_modules/)
├── LICENSE                # Licence de distribution du projet
├── README.md              # Documentation du projet
├── env.sh                 # Script local de vérification de l'environnement de dev
├── go.mod                 # Déclaration du module Go et version du thème (v1.0.9)
├── go.sum                 # Empreintes de sécurité des modules Go
└── hugo.toml              # Fichier de configuration principal du site Hugo
```

## ⚖️ Licence:

Ce projet est distribué sous la licence **[GNU General Public License v3.0](https://github.com/Nde-Code/blog?tab=GPL-3.0-1-ov-file)**.

## 🎯 À propos:

Ce projet est réalisé et maintenu par [Nde-Code](https://nde-code.github.io/).

> N'hésitez pas à m'aider en corrigeant les éventuelles fautes d'orthographe, imprécisions, ... en ouvrant une *issue* ou une *pull request*.
