---
title: "Comment sauvegarder un utilisateur ou une organisation GitHub sous Linux"
date: 2026-10-19
draft: false
tags: ["GitHub", "Python", "pipx", "Linux", "DevOps"]
categories: ["GitHub"]
author: "Nathan Debilloëz"
description: "Sauvegarder un compte utilisateur ou une organisation GitHub sous Linux avec pipx et python-github-backup, à l'aide d'un jeton d'accès personnel à granularité fine."
---

# Introduction:

Cet article explique comment sauvegarder les données d'un compte utilisateur ou d'une organisation GitHub sous Linux.

Nous utiliserons `pipx` pour installer `python-github-backup`, un outil Python qui permet de récupérer de nombreuses données GitHub: dépôts, Gists, _issues_, _pull requests_, etc. Nous automatiserons ensuite la procédure avec un script Bash qui regroupe les données récupérées dans une archive ZIP.

L'objectif est de disposer d'une solution simple, reproductible et relativement complète.

La méthode peut être adaptée à une organisation, mais ce tutoriel prend principalement l'exemple d'un compte personnel. GitLab et les autres plateformes de développement en ligne ne sont pas abordés.

# Prérequis:

Avant de commencer, assurez-vous de disposer des éléments suivants:

- **Une machine sous Linux**: j'utiliserai Ubuntu sous WSL (_Windows Subsystem for Linux_), une solution pratique si vous êtes sous Windows et souhaitez disposer d'un environnement Linux.
- **Une connaissance de base du terminal**: il faut pouvoir exécuter des commandes Linux et modifier des fichiers de configuration.
- **Un système à jour**: sur Ubuntu, vous pouvez utiliser la commande `sudo apt update && sudo apt full-upgrade -y`.

La procédure a été testée sur Ubuntu 24.04 et Ubuntu 26.04.

> **Remarque:** `apt full-upgrade` peut installer ou supprimer certains paquets pour résoudre les dépendances. Si vous préférez une mise à jour plus prudente, utilisez `sudo apt update && sudo apt upgrade -y`.

# Installation des outils:

## 1. Installer `pipx`:

`pipx` permet d'installer des applications Python dans des environnements virtuels isolés. Contrairement à une installation globale avec `pip`, cette approche évite généralement de mélanger les dépendances de différentes applications ou de modifier les paquets Python gérés par le système. C'est particulièrement adapté à `python-github-backup`, puisque nous souhaitons simplement installer et utiliser un programme en ligne de commande.

Commençons par installer les paquets nécessaires:

```bash
sudo apt install pipx python3-full python3-venv git git-lfs zip -y
```

Git sert à récupérer les dépôts et `zip` à créer l'archive finale.

Ajoutons ensuite le répertoire des applications installées par `pipx` au `PATH`:

```bash
pipx ensurepath
```

Si nécessaire, fermez puis rouvrez votre terminal pour que la modification soit prise en compte.

Vérifiez enfin que `pipx` est disponible:

```bash
pipx --version
```

Une version doit s'afficher dans le terminal.

## 2. Vérifier la version de Python:

`python-github-backup` nécessite Python 3.10 ou une version plus récente. Vérifions la version installée:

```bash
python3 --version
```

Une sortie telle que `Python 3.12.3` convient. Si votre version est antérieure à Python 3.10, installez une version compatible avant de poursuivre.

## 3. Installer `python-github-backup`:

