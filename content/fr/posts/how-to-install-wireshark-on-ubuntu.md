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

[Wireshark](https://www.wireshark.org/) est l'outil de capture et d'analyse réseau le plus utilisé. Il est devenu un incontournable dans les domaines de l'administration système, de la cybersécurité, du diagnostic réseau et de l'enseignement, notamment grâce à plusieurs qualités essentielles:

- **Simple à prendre en main:** son interface est intuitive et permet de réaliser rapidement ses premières captures.

- **Gratuit et open source:** le projet est entièrement libre: son code source est disponible sur GitLab ([https://gitlab.com/wireshark/wireshark](https://gitlab.com/wireshark/wireshark)) et en miroir sur GitHub ([https://github.com/wireshark/wireshark](https://github.com/wireshark/wireshark)). Cette transparence facilite les audits de sécurité et contribue à l'amélioration continue du logiciel.

- **Extrêmement complet et optimisé:** Wireshark prend en charge des centaines de protocoles réseau, du plus courant au plus spécialisé. Il permet une analyse fine, jusqu'au niveau hexadécimal ou binaire, et propose de nombreuses fonctionnalités avancées: filtres puissants, statistiques détaillées, reconstruction de flux, détection d'anomalies, etc. Il répond ainsi aux besoins de tous les profils, du débutant au professionnel.

Ce guide explique comment installer Wireshark proprement, à jour et de manière sécurisée sur Ubuntu, en permettant la capture **sans `sudo`** grâce au groupe `wireshark` et aux *capabilities* du binaire `dumpcap`.

> Il a été rédigé après une installation sur un système Ubuntu (24.04.4 LTS), l'une des distributions Linux les plus utilisées, mais les principes restent similaires sur la majorité des distributions basées sur Debian.

# Description de la procédure d'installation: 

Évitez le copier-coller systématique des commandes: comprendre leur rôle vous aidera à diagnostiquer plus facilement un éventuel problème.

## 1. Ajouter le PPA Wireshark (version stable et récente):

Pour notre installation, nous allons utiliser le PPA maintenu par l'équipe de développement de Wireshark.

PPA permet d'obtenir les versions stables les plus récentes, souvent bien plus à jour que celles disponibles dans les dépôts Ubuntu, dont le cycle de publication est plus lent.

Pour l'ajouter à votre système, exécutez les commandes suivantes (elles nécessitent des privilèges administrateur):
```bash
sudo add-apt-repository ppa:wireshark-dev/stable
sudo apt update
```

> Je ne vais pas m'étendre davantage sur ce qu'est un PPA dans ce guide. J'en parlerai peut‑être de façon plus détaillée dans un article dédié. Pour l'instant, il suffit simplement de retenir qu'un PPA est un dépôt logiciel supplémentaire permettant d'obtenir des versions plus récentes que celles fournies par Ubuntu.

## 2. Installer Wireshark:

L'installation de Wireshark se fait simplement via `apt`:
```bash
sudo apt install wireshark
```

Pendant l'installation, Ubuntu affiche une question importante:

- *Allow non-superusers to capture packets?*

> (ce qui signifie: *"Autoriser les utilisateurs non administrateurs à capturer des paquets réseau?"*)

Il est recommandé de répondre: `Yes`

> Si vous répondez `No`, il sera toujours possible de modifier ce choix ultérieurement en reconfigurant le paquet `wireshark-common`.

Cette option active une configuration sécurisée et moderne: seul `dumpcap` reçoit les capacités Linux nécessaires (`CAP_NET_RAW` et `CAP_NET_ADMIN`), tandis que l'interface graphique fonctionne sans privilège particulier.

## 3. S'ajouter au groupe sécurisé `wireshark`:

Pour pouvoir capturer des paquets **sans utiliser `sudo`**, il est nécessaire d'ajouter votre utilisateur (`$USER`) au groupe système `wireshark`.

Ce groupe est spécialement conçu pour accorder les permissions de capture de manière sécurisée.

Sous Linux, un *groupe* est un ensemble d'utilisateurs auxquels sont attribuées des permissions spécifiques: le groupe `wireshark` permet d'autoriser la capture réseau sans accorder de droits administrateur complets.

Pour effectuer cette opération, exécutez la commande suivante:
```bash
sudo usermod -aG wireshark $USER
```

Une fois cette commande exécutée, les changements ne seront appliqués qu'après une déconnexion puis reconnexion de votre session utilisateur. Cette étape est indispensable pour que l'ajout au groupe soit correctement pris en compte.

## 4. Vérifier que les permissions sont correctes:

Après avoir ajouté votre utilisateur au groupe `wireshark`, il est important de vérifier que la configuration appliquée correspond bien à ce qui est attendu.

Nous allons donc contrôler les *capabilities* du moteur de capture `dumpcap`, le seul composant de Wireshark autorisé à accéder directement aux interfaces réseau.

Pour cela, exécutez la commande suivante:
```bash
getcap /usr/bin/dumpcap
```

La sortie doit faire apparaître les *capabilities* `cap_net_raw` et `cap_net_admin` associées à `dumpcap`, ce résultat indique que seul `dumpcap` possède les permissions réseau nécessaires, et non Wireshark lui‑même.

C'est exactement la configuration recherchée: elle garantit une utilisation sécurisée du logiciel tout en permettant la capture **sans `sudo`**.

Si cette commande ne renvoie aucun résultat, cela signifie que les *capabilities* n'ont pas été attribuées à `dumpcap`. Il est alors nécessaire de reconfigurer le paquet `wireshark-common`.

> Vous pouvez également vérifier que vous appartenez bien au groupe `wireshark` en exécutant: `groups | grep "wireshark"`. Si le terminal affiche `wireshark` (souvent en couleur selon votre thème), cela signifie que l'ajout au groupe a été effectué correctement.

## 5. Lancer Wireshark sans `sudo`:

Nous arrivons au terme du guide: vous pouvez désormais lancer Wireshark directement depuis votre terminal sans privilèges administrateur:
```bash
wireshark
```

Si l'application démarre correctement et que vous pouvez capturer des paquets, votre installation est fonctionnelle. Wireshark utilise alors le mécanisme prévu par Linux: seul le moteur de capture `dumpcap` dispose des permissions réseau nécessaires, tandis que l'interface graphique fonctionne avec les droits de votre utilisateur.

Avant de considérer l'installation comme terminée, vous pouvez effectuer quelques vérifications supplémentaires.

Pour afficher la version actuellement installée de Wireshark, exécutez:
```bash
wireshark --version
```

Cette commande affiche la version actuellement installée de Wireshark.

Vous pouvez également vérifier que `dumpcap` est capable d'accéder aux interfaces réseau disponibles:
```bash
dumpcap -D
```

Cette commande liste les interfaces de capture détectées par `dumpcap`, si elles apparaissent correctement, cela confirme que le moteur de capture dispose des permissions nécessaires pour y accéder.

Vous pouvez ensuite épingler Wireshark dans le *Dock* d'Ubuntu ou le lancer directement depuis la barre de recherche des applications.

Dans le cas contraire, il est possible qu'une étape de configuration ait été mal appliquée. Vous pouvez alors vérifier les éléments suivants:

* votre appartenance au groupe `wireshark`;
* les *capabilities* attribuées à `dumpcap`;
* la présence et la configuration du PPA Wireshark;
* l'installation correcte des paquets nécessaires.

## (Bonus) 6. Corriger l'icône de Wireshark dans le *Dock*:

Sur certaines installations d'Ubuntu, l'icône de Wireshark peut apparaître comme une icône générique lorsqu'elle est épinglée dans le *Dock*.

Ce comportement survient lorsque GNOME ne parvient pas à associer correctement la fenêtre de Wireshark à son fichier `.desktop`. L'ajout de la propriété `StartupWMClass` permet de rétablir cette correspondance et d'afficher l'icône correcte dans le *Dock*.

Pour appliquer cette correction proprement, nous allons créer une copie locale du fichier de lancement de Wireshark. Cette méthode est préférable à la modification directe du fichier système, car elle évite que les changements soient écrasés lors d'une mise à jour de Wireshark.

Commencez par créer le dossier local destiné aux lanceurs d'applications personnalisés de votre utilisateur:
```bash
mkdir -p ~/.local/share/applications
```

Copiez ensuite le fichier `.desktop` officiel de Wireshark dans ce dossier:
```bash
cp /usr/share/applications/org.wireshark.Wireshark.desktop ~/.local/share/applications/
```

Ouvrez maintenant la copie locale du fichier avec l'éditeur de texte GNOME:
```bash
gnome-text-editor ~/.local/share/applications/org.wireshark.Wireshark.desktop
```

Ajoutez la ligne suivante à la fin du fichier:
```ini
StartupWMClass=Wireshark
```

Enregistrez le fichier, puis fermez complètement Wireshark s'il est ouvert.

Si l'icône incorrecte est déjà présente dans le *Dock*, retirez-la puis épinglez de nouveau Wireshark afin que GNOME recharge le nouveau fichier de lancement.

L'icône devrait désormais apparaître correctement.

> En toute honnêteté, je n'ai pas rencontré ce problème avec la version d'Ubuntu mentionnée au début de l'article. Cette correction est donc proposée comme solution de contournement pour les systèmes où GNOME ne réalise pas correctement l'association entre la fenêtre et le lanceur `.desktop`.

# Conclusion

En suivant ce guide, vous disposez désormais d'une installation de Wireshark propre, sécurisée et conforme aux bonnes pratiques Linux. L'utilisation du groupe `wireshark` et des *capabilities* attribuées à `dumpcap` permet de capturer des paquets **sans recourir à `sudo`**, tout en maintenant un niveau de sécurité élevé.

# Sources:

- [https://www.wireshark.org/docs/wsug_html_chunked/](https://www.wireshark.org/docs/wsug_html_chunked/)

- [https://launchpad.net/~wireshark-dev/+archive/ubuntu/stable](https://launchpad.net/~wireshark-dev/+archive/ubuntu/stable)

- [https://askubuntu.com/questions/700712/how-to-install-wireshark](https://askubuntu.com/questions/700712/how-to-install-wireshark)

- [https://www.youtube.com/watch?v=vd9dsMtWJmI](https://www.youtube.com/watch?v=vd9dsMtWJmI)
