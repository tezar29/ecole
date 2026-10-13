# Mon École

Application Flutter de suivi scolaire pour les enfants.

## Contenu pédagogique

Les contenus source sont dans `content/<niveau>/<matiere>.yaml`.
Les contenus intégrés actuellement sont :

- SIL / mathématiques : 6 chapitres, 35 exercices
- SIL / français : 6 chapitres, 33 exercices
- SIL / anglais : 5 chapitres, 27 exercices
- SIL / sciences : 5 chapitres, 28 exercices
- SIL / informatique : 2 chapitres, 9 exercices
- CP / mathématiques : 10 chapitres, 59 exercices
- CP / français : 8 chapitres, 48 exercices
- CP / anglais : 5 chapitres, 27 exercices
- CP / sciences : 5 chapitres, 29 exercices
- CP / informatique : 3 chapitres, 13 exercices

Soit 55 chapitres et 308 exercices : les cinq matières sont couvertes en SIL et en CP.

Le programme et les règles éditoriales sont documentés dans `docs/`.

Pour vérifier les fichiers YAML :

```powershell
py -m pip install -r tools/requirements.txt
py tools/build_content.py --check
```

Pour régénérer le script SQL à importer dans Supabase :

```powershell
py tools/build_content.py
```

Les fichiers générés sont `sql/out/seed_sil.sql` et `sql/out/seed_cp.sql` (un par classe).
Exécute-les dans Supabase SQL Editor pour publier les chapitres et exercices. Le script
est réexécutable et met à jour les chapitres par leur identifiant stable sans dupliquer
leur contenu.

## Illustrations

Chaque chapitre peut afficher une illustration dans la leçon : `assets/images/lessons/<code>.jpg`,
où `<code>` = `<classe>-<matiere>-<id>`. L'image est embarquée dans l'application, donc elle fonctionne
hors-ligne ; si le fichier manque, la leçon s'affiche simplement sans carte d'illustration.

40 illustrations sont en place sur les 55 chapitres (~3,3 Mo au total, JPEG 1000 px / qualité 82).
Les 15 chapitres sans image (tous en CP) affichent un bandeau coloré avec l'icône de la matière
et le titre du chapitre : la leçon reste visuelle et tactile dans tous les cas.

Pour générer les JPEG et voir la liste des chapitres manquants :

```powershell
py -m pip install -r tools/requirements.txt
py tools/compress_illustrations.py
```

Les PNG bruts vont dans `.tmp_illustrations/` (non commité). La recette complète et le style à respecter
sont dans `docs/GUIDE_CONTENU.md`.
