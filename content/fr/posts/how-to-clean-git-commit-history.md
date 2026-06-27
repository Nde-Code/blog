---
title: "Réinitialiser l'historique Git de la branche principale (main) d'un projet."
date: 2026-06-25
draft: false
tags: ["Git", "GitHub", "DevOps"]
categories: ["Git"]
author: "Nathan Debilloëz"
description: "Cela peut surprendre, mais c'est une intervention qu'il faut parfois réaliser, souvent plus que ce que l'on suppose. Face au manque de contenu sur ce sujet, j'ai pris l'initiative d'en écrire un."
---

# Introduction:

Ce guide explique comment supprimer complètement l'historique des commits de la branche principale (`main`), réinitialiser le dépôt local en recréant un historique propre pour la branche `main` et forcer la mise à jour sur le dépôt distant.

Cela peut paraître incongru comme didacticiel, mais c'est bien plus fréquent qu'on ne l'imagine, par exemple:

* **Si vous exposez des secrets:** dans votre code source, il est plus que nécessaire de faire un nettoyage en profondeur, même si les clés ont été révoquées.
* **Pour une question de propreté:** parfois, lorsque l'on travaille sur les bases d'un projet, on apprécie d'effacer les premiers balbutiements pour garder un dépôt propre.
* **Pour repartir à zéro après une longue période:** après de gros changements faisant suite à une longue période d'inactivité, on peut avoir envie de réinitialiser l'historique sur ces nouvelles bases pour ne pas se perdre.

**⚠️ Attention:** cette opération est irréversible. Elle écrasera définitivement l'historique de la branche principale sur le dépôt distant. Si d'autres personnes collaborent sur ce projet, elles devront obligatoirement supprimer leur version locale et recloner le dépôt pour éviter des conflits majeurs.

**Préalable:** effectuez une sauvegarde du dépôt dont vous souhaitez supprimer l'historique des commits.

> **Note :** cet article part du principe que la branche principale du projet est `main` et que c'est sur celle-ci que l'on va effectuer le nettoyage. Normalement, depuis quelques années (sur GitHub), la branche par défaut est `main`, mais cela peut varier. Vérifiez votre dépôt ainsi que les paramètres de votre plateforme distante (GitHub, GitLab, ...).

# 1. Nettoyage local:

Avant même de commencer, clonez le dépôt contenant la branche `main` à nettoyer.

Ensuite, ouvrez un terminal à la racine du projet, puis suivez et exécutez les commandes suivantes:

## Pour supprimer le dossier `.git`:

* **Windows (via PowerShell):**
```powershell
Remove-Item -Recurse -Force .git
```

* **Mac / Linux :**
```bash
rm -rf .git
```

Cela supprime entièrement l'historique Git local, y compris les commits, les branches locales et la configuration du dépôt.

## Pour réinitialiser le dépôt:

```bash
# Initialiser un nouveau dépôt vide.
git init

# Ajouter tous les fichiers actuels.
git add .

# Créer le nouveau premier commit.
git commit -m "chore: reset repository history and initialize fresh project state."  
```

# 2. Configurer la branche principale:

On s'assure que la branche par défaut est bien nommée `main`:
```bash
git branch -M main
```

**Note:** dans cette commande, je pars du principe que la branche principale du projet est `main`. Adaptez ce nom à votre cas si votre dépôt utilise un autre nom de branche principale.

# 3. Lier au dépôt distant et forcer le *push*:

> Remplacer l'URL ci-dessous par celle du dit dépôt GitHub.

```bash
# Ajouter l'adresse de votre dépôt distant
git remote add origin https://github.com/<NOM>/<NOM_PROJET>.git

# Écraser l'historique distant avec le nouveau commit local
git push -u origin main --force
```

**Attention:** ici aussi, on *push* sur `main`, donc sur la branche principale comme expliqué précédemment. Il est indispensable de vérifier et de renseigner le nom adéquat tel qu'il est défini dans votre configuration.

**Note:** si le but est vraiment de nettoyer **toutes** les branches et tags distants en même temps que le push, vous pouvez ajouter cette commande juste avant ou après votre push: `git push origin --delete <nom_de_la_branche>`. Cette opération doit être répétée pour chaque branche concernée.

# Conclusion:

Une fois cette opération effectuée, l'historique de la branche principale (`main`) aura été entièrement réécrit sur le dépôt distant.