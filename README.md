# Mon École

Application Flutter de suivi scolaire pour les enfants.

## Contenu pédagogique

Les contenus source sont dans `content/<niveau>/<matiere>.yaml`.
Les contenus intégrés actuellement sont :

- SIL / mathématiques : 4 chapitres, 23 exercices
- SIL / français : 4 chapitres, 21 exercices
- CP / mathématiques : 5 chapitres, 29 exercices
- CP / français : 4 chapitres, 24 exercices
- CP / anglais : 4 chapitres, 21 exercices
- CP / sciences : 4 chapitres, 23 exercices

Les seeds SQL complets incluent également les contenus SIL d'anglais, de sciences
et d'informatique, ainsi que l'informatique CP fournis dans les archives.

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

Le fichier généré est `sql/out/seed_sil.sql`. Exécute-le dans Supabase SQL Editor
pour publier les chapitres et exercices. Le script est réexécutable et met à jour
les chapitres par leur identifiant stable sans dupliquer leur contenu.
