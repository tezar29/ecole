# Guide : ajouter du contenu à l'application

## En 5 étapes
1. **Copie** `content/_modele.yaml` vers `content/<classe>/<matiere>.yaml` (ex. `content/ce1/maths.yaml`). Un seul fichier par classe et par matière.
2. **Écris** tes chapitres : un `id` stable, un `title`, une `lesson` (blocs de texte) et 4 à 6 `exercises`.
3. **Vérifie** : `python tools/build_content.py` (installer une fois : `pip install pyyaml`).
   Le script signale toute erreur précise (réponse absente des options, doublon, emoji risqué…).
   Sous Windows, lance `py tools/build_content.py` avec `PYTHONUTF8=1` pour que les emojis s'affichent
   dans les messages d'erreur.
   ⚠️ Ce script régénère **tout** `sql/out/` : commite d'abord, pour pouvoir comparer et revenir en arrière.
4. **Importe** : dans Supabase > SQL Editor, colle le fichier `sql/out/seed_<classe>.sql` et exécute.
   La toute première fois, exécute d'abord `sql/00_migration_chapters_code.sql`.
5. **Télécharge** : dans l'application, appuie sur « Mes leçons » pour récupérer les nouveaux contenus.

Tu peux relancer l'import à volonté : les chapitres sont mis à jour, jamais dupliqués,
et la progression des enfants est conservée (tant que l'`id` du chapitre ne change pas).

## Les illustrations de leçon
Chaque chapitre peut avoir une image d'illustration, affichée en haut de la leçon : l'enfant appuie dessus
pour entendre le titre. C'est un simple fichier dans l'application, pas une base de données.

- Emplacement : `assets/images/lessons/<code>.jpg`, avec `<code>` = `<classe>-<matiere>-<id>`
  (ex. `sil-maths-chiffres-0-5.jpg` pour le chapitre `id: chiffres-0-5` de `content/sil/maths.yaml`).
- Sans ce fichier, la leçon affiche un bandeau coloré avec l'icône de la matière et le titre :
  l'enfant garde un repère visuel tactile, mais l'illustration reste mieux.
- Format : JPEG, largeur 1000 px maximum, qualité 82. L'app est hors-ligne, donc les illustrations sont
  embarquées ; un fichier de plus de 200 Ko alourdit l'installation pour rien.

Style actuel (à garder homogène) : dessin vectoriel plat, couleurs gaies, formes arrondies, fond pastel clair,
enfants africains joyeux en tenue d'école, 3/2 (1536×1024 à la génération). Pas de texte dans l'image
sauf ce que le chapitre enseigne réellement (les lettres A B C D, les chiffres…).

Fabrication d'une illustration :
1. Générer l'image (outil de génération, ou dessinateur) et l'enregistrer en PNG sous
   `.tmp_illustrations/<code>.png`.
2. Convertir et vérifier la couverture : `py tools/compress_illustrations.py`.
   Le script écrase `assets/images/lessons/` et termine par « Illustrations : N / M chapitres »
   suivi de la liste des chapitres encore sans image.
3. Les PNG de `.tmp_illustrations/` ne sont pas commités (`.gitignore`) ; seuls les JPEG finalistent.

Un bloc `image:` dans la `lesson` reste possible pour une photo hébergée sur Supabase Storage :
l'application la charge avec `CachedNetworkImage` et l'affiche seulement si le réseau l'a récupérée.
Pour un concept propre à un chapitre, préfère l'illustration embarquée : elle fonctionne sans internet.

## Les 5 types d'exercices
| Type | Principe |
|---|---|
| `qcm` | 2 à 4 options, une bonne réponse (`answer` = texte exact). Ordre mélangé automatiquement. |
| `vrai_faux` | `answer: vrai` ou `faux`. |
| `association` | 2 à 5 paires `gauche: droite` ; l'élève relie. |
| `saisie` | L'élève écrit ; `accepted` liste les réponses valides (casse et accents ignorés). |
| `ordre` | Glisser-déposer : écris les éléments dans le bon ordre, l'application les mélange. |

## Bonnes pratiques
- Phrases courtes, vocabulaire simple, **une idée par exercice**, une explication courte pour chaque réponse.
- La consigne est lue à voix haute (bouton 🔊). Ajoute `speak:` si la lecture automatique est mauvaise,
  et **toujours** quand la consigne contient « … ».
- **Anglais** : ajoute `lang: en` sur un bloc de leçon ou une consigne écrits en anglais, pour que la voix
  les lise en anglais (la voix doit être installée sur le téléphone). Les consignes en français restent sans `lang`.
- Emojis : choisis des emojis anciens (🍎 🍌 🍊 ⚽ 🐱 🐟 🌸 🔴 🔺). Les très récents s'affichent en carré vide sur les vieux Android.
- Exemples et noms adaptés au contexte (Awa, Paul, Ngono, francs CFA, beignets, ananas...).
- Brouillon : `published: false` sur un chapitre pour l'enregistrer sans le montrer aux élèves.

## Relecture par un enseignant (checklist)
- [ ] Le chapitre correspond au programme de la classe.
- [ ] Les réponses sont exactes et sans ambiguïté (une seule bonne réponse).
- [ ] Le vocabulaire est adapté à l'âge.
- [ ] Les consignes se comprennent à l'écoute (pour SIL et CP).
- [ ] Les exemples respectent tous les enfants (pas de stéréotypes).


