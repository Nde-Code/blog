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

Cela fait déjà très longtemps que je voulais créer une section articles sur mon site. Sûrement pas pour parler bêtement de certains sujets ou donner mon avis sur diverses choses, mais beaucoup plus pour expliquer, guider ou partager mon expérience avec certains outils numériques ou technologiques. Ce site porte le "nom" de blog, mais ce que je vais faire ici n'est pas vraiment un blog, et de loin !

À vrai dire, pendant longtemps, après avoir galéré à configurer, brancher ou programmer certains trucs, je rédigeais de petits guides Markdown que je laissais dépérir dans mes Gists GitHub, ce qui est franchement ridicule et ne profite pas à grand monde.

J'aimerais diversifier mes activités, allant au-delà de mon expertise informatique "stricto sensu" pour explorer la technologie dans son ensemble.

# Mise en oeuvre du projet blog:

J'ai décidé de ne pas changer mes bonnes habitudes: faire avec les moyens du bord pour que cela reste simple et intuitif à utiliser, mais surtout pour que l'hébergement ne me coûte pas un rond ! Payer un serveur est pour moi totalement absurde (et très onéreux), surtout s'il s'agit simplement de faire tourner du WordPress pour quelques guides de temps à autre. Qui plus est, j'ai une sainte horreur de la publicité; il n'est donc absolument pas question d'en coller sur mes projets pour les financer. Tout ce que je crée est fait sur mon temps libre, par pur plaisir et par passion.

C'est pourquoi j'ai choisi d'utiliser un site web classique, dit "statique", à l'image de mon site principal, afin de pouvoir héberger ce projet simplement et gratuitement.

Cependant, étant donné la complexité de développement d'un site statique de A à Z, concevoir un espace plus élaboré comme un blog s'avère vite incongru et bien trop long à maintenir sans outils adaptés. C'est là qu'interviennent les "générateurs de sites statiques": ils permettent de développer avec du code dynamique, avant de le compiler en fichiers HTML, CSS et JavaScript traditionnels. Pour ma part, j'ai fait le choix de [Hugo](https://gohugo.io/).

# Pourquoi [Hugo](https://gohugo.io/) et qu'est-ce que c'est donc ?

[Hugo](https://gohugo.io/) est, comme mentionné précédemment, un générateur de sites web statiques. Cela signifie qu'il prend en entrée du code dynamique, un peu à la manière de Django, EJS, etc... mais qu'après compilation, on obtient tout simplement des fichiers web classiques. Cela accélère et facilite grandement le développement de sites statiques qui, lorsqu'ils sont faits entièrement à la main, demandent souvent beaucoup de répétitions et de copier-coller du même bloc de code. 

J'ai choisi Hugo pour plusieurs raisons:

* **Il est open-source:** et c'est un écosystème que j'affectionne particulièrement.
* **Il est extrêmement rapide:** développé en Go, sa compilation ne prend que quelques millisecondes (et encore) !
* **Il est très modulable et complet:** il dispose de nombreux thèmes, d'extensions, mais surtout d'une communauté très active et d'une notoriété solidement établie depuis des années dans le domaine.

Je ferai sans doute un (ou des) article(s) sur [Hugo](https://gohugo.io/) prochainement, parce que c'est vraiment un outil super.

# Le thème que j'ai choisi et pourquoi:

Le thème que j'utilise n'a pas été conçu par mes soins, mais est très généreusement mis à disposition par **Atsushi Nagase**. Vous pouvez le retrouver ici: [hugo-primer-blog](https://themes.gohugo.io/themes/hugo-primer-blog/). Je me suis simplement permis d'ajuster quelques détails afin de l'adapter parfaitement à mes besoins.

## Pourquoi ce thème ressemble-t-il au design de GitHub ?

Tout simplement parce que j'adore GitHub ! C'est une plateforme avec laquelle je travaille depuis de nombreuses années, qui regroupe tout ce dont j'ai besoin, et c'est probablement mon site web préféré.

Il n'y a pas vraiment d'autre explication à donner: le thème me plaisait tel quel, il répondait à toutes mes attentes, et son aspect très propre et professionnel m'a immédiatement convaincu.

# Le code source de projet:

Comme d'habitude, je mets tout mon travail numérique personnel en open-source.

Bien que ce ne soit pas super intéressant, si ce n'est pour voir ma configuration et mes quelques modifications, j'ai, comme d'habitude, mis tout le code de ce projet sur mon GitHub, que vous pouvez aller consulter ici: [https://github.com/Nde-Code/blog](https://github.com/Nde-Code/blog)

Mon intention est de faire un projet participatif dans lequel chacun a la possibilité d'intervenir, de proposer des modifications, ...

# Post-scriptum:

Je n'ai pas une orthographe extraordinaire et j'utilise donc souvent des outils (y compris l'IA, évidemment) pour me corriger. Il n'est donc pas impossible, de temps à autre, de croiser des fautes. Si c'est le cas, m'en faire part me fera extrêmement plaisir.

J'utilise surtout [Scribens](https://www.scribens.fr/) et [Reverso](https://www.reverso.net/orthographe/correcteur-francais/) comme outils.

> L'ouverture d'une *pull request* ou d'une *issue* sur le dépôt GitHub est de loin le moyen à privilégier.
