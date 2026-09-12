---
title: "Introduction et explication sur cette nouvelle partie du site"
date: 2026-06-21
draft: false
tags: ["Hugo", "GitHub", "GitHub Pages"]
categories: ["Générale"]
author: "Nathan Debilloëz"
description: "Il y a déjà longtemps que je souhaitais ajouter une rubrique dédiée à des articles sur mon site web principal. Celui-ci n'étant pas vraiment adapté à cet usage, j'ai décidé de créer un site web distinct et indépendant, entièrement consacré à cette partie."
---

# Préambule:

Cela fait déjà longtemps que j'avais envie de créer une section « blog » sur mon site. Pas vraiment pour tenir un « blog » au sens traditionnel du terme, ni pour donner mon avis sur tout et n'importe quoi, mais plutôt pour expliquer, documenter et partager ce que j'apprends au fil de mes projets.

Pendant longtemps, chaque fois que je passais des heures à configurer, brancher ou programmer quelque chose, je finissais par rédiger un petit guide en Markdown pour ne pas avoir à tout recommencer quelques mois plus tard. Ces guides terminaient généralement dans un coin de mes Gists GitHub, où ils restaient ensuite bien sagement oubliés.

C'est dommage, parce que ces notes peuvent parfois être utiles à d'autres. Alors, plutôt que de les laisser tomber aux oubliettes, j'ai décidé de les rassembler ici.

Ce site sera donc avant tout un espace de documentation, de guides et de retours d'expérience autour des outils numériques et technologiques que j'utilise, découvre ou apprends à maîtriser.

# Mise en œuvre du projet:

J'ai décidé de ne pas changer mes bonnes habitudes: faire avec les moyens du bord pour que tout reste simple et intuitif à utiliser, mais surtout pour que l'hébergement ne me coûte pas un rond !

Payer un serveur me paraît totalement absurde et particulièrement onéreux, surtout lorsqu'il s'agit simplement de faire tourner un site pour publier quelques documents de temps à autre. Qui plus est, j'ai une sainte horreur de la publicité; il n'est donc absolument pas question d'en coller sur ce projet pour tenter de le financer.

C'est pourquoi j'ai choisi de partir, comme pour mon site principal, sur un site web classique, dit « statique ». Cette approche me permet d'héberger le projet simplement, tout en profitant d'un hébergement entièrement gratuit grâce à [GitHub Pages](https://docs.github.com/en/pages/getting-started-with-github-pages/what-is-github-pages).

Cependant, développer un site statique de A à Z peut rapidement devenir contraignant dès lors que le projet commence à prendre de l'ampleur.

C'est là qu'entrent en jeu les générateurs de sites statiques et pour ma part, j'ai choisi d'utiliser [Hugo](https://gohugo.io/).

# Pourquoi Hugo et qu'est-ce que c'est donc ?

[Hugo](https://gohugo.io/) est un générateur de sites web statiques. Concrètement, il permet de construire un site à partir de modèles, de contenu et de données, puis de générer automatiquement les fichiers HTML, CSS et JavaScript qui seront ensuite servis aux visiteurs.

Cette approche facilite et accélère grandement le développement de sites statiques. Lorsqu'un site est entièrement réalisé à la main, il faut rapidement faire face à beaucoup de répétitions et de copier-coller pour reproduire les mêmes éléments d'une page à l'autre. Hugo permet justement de factoriser tout cela et de générer automatiquement les pages à partir de modèles communs.

J'ai choisi Hugo pour plusieurs raisons:

- **Il est *open source*:** c'est un écosystème que j'affectionne particulièrement et auquel je préfère naturellement contribuer et faire confiance.

- **Il est extrêmement rapide:** développé en Go, Hugo génère les pages d'un site à une vitesse impressionnante. Même sur des projets relativement conséquents, la génération ne prend généralement que quelques instants.

- **Il est très modulable et complet:** Hugo dispose de nombreux thèmes, de modules et d'outils permettant d'étendre ses fonctionnalités. Il bénéficie également d'une communauté active et d'une notoriété solidement établie depuis de nombreuses années.

# Le thème que j'ai choisi et pourquoi:

Le thème que j'utilise n'a pas été conçu par mes soins, mais est très généreusement mis à disposition par **Atsushi Nagase**.

Vous pouvez le retrouver ici: [https://themes.gohugo.io/themes/hugo-primer-blog/](https://themes.gohugo.io/themes/hugo-primer-blog/).

Je me suis simplement permis d'y apporter quelques modifications afin de l'adapter au mieux à mes besoins et à mon identité.

## Pourquoi ce thème ressemble-t-il au design de GitHub ?

Tout simplement parce que j'adore GitHub !

J'utilise cette plateforme depuis de nombreuses années, et elle fait aujourd'hui partie intégrante de mon travail.

Alors forcément, lorsque j'ai découvert ce thème, son inspiration très clairement orientée vers le design de GitHub m'a immédiatement plu. Il était propre, sobre, professionnel, tout en restant agréable à parcourir. Surtout, il répondait déjà à l'ensemble de mes attentes sans nécessiter de gros changements.

Bref, pourquoi chercher plus loin quand quelque chose me plaît déjà ?

# Le code source du projet:

Comme pour la plupart de mes projets personnels, l'intégralité du code source est disponible en *open source*.

Le dépôt ne contient évidemment rien de particulièrement intéressant, mais il permet notamment de retrouver la configuration complète de Hugo ainsi que les différentes modifications que j'ai apportées au thème. Si cela vous intéresse, l'ensemble du projet est disponible sur mon GitHub: [https://github.com/Nde-Code/blog](https://github.com/Nde-Code/blog).

Au-delà de simplement partager le code, j'aimerais que ce projet reste ouvert et puisse, pourquoi pas, devenir participatif.

Chacun est donc libre de consulter le code, de proposer des améliorations, de signaler un problème ou même de contribuer directement au projet.

L'idée est simple: puisque ce projet est fait pour partager, autant que sa construction puisse elle aussi l'être.

# Post-scriptum:

Je ne vais pas prétendre avoir une orthographe irréprochable. J'utilise donc régulièrement différents outils pour relire et corriger mes textes, y compris, évidemment, l'IA.

Malgré tout, ces outils ne sont pas infaillibles et il est donc tout à fait possible qu'une faute ou une coquille se glisse de temps à autre dans un article. Si vous en repérez une, n'hésitez surtout pas à me le signaler.

J'utilise principalement [Scribens](https://www.scribens.fr/) et [Reverso](https://www.reverso.net/orthographe/correcteur-francais/) pour m'aider dans cette tâche.

> L'ouverture d'une *pull request* ou d'une *issue* sur le dépôt GitHub reste de loin le meilleur moyen de me signaler une correction.
