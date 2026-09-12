---
title: "Installation sécurisée de Wireshark sur Ubuntu"
date: 2026-07-11
draft: false
tags: ["Wireshark", "Ubuntu", "Linux"]
categories: ["Linux", "Wireshark", "Réseau"]
author: "Nathan Debilloëz"
description: "Guide complet, sécurisé et reproductible pour installer Wireshark sur Ubuntu sans sudo."
---

# Introduction:

[Wireshark](https://www.wireshark.org/) est aujourd'hui l'un des principaux outils de capture et d'analyse du trafic réseau. Grâce à sa richesse fonctionnelle et à sa polyvalence, il s'est imposé comme une référence dans de nombreux domaines, notamment l'administration système, la cybersécurité, le diagnostic réseau et l'enseignement. Cette popularité repose notamment sur plusieurs qualités essentielles:

- **Simple à prendre en main:** son interface est intuitive et permet de réaliser rapidement ses premières captures.

- **Gratuit et *open source*:** le projet est entièrement libre: son code source est disponible sur [GitLab](https://gitlab.com/wireshark/wireshark) et en miroir sur [GitHub](https://github.com/wireshark/wireshark). Cette transparence facilite les audits de sécurité et contribue à l'amélioration continue du logiciel.

- **Extrêmement complet et optimisé:** Wireshark prend en charge des centaines de protocoles réseau, du plus courant au plus spécialisé. Il permet une analyse fine, jusqu'au niveau hexadécimal ou binaire, et propose de nombreuses fonctionnalités avancées: filtres puissants, statistiques détaillées, reconstruction de flux, détection d'anomalies, etc. Il répond ainsi aux besoins de tous les profils, du débutant au professionnel.

Ce guide explique comment installer Wireshark proprement, à jour et de manière sécurisée sur Ubuntu, en permettant la capture **sans `sudo`** grâce au groupe `wireshark` et aux *capabilities* du binaire `dumpcap`.

> Il a été rédigé après une installation sur un système Ubuntu (24.04.4 LTS), l'une des distributions Linux les plus utilisées, mais les principes restent similaires sur la majorité des distributions basées sur Debian.

# Description de la procédure d'installation:

Évitez le copier-coller systématique des commandes: comprendre leur rôle vous aidera à diagnostiquer plus facilement un éventuel problème.

Pour ce guide, je pars également du principe que votre système est à jour, autrement dit, que la commande `sudo apt update && sudo apt upgrade -y` a déjà été exécutée et que vous êtes suffisamment à l'aise avec Linux et l'utilisation du terminal.

## 1. Ajouter le *PPA* Wireshark:

Pour notre installation, nous allons utiliser le *PPA* maintenu par l'équipe de développement de Wireshark.

Ce *PPA* permet d'obtenir des versions stables plus récentes, souvent plus à jour que celles disponibles dans les dépôts Ubuntu.

Pour l'ajouter à votre système, exécutez les commandes suivantes une par une. Elles nécessitent des privilèges administrateur:

```bash
sudo add-apt-repository ppa:wireshark-dev/stable
sudo apt update
```

Je ne vais pas m'attarder davantage sur le fonctionnement d'un *PPA* dans ce guide. J'y reviendrai peut-être plus en détail dans un article dédié. Pour l'instant, retenez simplement qu'un *PPA* est un dépôt logiciel supplémentaire permettant notamment d'installer des versions plus récentes de certains logiciels que celles disponibles dans les dépôts officiels d'Ubuntu.

## 2. Installer Wireshark:

L'installation de Wireshark se fait simplement via `apt`:

```bash
sudo apt install wireshark
```

Pendant l'installation, Ubuntu affiche une question importante:

- Allow non-superusers to capture packets?

ce qui signifie: "Autoriser les utilisateurs non administrateurs à capturer des paquets réseau?"

Il est recommandé de répondre: `Yes`

> Si vous répondez `No`, il sera toujours possible de modifier ce choix ultérieurement en reconfigurant le paquet `wireshark-common`.

Cette option active une configuration sécurisée et moderne: seul `dumpcap` reçoit les *capabilities* Linux nécessaires (`CAP_NET_RAW` et `CAP_NET_ADMIN`), tandis que l'interface graphique fonctionne sans privilège particulier.

## 3. S'ajouter au groupe sécurisé `wireshark`:

Pour pouvoir capturer des paquets **sans utiliser `sudo`**, il est nécessaire d'ajouter votre utilisateur (`$USER`) au groupe système `wireshark`. Ce groupe est spécifiquement prévu pour accorder les permissions nécessaires à la capture de paquets, sans donner à Wireshark des privilèges administrateur.

Sous Linux, un *groupe* est un ensemble d'utilisateurs auxquels sont attribuées des permissions spécifiques: le groupe `wireshark` permet d'autoriser la capture réseau sans accorder de droits administrateur complets.

Pour effectuer cette opération, exécutez la commande suivante:

```bash
sudo usermod -aG wireshark $USER
```

Une fois cette commande exécutée, les changements ne seront pris en compte qu'après une déconnexion puis une reconnexion de votre session utilisateur. Cette étape est indispensable pour que l'ajout au groupe soit correctement pris en compte.

## 4. Vérifier que les permissions sont correctes:

Après avoir ajouté votre utilisateur au groupe `wireshark`, il est important de vérifier que la configuration appliquée correspond bien à ce qui est attendu.

Nous allons donc contrôler les *capabilities* du moteur de capture `dumpcap`, le composant de Wireshark chargé de la capture réseau et auquel sont attribués les privilèges nécessaires.

Pour cela, exécutez la commande suivante:

```bash
getcap /usr/bin/dumpcap
```

Cette commande affiche les *capabilities* actuellement attribuées à `dumpcap`. Vous devriez notamment y retrouver les permissions réseau nécessaires à la capture des paquets.

Grâce à cette configuration, Wireshark peut effectuer des captures depuis son interface graphique sans nécessiter de privilèges administrateur.

Si cette commande ne renvoie aucun résultat, cela signifie que les *capabilities* n'ont pas été attribuées à `dumpcap`. Il est alors nécessaire de reconfigurer le paquet `wireshark-common`.

> Vous pouvez également vérifier que vous appartenez bien au groupe `wireshark` en exécutant: `groups | grep "wireshark"`. Si le terminal affiche `wireshark` (souvent en couleur selon votre thème), cela signifie que l'ajout au groupe a été effectué correctement.

## 5. Lancer Wireshark sans `sudo`:

Nous arrivons au terme du guide: vous pouvez désormais lancer Wireshark directement depuis votre terminal sans privilèges administrateur:

```bash
wireshark
```

Si l'application démarre correctement et que vous pouvez capturer des paquets, votre installation est fonctionnelle. Wireshark utilise alors le mécanisme prévu: seul le moteur de capture `dumpcap` dispose des permissions réseau nécessaires, tandis que l'interface graphique fonctionne avec les droits de votre utilisateur.

Pour afficher la version actuellement installée de Wireshark, exécutez:

```bash
wireshark --version
```

Vous pouvez également vérifier que `dumpcap` est capable d'accéder aux interfaces réseau disponibles:

```bash
dumpcap -D
```

Cette commande liste les interfaces de capture détectées par `dumpcap`. Si elles apparaissent correctement, cela confirme que le moteur de capture dispose des permissions nécessaires pour y accéder. Vous pouvez alors épingler Wireshark dans le *Dock* d'Ubuntu ou le lancer directement depuis la barre de recherche des applications.

Dans le cas contraire, il est possible qu'une étape de la configuration n'ait pas été correctement appliquée. Dans ce cas, vérifier les points suivants:

- votre appartenance au groupe `wireshark`;
- les *capabilities* attribuées à `dumpcap`;
- la présence et la configuration du *PPA* Wireshark;
- l'installation correcte des paquets nécessaires.

# Conclusion:

Vous disposez désormais d'une installation de Wireshark propre, sécurisée et conforme aux bonnes pratiques Linux. L'utilisation du groupe `wireshark` et des *capabilities* attribuées à `dumpcap` permet de capturer des paquets **sans recourir à `sudo`**, tout en maintenant un niveau de sécurité élevé.

# Sources:

- [https://www.wireshark.org/docs/wsug_html_chunked/](https://www.wireshark.org/docs/wsug_html_chunked/)

- [https://launchpad.net/~wireshark-dev/+archive/ubuntu/stable](https://launchpad.net/~wireshark-dev/+archive/ubuntu/stable)

- [https://askubuntu.com/questions/700712/how-to-install-wireshark](https://askubuntu.com/questions/700712/how-to-install-wireshark)

- [https://www.youtube.com/watch?v=vd9dsMtWJmI](https://www.youtube.com/watch?v=vd9dsMtWJmI)
