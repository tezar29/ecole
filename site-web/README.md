# Site vitrine — Mon École

Site statique en français présentant les fonctionnalités et les plateformes de l’application Flutter Mon École. Render le construit depuis la racine du dépôt avec `mkdir -p dist && cp -R site-web/. dist/` et publie `dist`.

Pages : accueil, fonctionnalités, mobile, ordinateur et téléchargements. Les visuels mobile et ordinateur sont des maquettes illustratives, pas des captures réelles.

La page téléchargements propose l’APK Android **TEST 0.1.0** depuis la préversion GitHub `v0.1.0-android-test`. Il s’agit d’une build debug signée avec la clé de test, portant l’identifiant provisoire `com.example.ecole`; elle n’est pas destinée à la production et ne doit être utilisée qu’avec des comptes et données fictifs. Aucun lien App Store/TestFlight ni installateur Windows n’est disponible. L’archive ZIP est uniquement le code source.

Les visuels sous `assets/` proviennent du dépôt. Les styles et scripts sont autonomes et les liens internes utilisent la racine du site.