Le projet est disponible sur GitHub: [https://github.com/josegonzalez/python-github-backup](https://github.com/josegonzalez/python-github-backup). Il propose de nombreuses options permettant de choisir les données à récupérer, que nous utiliserons dans notre script Bash.

Pour installer l'outil directement depuis son dépôt avec `pipx`, exécutez:

```bash
pipx install git+https://github.com/josegonzalez/python-github-backup.git
```

Une fois l'installation terminée, vérifiez que la commande est accessible:

```bash
github-backup --help
```

L'aide affiche les options disponibles. Si la commande n'est pas trouvée, vérifiez que le répertoire des applications `pipx` est bien présent dans votre `PATH`.

> **Remarque:** cette commande installe la version disponible sur le dépôt au moment de l'installation. Les options pouvant évoluer, consultez la sortie de `github-backup --help` et la documentation du projet avant d'adapter le script.

# Authentification auprès de GitHub:

## 4. Créer un _fine-grained personal access token_:

Pour accéder aux données d'un compte GitHub, l'outil doit s'authentifier auprès de l'API GitHub. Nous allons utiliser un _fine-grained personal access token_, c'est-à-dire un jeton d'accès personnel à granularité fine. Il permet de limiter l'accès à un compte ou à une organisation et à des dépôts déterminés, ainsi que de sélectionner précisément les permissions accordées.

### 4.1. Créer le jeton:

Dans GitHub, ouvrez les paramètres de votre compte et rendez-vous dans:

_Settings_ > _Developer settings_ > _Personal access tokens_ > _Fine-grained tokens_

Vous pouvez aussi accéder directement à cette page: [https://github.com/settings/personal-access-tokens](https://github.com/settings/personal-access-tokens).

Créez un nouveau jeton et donnez-lui un nom explicite, par exemple `github-backup-linux`. Choisissez ensuite le compte propriétaire des données à sauvegarder.

Définissez une date d'expiration adaptée à votre utilisation. Une expiration impose de renouveler le jeton, mais limite la durée pendant laquelle un jeton compromis reste utilisable.

### 4.2. Choisir les dépôts accessibles:

Dans la section _Repository access_, choisissez les dépôts auxquels le jeton doit avoir accès. Pour sauvegarder tous les dépôts accessibles de votre compte, sélectionnez tous les dépôts si cette option est disponible et correspond à votre besoin.

Pour sauvegarder une organisation, sélectionnez l'organisation concernée et les dépôts appropriés. Certaines organisations imposent des restrictions ou une approbation administrative pour les jetons.

> **Attention:** le jeton ne donne accès qu'aux ressources autorisées. Il ne permet pas de sauvegarder des données auxquelles votre compte n'a pas accès.

### 4.3. Configurer les permissions:

Pour la procédure présentée dans cet article, les permissions à configurer sont les suivantes.

**Permissions du compte utilisateur (_Account permissions_)**

| Permission  | Niveau d'accès   |
| ----------- | ---------------- |
| _Followers_ | _Read_           |
| _Starring_  | _Read_           |
| _Gists_     | _Read and write_ |

**Permissions des dépôts (_Repository permissions_)**

| Permission              | Niveau d'accès |
| ----------------------- | -------------- |
| _Contents_              | _Read_         |
| _Discussions_           | _Read_         |
| _Issues_                | _Read_         |
| _Metadata_              | _Read_         |
| _Pull requests_         | _Read_         |
| _Repository advisories_ | _Read_         |
| _Webhooks_              | _Read_         |

La permission `Contents: Read` est indispensable pour accéder au contenu des dépôts. La permission `Metadata: Read` est généralement accordée automatiquement lorsqu'un jeton dispose d'un accès aux dépôts.

Ces permissions constituent une base pour les données visées par ce tutoriel. Selon les options utilisées, la version de l'outil, le type de compte et les restrictions imposées par une organisation, des permissions supplémentaires peuvent être nécessaires.

### 4.4. Pourquoi ces permissions ?

Le script de sauvegarde ne récupère pas uniquement les fichiers des dépôts. Selon les options activées et les autorisations accordées, il peut également tenter de récupérer:

- les dépôts privés et les _forks_ ;
- les Gists ;
- les _issues_ et leurs commentaires ;
- les _pull requests_, leurs commentaires et leurs revues ;
- les discussions ;
- les wikis et les données Git LFS ;
- les informations des _releases_ et leurs fichiers ;
- les dépôts favoris, les abonnements et les abonnés ;
- les _webhooks_ et les avis de sécurité ;
- les pièces jointes associées à certaines _issues_, _pull requests_ ou discussions.

Toutes ces données ne reposent pas nécessairement sur les mêmes permissions: une sauvegarde peut donc être partielle si certaines autorisations sont manquantes.

> **Important:** les permissions proposées ci-dessus ne garantissent pas que chaque option du script fonctionnera dans tous les contextes. Pour récupérer des données supplémentaires, consultez la documentation de `python-github-backup`, vérifiez les permissions requises et ajoutez les options correspondantes lorsqu'elles sont prises en charge. Les limitations de l'API GitHub, les restrictions des jetons à granularité fine et les politiques de l'organisation peuvent également empêcher la récupération de certaines données.

Une fois la configuration terminée, générez le jeton et copiez-le immédiatement dans un emplacement temporaire sûr. GitHub ne permet généralement pas de réafficher la valeur complète du jeton après sa création.

### 4.5. Enregistrer le jeton dans le fichier `.bashrc`:

Nous allons stocker le jeton dans une variable d'environnement nommée `GITHUB_TOKEN_BACKUP`. Ce nom est un simple choix de convention: vous pouvez en utiliser un autre, à condition d'employer exactement le même dans le fichier `.bashrc` et dans le script Bash.

Ouvrez le fichier:

```bash
nano ~/.bashrc
```

Ajoutez à la fin du fichier la ligne suivante, en remplaçant `VOTRE_JETON_ICI` par le jeton que vous venez de créer:

```bash
export GITHUB_TOKEN_BACKUP="VOTRE_JETON_ICI"
```

Enregistrez le fichier et quittez l'éditeur. Avec Nano, utilisez `Ctrl + O`, puis `Entrée`, et enfin `Ctrl + X`.

Rechargez la configuration:

```bash
source ~/.bashrc
```

Vous pouvez vérifier que la variable est définie sans afficher sa valeur:

```bash
if [[ -n "${GITHUB_TOKEN_BACKUP:-}" ]]; then
    echo "Le jeton est configuré."
else
    echo "Le jeton n'est pas configuré."
fi
```

Le fichier `.bashrc` contient désormais un secret en clair. Assurez-vous que les permissions de votre répertoire personnel et de ce fichier sont adaptées. Vous pouvez limiter celles du fichier avec:

```bash
chmod 600 ~/.bashrc
```

> **Conseil de sécurité:** ne partagez jamais votre fichier `.bashrc`, votre jeton ou une capture d'écran qui révélerait sa valeur. Si le jeton est exposé, révoquez-le et créez-en un nouveau.

# Automatiser la sauvegarde:

## 5. Créer le script Bash de sauvegarde:

Nous avons maintenant tous les éléments nécessaires pour automatiser la sauvegarde. Le script va:

1. vérifier la présence du jeton ;
2. créer un répertoire temporaire et un fichier journal ;
3. lancer `github-backup` avec les options choisies ;
4. compresser les données récupérées dans une archive ZIP ;
5. vérifier l'intégrité de l'archive ;
6. copier l'archive dans le répertoire de destination ;
7. supprimer les données temporaires si la sauvegarde s'est terminée correctement ;
8. supprimer les archives de plus de 30 jours.

Cette méthode conserve une archive datée à chaque exécution, tout en évitant d'accumuler indéfiniment les anciennes sauvegardes.

### 5.1. Choisir le répertoire de destination:

Pour que le script reste utilisable sur différentes distributions Linux et différentes machines, les archives sont enregistrées par défaut dans `~/github-backups`.

Si vous préférez un autre emplacement, vous pouvez modifier la variable `GITHUB_BACKUP_DIR`. Sous WSL, par exemple, vous pouvez utiliser un dossier OneDrive accessible depuis Linux. Cette possibilité dépend de votre propre configuration: le chemin Windows monté sous `/mnt/c/Users/...` n'est pas identique sur toutes les machines.

### 5.2. Écrire le script:

Créez un fichier nommé `save-github.sh`:

```bash
nano ~/save-github.sh
```

Collez-y le script complet suivant:

```bash
#!/usr/bin/env bash
set -Eeuo pipefail

# Compte GitHub à sauvegarder
GITHUB_USER="Nde-Code"

# Jeton fourni par l'environnement
TOKEN="${GITHUB_TOKEN_BACKUP:-}"

if [[ -z "$TOKEN" ]]; then
    echo "ERREUR: la variable GITHUB_TOKEN_BACKUP est vide ou absente."
    exit 1
fi

# Répertoires et fichiers
DATE="$(date +%Y-%m-%d_%H%M%S)"
TEMP_DIR="$(mktemp -d /tmp/github_backup_temp.XXXXXX)"
ARCHIVE_NAME="github_backup_full_${DATE}.zip"
ARCHIVE_PATH="/tmp/${ARCHIVE_NAME}"
LOGFILE="/tmp/github_backup_${DATE}.log"

# Répertoire de destination: emplacement générique par défaut.
# Vous pouvez définir GITHUB_BACKUP_DIR pour utiliser un autre emplacement.
DEST_PATH="${GITHUB_BACKUP_DIR:-"$HOME/github-backups"}"

mkdir -p "$DEST_PATH"

# Journaliser la sortie standard et les erreurs
exec > >(tee -a "$LOGFILE") 2>&1

echo "Début de la sauvegarde GitHub: $(date)"
echo "Compte: $GITHUB_USER"
echo "Répertoire de destination: $DEST_PATH"
echo "Journal: $LOGFILE"

# Récupération des données GitHub
github-backup -f "$TOKEN" \
    -o "$TEMP_DIR" \
    -P -F \
    --repositories --gists \
    --issues --issue-comments --issue-events \
    --pulls --pull-comments --pull-reviews --pull-commits --pull-details \
    --labels --milestones --discussions \
    --wikis --lfs \
    --releases --assets \
    --starred \
    --followers \
    --following \
    --hooks \
    --security-advisories \
    --attachments \
    --throttle-limit 100 \
    --throttle-pause 60 \
    "$GITHUB_USER"

# Refuser de produire une archive vide
if [[ -z "$(find "$TEMP_DIR" -mindepth 1 -print -quit)" ]]; then
    echo "ERREUR: aucune donnée n'a été récupérée."
    echo "Les données temporaires sont conservées dans: $TEMP_DIR"
    exit 1
fi

# Création de l'archive
echo "Création de l'archive: $ARCHIVE_PATH"

(
    cd "$TEMP_DIR"
    zip -r "$ARCHIVE_PATH" .
)

# Vérification de l'intégrité
echo "Vérification de l'archive..."
zip -T "$ARCHIVE_PATH"

# Copie de l'archive vers la destination
echo "Copie de l'archive vers $DEST_PATH"
cp "$ARCHIVE_PATH" "$DEST_PATH/"

# Nettoyage après une sauvegarde réussie
rm -rf -- "$TEMP_DIR"
rm -f -- "$ARCHIVE_PATH"

# Suppression des archives de plus de 30 jours
find "$DEST_PATH" \
    -maxdepth 1 \
    -type f \
    -name 'github_backup_full_*.zip' \
    -mtime +30 \
    -delete

echo "Sauvegarde terminée avec succès."
echo "Archive: $DEST_PATH/$ARCHIVE_NAME"
echo "Journal: $LOGFILE"
```

### 5.3. Comprendre le fonctionnement du script:

Même s'il peut sembler long, le script reste assez simple. Voici ses différentes parties.

#### Les premières lignes:

```bash
#!/usr/bin/env bash
set -Eeuo pipefail
```

La première ligne indique que le script doit être exécuté avec Bash. La seconde active plusieurs options destinées à améliorer la détection des erreurs: le script s'arrête notamment lorsqu'une commande échoue, lorsqu'une variable non définie est utilisée ou lorsqu'une commande échoue au sein d'un _pipeline_.

#### La configuration du compte et du jeton:

```bash
GITHUB_USER="Nde-Code"
TOKEN="${GITHUB_TOKEN_BACKUP:-}"
```

`GITHUB_USER` correspond au nom du compte GitHub à sauvegarder. Remplacez `Nde-Code` par votre propre nom d'utilisateur ou par celui de l'organisation ciblée.

Le jeton est lu depuis la variable d'environnement `GITHUB_TOKEN_BACKUP`, définie précédemment dans `.bashrc`. L'expression `${GITHUB_TOKEN_BACKUP:-}` renvoie une chaîne vide si la variable n'existe pas, plutôt que de provoquer immédiatement une erreur avec `set -u`.

#### La création des chemins et des fichiers:

```bash
DATE="$(date +%Y-%m-%d_%H%M%S)"
TEMP_DIR="$(mktemp -d /tmp/github_backup_temp.XXXXXX)"
ARCHIVE_NAME="github_backup_full_${DATE}.zip"
ARCHIVE_PATH="/tmp/${ARCHIVE_NAME}"
LOGFILE="/tmp/github_backup_${DATE}.log"
DEST_PATH="${GITHUB_BACKUP_DIR:-"$HOME/github-backups"}"
```

Chaque exécution utilise un horodatage afin de distinguer les sauvegardes.

- `TEMP_DIR`: répertoire temporaire dans lequel l'outil télécharge les données.
- `ARCHIVE_NAME`: nom de l'archive ZIP finale.
- `ARCHIVE_PATH`: emplacement temporaire de l'archive avant sa copie.
- `DEST_PATH`: répertoire dans lequel les sauvegardes sont conservées.
- `LOGFILE`: fichier contenant la sortie du script et les messages d'erreur.

Par défaut, les archives sont placées dans `~/github-backups`. La variable d'environnement `GITHUB_BACKUP_DIR` permet de choisir un autre emplacement sans modifier le script.

#### La journalisation:

```bash
exec > >(tee -a "$LOGFILE") 2>&1
```

Cette instruction envoie les sorties du script vers le terminal et les ajoute au fichier journal. Elle permet de suivre la progression et de rechercher plus facilement la cause d'un problème.

#### L'appel à `github-backup`:

C'est le cœur du script. La commande récupère les données accessibles sur GitHub en fonction des options fournies.

Les options `-f "$TOKEN"` et `-o "$TEMP_DIR"` définissent respectivement le jeton d'authentification et le répertoire de sortie. Les options `-P` et `-F` demandent de prendre en compte les dépôts privés et les _forks_. Les autres options activent la récupération de différentes catégories de données.

Le script couvre déjà un grand nombre de données: dépôts, Gists, _issues_, _pull requests_, discussions, wikis, _releases_ et plusieurs métadonnées. La sauvegarde est donc assez large, sans être nécessairement exhaustive.

Pour sauvegarder d'autres données ou ajuster précisément ce qui est récupéré, consultez `github-backup --help` et la documentation du projet. Ajoutez les permissions nécessaires au jeton ainsi que les options correspondantes lorsqu'elles existent: toutes les catégories ne sont pas accessibles avec tous les types de jetons ou tous les comptes.

#### La création et la vérification de l'archive:

```bash
(
    cd "$TEMP_DIR"
    zip -r "$ARCHIVE_PATH" .
)

zip -T "$ARCHIVE_PATH"
```

Le script se place dans le répertoire temporaire, puis compresse son contenu. La commande `zip -T` vérifie l'intégrité de l'archive produite. Cette vérification est utile, mais elle ne prouve pas que toutes les données attendues ont été téléchargées: il reste nécessaire de consulter le journal et de contrôler le contenu de l'archive.

#### La copie et le nettoyage:

```bash
cp "$ARCHIVE_PATH" "$DEST_PATH/"
```

Une fois l'archive créée et vérifiée, elle est copiée vers le répertoire de sauvegarde. Les fichiers temporaires ne sont supprimés qu'après cette étape. Enfin, la commande `find` supprime les archives correspondant au modèle `github_backup_full_*.zip` dont la date de modification remonte à plus de 30 jours.

Cette politique de rétention est volontairement simple. Adaptez-la si vous souhaitez conserver davantage d'historique ou mettre certaines sauvegardes à l'abri d'une suppression accidentelle.

> **Attention:** si la récupération, la compression, la vérification ou la copie échoue, `set -e` interrompt le script. Les données temporaires peuvent alors rester dans `/tmp` pour faciliter le diagnostic. Vérifiez le journal avant de les supprimer manuellement.

### 5.4. Utiliser OneDrive ou un autre emplacement:

L'emplacement `~/github-backups` est un choix générique qui convient à la plupart des environnements Linux.

Si vous utilisez Ubuntu sous WSL et que votre dossier OneDrive est accessible depuis Linux, vous pouvez le choisir sans modifier le script. Adaptez le chemin ci-dessous à votre propre nom d'utilisateur Windows et à l'emplacement réel de votre dossier OneDrive:

```bash
export GITHUB_BACKUP_DIR="/mnt/c/Users/VOTRE_UTILISATEUR/OneDrive/GitHub"
```

Ajoutez cette ligne à `~/.bashrc`, puis rechargez la configuration:

```bash
source ~/.bashrc
```

Le script utilisera désormais ce dossier comme destination. Si la variable n'est pas définie, il continuera d'utiliser `~/github-backups`.

> **À garder à l'esprit:** la synchronisation OneDrive est pratique, mais elle ne remplace pas une stratégie de sauvegarde indépendante. Une suppression ou une corruption synchronisée peut également toucher les copies distantes. Pour les données importantes, conservez si possible une autre copie sur un support ou dans un emplacement distinct.

### 5.5. Rendre le script exécutable:

Enregistrez le fichier, puis donnez-lui les permissions nécessaires:

```bash
chmod +x ~/save-github.sh
```

Vous pouvez maintenant le lancer directement:

```bash
~/save-github.sh
```

La première exécution peut être assez longue, en particulier si vous possédez de nombreux dépôts privés, des fichiers Git LFS ou de nombreuses _issues_ et _pull requests_.

Le paramétrage `--throttle-limit 100 --throttle-pause 60` peut entraîner des pauses lorsque la limite d'API approche. Vous pouvez ajuster ces valeurs après avoir consulté la documentation et les journaux d'exécution.

## 6. Créer un alias Linux pour lancer la sauvegarde:

Pour ne pas devoir saisir le chemin complet du script à chaque exécution, nous allons créer un alias nommé `save-github`.

Ouvrez le fichier `.bashrc`:

```bash
nano ~/.bashrc
```

Ajoutez à la fin du fichier:

```bash
alias save-github="$HOME/save-github.sh"
```

Enregistrez puis rechargez la configuration:

```bash
source ~/.bashrc
```

La sauvegarde se lance désormais depuis le terminal avec une simple commande:

```bash
save-github
```

L'alias fonctionne dans les sessions Bash qui chargent ce fichier de configuration. Si vous utilisez un autre shell, la configuration devra être adaptée.

# Première sauvegarde et vérifications:

## 7. Réaliser la première sauvegarde:

Tout est prêt. Lancez simplement:

```bash
save-github
```

Le script récupère les données accessibles sur GitHub, crée une archive ZIP et la copie dans le répertoire de destination. Par défaut, vous la trouverez dans:

```text
~/github-backups/
```

Si vous avez défini `GITHUB_BACKUP_DIR`, l'archive sera enregistrée à cet emplacement. Son nom ressemblera à ceci:

```text
github_backup_full_2026-10-19_130000.zip
```

La date et l'heure dépendent évidemment du moment où vous exécutez la commande.

Les journaux sont enregistrés dans `/tmp`, sous la forme `github_backup_DATE.log`. En cas de problème, consultez le journal correspondant à l'exécution concernée.

## 8. Vérifier le résultat:

Avant de considérer la sauvegarde comme opérationnelle, je recommande de contrôler les points suivants:

- L'archive ZIP existe et peut être ouverte.
- Les dépôts attendus sont présents.
- Les données complémentaires recherchées, comme les Gists, les _issues_ et les _pull requests_, ont bien été récupérées.
- Le journal ne contient pas d'erreurs d'authentification ou de permissions.
- Vous disposez d'assez d'espace disque pour les sauvegardes successives.

Enfin, testez la restauration de quelques données dans un répertoire séparé: une sauvegarde n'est réellement utile que si l'on peut exploiter les données récupérées.

# Conclusion:

Nous avons mis en place une solution de sauvegarde GitHub sous Linux reposant sur trois éléments: `pipx` pour installer l'application Python, `python-github-backup` pour récupérer les données et un script Bash pour automatiser la procédure et créer une archive ZIP.

Cette approche ne nécessite pas d'infrastructure particulière et peut être exécutée à la demande. Le script peut également servir de base à une automatisation ultérieure.

Il faut toutefois garder à l'esprit qu'une sauvegarde réalisée sur le même ordinateur ne protège pas contre tous les scénarios de perte de données. Pour aller plus loin, vous pouvez copier les archives vers un disque externe ou un autre emplacement indépendant.

Enfin, la sauvegarde reste limitée par les permissions du jeton, les droits du compte et les fonctionnalités prises en charge par l'outil. Le script fourni active déjà de nombreuses options, mais il ne garantit pas une copie exhaustive de toutes les données GitHub. Pour récupérer des éléments supplémentaires, consultez la documentation officielle, ajoutez les permissions nécessaires au jeton et activez les options correspondantes lorsqu'elles sont prises en charge.
