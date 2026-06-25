---
title: "Réinitialiser l'historique Git d'un projet."
date: 2026-06-25
draft: false
tags: ["Git", "GitHub", "DevOps"]
categories: ["Générale"]
author: "Nathan Debilloëz"
description: "Cela peut paraître évident, mais c'est une manipulation que l'on doit parfois effectuer (bien plus souvent qu'on ne le pense). Face au peu d'articles traitant de ce sujet, j'ai décidé d'en rédiger un."
---

# Réinitialiser l'historique Git d'un projet:

Ce guide explique comment supprimer complètement l'historique des commits, réinitialiser le dépôt localement et forcer la mise à jour sur GitHub (ou tout autre service distant).

Cela peut paraître incongru comme didacticiel, mais c'est bien plus fréquent qu'on ne l'imagine, par exemple:

* **Si vous exposez des secrets:** Dans votre code source, il est plus que nécessaire de faire un nettoyage en profondeur, même si les clés ont été révoquées.
* **Pour une question de propreté:** Parfois, lorsque l'on travaille sur les bases d'un projet, on apprécie d'effacer les premiers balbutiements pour garder un dépôt propre.
* **Pour repartir à zéro après une longue période:** Après de gros changements faisant suite à une longue période d'inactivité, on peut avoir envie de réinitialiser l'historique sur ces nouvelles bases pour ne pas se perdre.

> **⚠️ Attention :** cette opération est irréversible. Elle écrasera définitivement l'historique de la branche principale sur le dépôt distant. Si d'autres personnes collaborent sur ce projet, elles devront obligatoirement supprimer leur version locale et recloner le dépôt pour éviter des conflits majeurs.

> **Préalable :** effectuez une sauvegarde (backup) du dépôt dont vous souhaitez supprimer l'historique des commits.

## 1. Nettoyage local:

Ouvrir un terminal à la racine du projet et exécuter les commandes suivantes:

### Supprimer l'ancien historique:

* **Windows (PowerShell) :**
```powershell
Remove-Item -Recurse -Force .git
```

* **Mac / Linux :**
```bash
rm -rf .git
```

### Réinitialiser le dépôt:

```bash
# Initialiser un nouveau dépôt vide.
git init

# Ajouter tous les fichiers actuels.
git add .

# Créer le nouveau premier commit.
git commit -m "chore: reset repository history and initialize fresh project state."  
```

## 2. Configurer la branche principale:

On s'assure que la branche par défaut est bien nommée `main`:
```bash
git branch -M main
```

## 3. Lier au dépôt distant et forcer le *push*:

> Remplacer l'URL ci-dessous par celle du dit dépôt GitHub.

```bash
# Ajouter l'adresse de votre dépôt distant
git remote add origin https://github.com/<NOM>/<NOM_PROJET>.git

# Écraser l'historique distant avec le nouveau commit local
git push -u origin main --force
```

> **Note:** si le but est vraiment de nettoyer **toutes** les branches et tags distants en même temps que le push, vous pouvez ajouter cette commande juste avant ou après votre push: git `push origin --delete <nom_de_la_branche>`

## 4. Conclusion:

Après cette opération, le dépôt sera complètement nettoyé (c'est un véritable *factory reset*), propre comme au premier jour.