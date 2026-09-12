---
title: "Recréer l'historique Git d'un projet à partir de son état actuel"
date: 2026-06-25
draft: false
tags: ["Git", "GitHub", "DevOps"]
categories: ["Git"]
author: "Nathan Debilloëz"
description: "Cela peut surprendre, mais c'est une opération qu'il faut parfois réaliser, souvent plus qu'on ne le pense. Face au manque de contenu sur ce sujet, j'ai pris l'initiative de rédiger un court tutoriel."
---

# Introduction:

Ce guide présente une méthode permettant de **repartir de l'état actuel d'un projet tout en supprimant son historique Git existant**. L'objectif est de conserver les fichiers tels qu'ils sont aujourd'hui, puis de reconstruire un nouvel historique à partir de cet état, avec un unique *commit* initial.

Bien que peu courante au quotidien, cette opération est utile dans plusieurs situations spécifiques, par exemple:

- **Si vous exposez des secrets:** commencez toujours par les révoquer (clés API, jetons, mots de passe, etc.). La réinitialisation retire ces informations de l'historique visible du dépôt, mais elle ne **garantit pas** que les données aient disparu de tous les clones, *forks* ou caches existants.
- **Pour une question de propreté:** après la phase d'initialisation d'un projet, il peut être utile de repartir sur un historique propre en supprimant les premiers *commits* liés à la phase de développement initiale.
- **Pour repartir sur des bases propres après une longue période de développement:** après des changements importants, on peut souhaiter réinitialiser l'historique afin de repartir sur des bases claires et éviter toute confusion.

La procédure consiste à créer localement un nouveau dépôt Git à partir de l'état actuel du projet, à définir `main` comme branche principale, puis à remplacer la branche `main` du dépôt distant par cette nouvelle branche.

**Prérequis:** effectuez une sauvegarde du dépôt dont vous souhaitez réinitialiser l'historique des *commits*.

**⚠️ Attention:** cette opération réécrit l'historique de la branche distante `main`. Une fois le `push` effectué, l'ancien historique ne sera plus accessible depuis cette branche. Si d'autres personnes collaborent sur ce projet, informez-les également de l'opération afin qu'elles puissent supprimer leur copie locale et recloner le dépôt une fois la réinitialisation terminée.

# Description de la procédure:

Assurez-vous de bien comprendre l'opération ainsi que les implications de ce qui va être fait.

Je vais décrire la procédure en prenant comme exemple un dépôt hébergé sur GitHub, qui est aujourd'hui et de loin l'une des plateformes d'hébergement Git les plus connues et les plus utilisées.

## 1. Supprimer le dossier `.git`:

Commencez par cloner le dépôt GitHub afin de récupérer localement l'état actuel du projet:

```bash
git clone https://github.com/<NOM>/<NOM_PROJET>.git
```

Le clonage permet de récupérer les fichiers du projet dans leur état actuel, y compris le dossier `.git`.

Ensuite, ouvrez un terminal à la **racine du projet**, puis exécutez l'une des commandes suivantes, en fonction de votre système d'exploitation, afin de supprimer l'ancien `.git`:

- **Sur Windows (via PowerShell):**

```powershell
Remove-Item -Recurse -Force .git
```

- **Sur macOS / Linux:**

```bash
rm -rf .git
```

Cela supprime le répertoire `.git`, qui contient l'ensemble des métadonnées Git du dépôt: historique des *commits*, branches locales, *tags* et configuration associée.

> Cette suppression concerne uniquement votre copie locale du dépôt. Le dépôt distant et son historique restent inchangés jusqu'à l'exécution du `push` effectué à l'étape 4.

## 2. Initialiser un nouveau `git`:

Une fois l'ancien `.git` supprimé, vous devez initialiser un nouveau `.git` propre et y ajouter l'ensemble des fichiers du projet.

Exécutez la commande suivante dans votre terminal afin d'initialiser un nouveau `.git`:

```bash
git init
```

Ajoutez ensuite tous les fichiers du projet:

```bash
git add .
```

Enfin, créez le premier *commit*:

```bash
git commit -m "chore: reset repository history and initialize fresh project state"
```

## 3. Définir la branche principale:

Renommez la branche courante du dépôt en `main`:

```bash
git branch -M main
```

> **Note:** si votre dépôt utilise un autre nom pour sa branche principale, adaptez la commande en conséquence.

## 4. Lier le dépôt distant et forcer l'envoi du nouvel historique:

Ajoutez le dépôt distant:

```bash
git remote add origin https://github.com/<NOM>/<NOM_PROJET>.git
```

Forcez ensuite l'envoi du nouvel historique vers le dépôt distant:
```bash
git push -u origin main --force
```

Cette commande remplace définitivement l'historique du dépôt distant. Assurez-vous que tous les collaborateurs sont informés avant de l'exécuter. Les *forks* existants et les clones locaux peuvent conserver une copie de l'ancien historique, même après sa réécriture sur le dépôt distant.

> **Note:** l'envoi est effectué vers `main`, c'est-à-dire la branche distante que vous souhaitez réinitialiser. Vérifiez impérativement que le nom de la branche correspond bien à votre configuration.

## 5. Bonus, supprimer les autres branches distantes:

Si vous souhaitez également supprimer les autres branches distantes, exécutez la commande suivante pour chacune d'elles:

```bash
git push origin --delete <nom_de_la_branche>
```

# Conclusion:

Une fois ces étapes terminées, la branche `main` du dépôt distant pointera vers le nouveau *commit* initial créé à partir de l'état actuel du projet. L'ancien historique ne sera plus accessible depuis cette branche.

Les autres branches distantes, si elles existent, ne sont pas affectées par cette opération. Si nécessaire, elles devront être supprimées (voir le point 5) ou réécrites séparément.
