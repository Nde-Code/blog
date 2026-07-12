---
title: "Réinitialiser complètement l'historique Git d'un projet"
date: 2026-06-25
draft: false
tags: ["Git", "GitHub", "DevOps"]
categories: ["Git"]
author: "Nathan Debilloëz"
description: "Cela peut surprendre, mais c'est une opération qu'il faut parfois réaliser, souvent plus qu'on ne le pense. Face au manque de contenu sur ce sujet, j'ai pris l'initiative de rédiger un court tutoriel."
---

# Introduction:

Ce guide explique comment réinitialiser complètement l'historique Git d'un projet en supprimant puis recréant l'historique Git local, avant d'écraser l'historique du dépôt distant.

Cette manipulation peut sembler inhabituelle, mais elle est bien plus fréquente qu'on ne l'imagine, par exemple:

* **Si vous exposez des secrets:** commencez toujours par les révoquer (clés API, jetons, mots de passe, etc.). La réinitialisation de l'historique permet ensuite de nettoyer le dépôt, mais elle ne garantit pas que les données aient disparu de tous les clones, *forks* ou caches existants.
* **Pour une question de propreté:** après la phase d'initialisation d'un projet, il peut être utile de repartir sur un historique propre en supprimant les premiers *commits* liés à la phase de développement initiale.
* **Pour repartir à zéro après une longue période:** après des changements importants, on peut souhaiter réinitialiser l'historique afin de repartir sur des bases claires et éviter toute confusion.

**⚠️ Attention:** cette opération est irréversible. Elle écrasera définitivement l'historique de la branche distante `main`. Si d'autres personnes collaborent sur ce projet, il est fortement recommandé qu'elles suppriment leur version locale et reclonent le dépôt afin d'éviter des conflits majeurs.

**Prérequis:** effectuez une sauvegarde du dépôt dont vous souhaitez réinitialiser l'historique des *commits*.

> **Note:** cet article part du principe que votre branche principale est `main` et que c'est sur celle-ci que l'on va effectuer le nettoyage. Bien que ce soit le standard actuel sur des plateformes comme GitHub ou GitLab, pensez à vérifier votre dépôt. Si votre branche par défaut porte un autre nom, il vous suffira d'adapter les commandes en conséquence. Je vous indiquerai les étapes où cette vigilance est nécessaire.

# Description de la procédure:

Assurez-vous de bien comprendre la manipulation ainsi que les implications de ce qui va être fait.

## 1. Nettoyage local:

Commencez par cloner le dépôt contenant la branche `main` à réinitialiser.

> Le clonage permet de récupérer l'état actuel des fichiers du projet avant de supprimer l'ancien historique Git.

Ensuite, ouvrez un terminal à la racine du projet, puis suivez les étapes ci-dessous et exécutez les commandes associées: 

### Étape 1, supprimer le dossier `.git`:

* **Windows (via PowerShell):**
```powershell
Remove-Item -Recurse -Force .git
```

* **Mac / Linux :**
```bash
rm -rf .git
```

Cela supprime le répertoire `.git`, qui contient l'ensemble des métadonnées Git du dépôt: historique des *commits*, branches locales, tags et configuration associée.

### Étape 2, initialiser un nouveau dépôt Git:

Une fois l'ancien historique supprimé, vous devez initialiser un nouveau dépôt Git propre.

Exécutez la commande suivante dans votre terminal:
```bash
git init
```

Ajoutez ensuite tous les fichiers du projet à l'index:
```bash
git add .
```

Enfin, créez le premier *commit* de ce nouveau dépôt:
```bash
git commit -m "chore: reset repository history and initialize fresh project state"
```

## 2. Configurer la branche principale:

Renommez la branche courante du dépôt en `main`:
```bash
git branch -M main
```

**Note:** cette commande renomme la branche courante en `main`. Si votre dépôt utilise un autre nom pour sa branche principale, adaptez la commande en conséquence.

## 3. Lier le dépôt distant et forcer l'envoi du nouvel historique:

Ajoutez le dépôt distant:
> Remplacez l'URL ci-dessous par celle de votre dépôt GitHub.
```bash
git remote add origin https://github.com/<NOM>/<NOM_PROJET>.git
```

Forcez ensuite l'envoi du nouvel historique vers le dépôt distant:
```bash
git push -u origin main --force
```

> ⚠️ Cette commande remplace définitivement l'historique du dépôt distant. Assurez-vous que tous les collaborateurs sont informés avant de l'exécuter.

**Attention:** ici aussi, l'envoi est effectué vers `main`, c'est-à-dire la branche réinitialisée précédemment. Vérifiez impérativement que le nom de branche correspond bien à votre configuration.

**Note:** si vous souhaitez également supprimer les autres branches distantes, exécutez la commande suivante pour chacune d'elles: `git push origin --delete <nom_de_la_branche>`

# Conclusion:

Une fois ces étapes terminées, le dépôt distant ne contiendra plus qu'un unique *commit* correspondant au nouvel état initial du projet. L'ancien historique ne sera plus accessible depuis la branche principale du dépôt distant.