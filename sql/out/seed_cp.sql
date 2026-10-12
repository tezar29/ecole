-- Contenu CP — généré par tools/build_content.py (ne pas modifier à la main)
-- À coller dans Supabase > SQL Editor. Peut être relancé sans risque.

-- cp-maths-nombres-20 : Les nombres jusqu'à 20
with ch as (
  insert into public.chapters (code, subject_id, level, title, position, content, is_published)
  select 'cp-maths-nombres-20', s.id, 'cp'::public.school_level, 'Les nombres jusqu''à 20',
         1, '{"blocks":[{"type":"text","value":"On compte : 11 onze, 12 douze, 13 treize, 14 quatorze, 15 quinze, 16 seize."},{"type":"text","value":"Ensuite : 17 dix-sept, 18 dix-huit, 19 dix-neuf, 20 vingt."},{"type":"text","value":"Pour trouver le nombre qui vient après, on ajoute 1."}]}'::jsonb, true
  from public.subjects s where s.slug = 'maths'
  on conflict (code) do update set
    subject_id = excluded.subject_id, level = excluded.level, title = excluded.title,
    position = excluded.position, content = excluded.content, is_published = excluded.is_published
  returning id
), del as (
  delete from public.exercises where chapter_id in (select id from ch)
)
insert into public.exercises (chapter_id, type, question, answer, position)
select ch.id, v.t::public.exercise_type, v.q::jsonb, v.a::jsonb, v.p
from ch, (values
    ('qcm', '{"text":"Quel nombre vient après 14 ?","options":["16","15","13"]}'::jsonb, '{"explanation":"On compte : 13, 14, 15.","correct":1}'::jsonb, 1),
    ('qcm', '{"text":"Quel nombre vient juste avant 20 ?","options":["21","19","18"]}'::jsonb, '{"explanation":"On compte : 18, 19, 20.","correct":1}'::jsonb, 2),
    ('saisie', '{"text":"Écris en chiffres : quinze","keyboard":"number"}'::jsonb, '{"explanation":"Quinze s''écrit 15.","accepted":["15"]}'::jsonb, 3),
    ('association', '{"text":"Relie chaque nombre à son écriture en lettres.","pairs":[{"left":"12","right":"douze"},{"left":"16","right":"seize"},{"left":"18","right":"dix-huit"}]}'::jsonb, '{"explanation":"12 douze, 16 seize, 18 dix-huit."}'::jsonb, 4),
    ('glisser_deposer', '{"text":"Range du plus petit au plus grand.","items":["17","14","20","11"]}'::jsonb, '{"explanation":"On range : 11, 14, 17, 20.","order":["11","14","17","20"]}'::jsonb, 5),
    ('qcm', '{"text":"Quel nombre est le plus grand ?","options":["12","18","15"]}'::jsonb, '{"explanation":"18 est plus grand que 15 et que 12.","correct":1}'::jsonb, 6)
) as v(t, q, a, p);

-- cp-maths-dizaine-unites : La dizaine et les unités
with ch as (
  insert into public.chapters (code, subject_id, level, title, position, content, is_published)
  select 'cp-maths-dizaine-unites', s.id, 'cp'::public.school_level, 'La dizaine et les unités',
         2, '{"blocks":[{"type":"text","value":"Une dizaine, c''est un paquet de 10 unités."},{"type":"text","value":"Le nombre 13, c''est 1 dizaine et 3 unités."},{"type":"text","value":"Le nombre 20, c''est 2 dizaines et 0 unité."}]}'::jsonb, true
  from public.subjects s where s.slug = 'maths'
  on conflict (code) do update set
    subject_id = excluded.subject_id, level = excluded.level, title = excluded.title,
    position = excluded.position, content = excluded.content, is_published = excluded.is_published
  returning id
), del as (
  delete from public.exercises where chapter_id in (select id from ch)
)
insert into public.exercises (chapter_id, type, question, answer, position)
select ch.id, v.t::public.exercise_type, v.q::jsonb, v.a::jsonb, v.p
from ch, (values
    ('qcm', '{"text":"Une dizaine, c''est combien d''unités ?","options":["10","20","5"]}'::jsonb, '{"explanation":"Une dizaine, c''est 10 unités.","correct":0}'::jsonb, 1),
    ('qcm', '{"text":"Dans 14, combien y a-t-il d''unités ?","options":["14","1","4"]}'::jsonb, '{"explanation":"14, c''est 1 dizaine et 4 unités.","correct":2}'::jsonb, 2),
    ('qcm', '{"text":"Dans 17, combien y a-t-il de dizaines ?","options":["7","10","1"]}'::jsonb, '{"explanation":"17, c''est 1 dizaine et 7 unités.","correct":2}'::jsonb, 3),
    ('saisie', '{"text":"13 = 1 dizaine et … unités","speak":"Treize, c''est une dizaine et combien d''unités ?","keyboard":"number"}'::jsonb, '{"explanation":"13, c''est 1 dizaine et 3 unités.","accepted":["3"]}'::jsonb, 4),
    ('vrai_faux', '{"text":"Dans 20, il y a 2 dizaines.","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"20, c''est 2 dizaines et 0 unité.","correct":0}'::jsonb, 5)
) as v(t, q, a, p);

-- cp-maths-addition-10 : Additionner jusqu'à 10
with ch as (
  insert into public.chapters (code, subject_id, level, title, position, content, is_published)
  select 'cp-maths-addition-10', s.id, 'cp'::public.school_level, 'Additionner jusqu''à 10',
         3, '{"blocks":[{"type":"text","value":"Additionner, c''est ajouter. 3 + 2 = 5.","speak":"Additionner, c''est ajouter. 3 plus 2 égale 5."},{"type":"text","value":"Awa a 3 bananes 🍌🍌🍌. Paul lui en donne 2 🍌🍌. Elle a maintenant 3 + 2 = 5 bananes.","speak":"Awa a trois bananes. Paul lui en donne deux. Elle a maintenant trois plus deux égale cinq bananes."}]}'::jsonb, true
  from public.subjects s where s.slug = 'maths'
  on conflict (code) do update set
    subject_id = excluded.subject_id, level = excluded.level, title = excluded.title,
    position = excluded.position, content = excluded.content, is_published = excluded.is_published
  returning id
), del as (
  delete from public.exercises where chapter_id in (select id from ch)
)
insert into public.exercises (chapter_id, type, question, answer, position)
select ch.id, v.t::public.exercise_type, v.q::jsonb, v.a::jsonb, v.p
from ch, (values
    ('qcm', '{"text":"4 + 3 = ?","speak":"4 plus 3 égale combien ?","options":["7","8","6"]}'::jsonb, '{"explanation":"4 + 3 = 7.","correct":0}'::jsonb, 1),
    ('qcm', '{"text":"5 + 5 = ?","speak":"5 plus 5 égale combien ?","options":["9","11","10"]}'::jsonb, '{"explanation":"5 + 5 = 10.","correct":2}'::jsonb, 2),
    ('saisie', '{"text":"6 + 2 = ?","speak":"6 plus 2 égale combien ?","keyboard":"number"}'::jsonb, '{"explanation":"6 + 2 = 8.","accepted":["8"]}'::jsonb, 3),
    ('qcm', '{"text":"Ngono a 4 oranges. On lui en donne 3. Combien a-t-elle d''oranges ?","options":["8","6","7"]}'::jsonb, '{"explanation":"4 + 3 = 7.","correct":2}'::jsonb, 4),
    ('association', '{"text":"Relie chaque addition à son résultat.","pairs":[{"left":"1 + 1","right":"2"},{"left":"2 + 3","right":"5"},{"left":"4 + 4","right":"8"}]}'::jsonb, '{"explanation":"1 + 1 = 2, 2 + 3 = 5, 4 + 4 = 8."}'::jsonb, 5),
    ('vrai_faux', '{"text":"3 + 3 = 7","speak":"3 plus 3 égale 7","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"3 + 3 = 6.","correct":1}'::jsonb, 6)
) as v(t, q, a, p);

-- cp-maths-soustraction-10 : Soustraire jusqu'à 10
with ch as (
  insert into public.chapters (code, subject_id, level, title, position, content, is_published)
  select 'cp-maths-soustraction-10', s.id, 'cp'::public.school_level, 'Soustraire jusqu''à 10',
         4, '{"blocks":[{"type":"text","value":"Soustraire, c''est enlever. 5 − 2 = 3.","speak":"Soustraire, c''est enlever. 5 moins 2 égale 3."},{"type":"text","value":"Paul a 5 billes. Il en perd 2. Il lui en reste 5 − 2 = 3.","speak":"Paul a cinq billes. Il en perd deux. Il lui en reste cinq moins deux égale trois."}]}'::jsonb, true
  from public.subjects s where s.slug = 'maths'
  on conflict (code) do update set
    subject_id = excluded.subject_id, level = excluded.level, title = excluded.title,
    position = excluded.position, content = excluded.content, is_published = excluded.is_published
  returning id
), del as (
  delete from public.exercises where chapter_id in (select id from ch)
)
insert into public.exercises (chapter_id, type, question, answer, position)
select ch.id, v.t::public.exercise_type, v.q::jsonb, v.a::jsonb, v.p
from ch, (values
    ('qcm', '{"text":"7 − 3 = ?","speak":"7 moins 3 égale combien ?","options":["5","4","3"]}'::jsonb, '{"explanation":"7 − 3 = 4.","correct":1}'::jsonb, 1),
    ('qcm', '{"text":"10 − 5 = ?","speak":"10 moins 5 égale combien ?","options":["4","6","5"]}'::jsonb, '{"explanation":"10 − 5 = 5.","correct":2}'::jsonb, 2),
    ('saisie', '{"text":"9 − 4 = ?","speak":"9 moins 4 égale combien ?","keyboard":"number"}'::jsonb, '{"explanation":"9 − 4 = 5.","accepted":["5"]}'::jsonb, 3),
    ('qcm', '{"text":"Paul a 8 billes. Il en perd 3. Combien lui en reste-t-il ?","options":["4","6","5"]}'::jsonb, '{"explanation":"8 − 3 = 5.","correct":2}'::jsonb, 4),
    ('vrai_faux', '{"text":"6 − 2 = 4","speak":"6 moins 2 égale 4","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"6 − 2 = 4.","correct":0}'::jsonb, 5),
    ('association', '{"text":"Relie chaque soustraction à son résultat.","pairs":[{"left":"5 − 1","right":"4"},{"left":"6 − 3","right":"3"},{"left":"9 − 2","right":"7"}]}'::jsonb, '{"explanation":"5 − 1 = 4, 6 − 3 = 3, 9 − 2 = 7."}'::jsonb, 6)
) as v(t, q, a, p);

-- cp-maths-monnaie-fcfa : Les pièces et les billets (FCFA)
with ch as (
  insert into public.chapters (code, subject_id, level, title, position, content, is_published)
  select 'cp-maths-monnaie-fcfa', s.id, 'cp'::public.school_level, 'Les pièces et les billets (FCFA)',
         5, '{"blocks":[{"type":"text","value":"Au Cameroun, on utilise le franc CFA. On écrit F.","speak":"Au Cameroun, on utilise le franc CFA. On écrit la lettre F."},{"type":"text","value":"Il y a des pièces : 5 F, 10 F, 25 F, 50 F, 100 F et 500 F."},{"type":"text","value":"Il y a des billets : 1 000 F, 2 000 F, 5 000 F et 10 000 F."}]}'::jsonb, true
  from public.subjects s where s.slug = 'maths'
  on conflict (code) do update set
    subject_id = excluded.subject_id, level = excluded.level, title = excluded.title,
    position = excluded.position, content = excluded.content, is_published = excluded.is_published
  returning id
), del as (
  delete from public.exercises where chapter_id in (select id from ch)
)
insert into public.exercises (chapter_id, type, question, answer, position)
select ch.id, v.t::public.exercise_type, v.q::jsonb, v.a::jsonb, v.p
from ch, (values
    ('qcm', '{"text":"Quelle est la monnaie du Cameroun ?","options":["le dollar","l''euro","le franc CFA"]}'::jsonb, '{"explanation":"Au Cameroun, on paie avec des francs CFA.","correct":2}'::jsonb, 1),
    ('qcm', '{"text":"Tu as 100 F. Un bonbon coûte 50 F. Combien te reste-t-il ?","options":["50 F","40 F","60 F"]}'::jsonb, '{"explanation":"100 F − 50 F = 50 F.","correct":0}'::jsonb, 2),
    ('qcm', '{"text":"Un beignet coûte 100 F. Tu en achètes 2. Combien paies-tu ?","options":["300 F","200 F","100 F"]}'::jsonb, '{"explanation":"100 F + 100 F = 200 F.","correct":1}'::jsonb, 3),
    ('glisser_deposer', '{"text":"Range les pièces de la plus petite à la plus grande valeur.","items":["25 F","500 F","5 F","100 F"]}'::jsonb, '{"explanation":"On range : 5 F, 25 F, 100 F, 500 F.","order":["5 F","25 F","100 F","500 F"]}'::jsonb, 4),
    ('saisie', '{"text":"10 F + 10 F = … F","speak":"Dix francs plus dix francs égale combien de francs ?","keyboard":"number"}'::jsonb, '{"explanation":"10 F + 10 F = 20 F.","accepted":["20"]}'::jsonb, 5),
    ('vrai_faux', '{"text":"Un billet de 1 000 F vaut plus qu''une pièce de 500 F.","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"1 000 F, c''est deux fois 500 F.","correct":0}'::jsonb, 6)
) as v(t, q, a, p);

-- cp-francais-syllabes-m-l-p : Lire des syllabes : m, l, p
with ch as (
  insert into public.chapters (code, subject_id, level, title, position, content, is_published)
  select 'cp-francais-syllabes-m-l-p', s.id, 'cp'::public.school_level, 'Lire des syllabes : m, l, p',
         1, '{"blocks":[{"type":"text","value":"Les syllabes avec m : ma, me, mi, mo, mu."},{"type":"text","value":"Les syllabes avec l : la, le, li, lo, lu. Avec p : pa, pe, pi, po, pu."},{"type":"text","value":"Avec des syllabes, on fait des mots : ma + man = maman.","speak":"Avec des syllabes, on fait des mots : ma plus man égale maman."}]}'::jsonb, true
  from public.subjects s where s.slug = 'francais'
  on conflict (code) do update set
    subject_id = excluded.subject_id, level = excluded.level, title = excluded.title,
    position = excluded.position, content = excluded.content, is_published = excluded.is_published
  returning id
), del as (
  delete from public.exercises where chapter_id in (select id from ch)
)
insert into public.exercises (chapter_id, type, question, answer, position)
select ch.id, v.t::public.exercise_type, v.q::jsonb, v.a::jsonb, v.p
from ch, (values
    ('glisser_deposer', '{"text":"Remets les syllabes dans l''ordre pour écrire « maman ».","items":["man","ma"]}'::jsonb, '{"explanation":"ma + man = maman.","order":["ma","man"]}'::jsonb, 1),
    ('glisser_deposer', '{"text":"Remets les syllabes dans l''ordre pour écrire « lapin ».","items":["pin","la"]}'::jsonb, '{"explanation":"la + pin = lapin.","order":["la","pin"]}'::jsonb, 2),
    ('qcm', '{"text":"Quelle syllabe entends-tu au début de « maman » ?","options":["ma","la","pa"]}'::jsonb, '{"explanation":"maman commence par « ma ».","correct":0}'::jsonb, 3),
    ('qcm', '{"text":"Quelle syllabe entends-tu au début de « lapin » ?","options":["la","pa","ma"]}'::jsonb, '{"explanation":"lapin commence par « la ».","correct":0}'::jsonb, 4),
    ('association', '{"text":"Relie chaque dessin à son mot.","pairs":[{"left":"🐰","right":"lapin"},{"left":"🍎","right":"pomme"},{"left":"🐟","right":"poisson"}]}'::jsonb, '{"explanation":"lapin, pomme, poisson."}'::jsonb, 5),
    ('saisie', '{"text":"Écris la fin du mot « maman » : ma…","speak":"Écris la fin du mot maman. Il commence par ma. Que faut-il écrire ensuite ?","keyboard":"text"}'::jsonb, '{"explanation":"ma + man = maman.","accepted":["man"]}'::jsonb, 6)
) as v(t, q, a, p);

-- cp-francais-mots-simples : Lire des mots simples
with ch as (
  insert into public.chapters (code, subject_id, level, title, position, content, is_published)
  select 'cp-francais-mots-simples', s.id, 'cp'::public.school_level, 'Lire des mots simples',
         2, '{"blocks":[{"type":"text","value":"Un mot est fait de plusieurs lettres. On le lit syllabe par syllabe."},{"type":"text","value":"Quelques mots à lire : papa, maman, lune, chat, banane."}]}'::jsonb, true
  from public.subjects s where s.slug = 'francais'
  on conflict (code) do update set
    subject_id = excluded.subject_id, level = excluded.level, title = excluded.title,
    position = excluded.position, content = excluded.content, is_published = excluded.is_published
  returning id
), del as (
  delete from public.exercises where chapter_id in (select id from ch)
)
insert into public.exercises (chapter_id, type, question, answer, position)
select ch.id, v.t::public.exercise_type, v.q::jsonb, v.a::jsonb, v.p
from ch, (values
    ('qcm', '{"text":"Quel mot désigne ce dessin ? 🐱","speak":"Quel mot désigne ce dessin?","options":["chat","chien","chou"]}'::jsonb, '{"explanation":"Le dessin est un chat.","correct":0}'::jsonb, 1),
    ('qcm', '{"text":"Quel mot désigne ce dessin ? 🌙","speak":"Quel mot désigne ce dessin?","options":["lame","lune","lutin"]}'::jsonb, '{"explanation":"Le dessin est la lune.","correct":1}'::jsonb, 2),
    ('qcm', '{"text":"Quel mot désigne ce dessin ? 🍌","speak":"Quel mot désigne ce dessin?","options":["bateau","balle","banane"]}'::jsonb, '{"explanation":"Le dessin est une banane.","correct":2}'::jsonb, 3),
    ('saisie', '{"text":"Écris le mot de ce dessin. 🐟","speak":"Écris le mot de ce dessin.","keyboard":"text"}'::jsonb, '{"explanation":"On écrit : poisson.","accepted":["poisson"]}'::jsonb, 4),
    ('vrai_faux', '{"text":"Le mot « papa » commence par la lettre p.","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"papa commence par p.","correct":0}'::jsonb, 5),
    ('association', '{"text":"Relie chaque dessin à son mot.","pairs":[{"left":"🐱","right":"chat"},{"left":"🌙","right":"lune"},{"left":"🐟","right":"poisson"}]}'::jsonb, '{"explanation":"chat, lune, poisson."}'::jsonb, 6)
) as v(t, q, a, p);

-- cp-francais-phrase : La phrase
with ch as (
  insert into public.chapters (code, subject_id, level, title, position, content, is_published)
  select 'cp-francais-phrase', s.id, 'cp'::public.school_level, 'La phrase',
         3, '{"blocks":[{"type":"text","value":"Une phrase commence par une majuscule et finit par un point."},{"type":"text","value":"Exemple : Maman prépare le repas."}]}'::jsonb, true
  from public.subjects s where s.slug = 'francais'
  on conflict (code) do update set
    subject_id = excluded.subject_id, level = excluded.level, title = excluded.title,
    position = excluded.position, content = excluded.content, is_published = excluded.is_published
  returning id
), del as (
  delete from public.exercises where chapter_id in (select id from ch)
)
insert into public.exercises (chapter_id, type, question, answer, position)
select ch.id, v.t::public.exercise_type, v.q::jsonb, v.a::jsonb, v.p
from ch, (values
    ('qcm', '{"text":"Par quoi commence une phrase ?","options":["une majuscule","un point","une virgule"]}'::jsonb, '{"explanation":"Une phrase commence par une majuscule.","correct":0}'::jsonb, 1),
    ('qcm', '{"text":"Par quoi finit une phrase ?","options":["une majuscule","un tiret","un point"]}'::jsonb, '{"explanation":"Une phrase finit par un point.","correct":2}'::jsonb, 2),
    ('qcm', '{"text":"Quelle phrase est bien écrite ?","speak":"Quelle phrase est bien écrite ? Regarde la majuscule et le point.","options":["papa travaille.","Papa travaille.","Papa travaille"]}'::jsonb, '{"explanation":"Il y a une majuscule au début et un point à la fin.","correct":1}'::jsonb, 3),
    ('glisser_deposer', '{"text":"Remets les mots dans l''ordre pour faire une phrase.","items":["chat","Le","dort."]}'::jsonb, '{"explanation":"Le chat dort.","order":["Le","chat","dort."]}'::jsonb, 4),
    ('glisser_deposer', '{"text":"Remets les mots dans l''ordre pour faire une phrase.","items":["prépare","Maman","repas.","le"]}'::jsonb, '{"explanation":"Maman prépare le repas.","order":["Maman","prépare","le","repas."]}'::jsonb, 5),
    ('vrai_faux', '{"text":"Une phrase commence par une petite lettre.","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"Une phrase commence par une majuscule.","correct":1}'::jsonb, 6)
) as v(t, q, a, p);

-- cp-francais-le-la-un-une : Le, la, un, une
with ch as (
  insert into public.chapters (code, subject_id, level, title, position, content, is_published)
  select 'cp-francais-le-la-un-une', s.id, 'cp'::public.school_level, 'Le, la, un, une',
         4, '{"blocks":[{"type":"text","value":"On dit : le garçon, la fille. Un chat, une maison."},{"type":"text","value":"« Le » et « un » vont avec les noms masculins. « La » et « une » vont avec les noms féminins."}]}'::jsonb, true
  from public.subjects s where s.slug = 'francais'
  on conflict (code) do update set
    subject_id = excluded.subject_id, level = excluded.level, title = excluded.title,
    position = excluded.position, content = excluded.content, is_published = excluded.is_published
  returning id
), del as (
  delete from public.exercises where chapter_id in (select id from ch)
)
insert into public.exercises (chapter_id, type, question, answer, position)
select ch.id, v.t::public.exercise_type, v.q::jsonb, v.a::jsonb, v.p
from ch, (values
    ('qcm', '{"text":"Complète : … maison","speak":"Quel mot va devant maison : le, la ou un ?","options":["la","un","le"]}'::jsonb, '{"explanation":"On dit : la maison.","correct":0}'::jsonb, 1),
    ('qcm', '{"text":"Complète : … garçon","speak":"Quel mot va devant garçon : le, la ou une ?","options":["une","le","la"]}'::jsonb, '{"explanation":"On dit : le garçon.","correct":1}'::jsonb, 2),
    ('qcm', '{"text":"Complète : … chaise","speak":"Quel mot va devant chaise : une, un ou le ?","options":["un","une","le"]}'::jsonb, '{"explanation":"On dit : une chaise.","correct":1}'::jsonb, 3),
    ('qcm', '{"text":"Complète : … oiseau","speak":"Quel mot va devant oiseau : un, une ou la ?","options":["la","un","une"]}'::jsonb, '{"explanation":"On dit : un oiseau.","correct":1}'::jsonb, 4),
    ('vrai_faux', '{"text":"On dit « une garçon ».","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"On dit : un garçon.","correct":1}'::jsonb, 5),
    ('vrai_faux', '{"text":"On dit « la fille ».","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"On dit : la fille.","correct":0}'::jsonb, 6)
) as v(t, q, a, p);

-- cp-anglais-my-name-is : Se présenter : My name is…
with ch as (
  insert into public.chapters (code, subject_id, level, title, position, content, is_published)
  select 'cp-anglais-my-name-is', s.id, 'cp'::public.school_level, 'Se présenter : My name is…',
         1, '{"blocks":[{"type":"text","value":"Hello ! My name is Awa.","lang":"en-US"},{"type":"text","value":"My name is Awa veut dire : je m''appelle Awa."},{"type":"text","value":"What is your name ?","lang":"en-US"},{"type":"text","value":"What is your name ? veut dire : comment t''appelles-tu ?"}]}'::jsonb, true
  from public.subjects s where s.slug = 'anglais'
  on conflict (code) do update set
    subject_id = excluded.subject_id, level = excluded.level, title = excluded.title,
    position = excluded.position, content = excluded.content, is_published = excluded.is_published
  returning id
), del as (
  delete from public.exercises where chapter_id in (select id from ch)
)
insert into public.exercises (chapter_id, type, question, answer, position)
select ch.id, v.t::public.exercise_type, v.q::jsonb, v.a::jsonb, v.p
from ch, (values
    ('qcm', '{"text":"Comment dit-on « Je m''appelle Paul » en anglais ?","options":["Your name is Paul.","His name is Paul.","My name is Paul."]}'::jsonb, '{"explanation":"Je m''appelle Paul : My name is Paul.","correct":2}'::jsonb, 1),
    ('qcm', '{"text":"Que veut dire « What is your name ? »","options":["Où habites-tu ?","Comment t''appelles-tu ?","Quel âge as-tu ?"]}'::jsonb, '{"explanation":"What is your name ? veut dire : comment t''appelles-tu ?","correct":1}'::jsonb, 2),
    ('vrai_faux', '{"text":"« My name is Awa » veut dire « Je m''appelle Awa ».","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"My name is… veut dire : je m''appelle…","correct":0}'::jsonb, 3),
    ('glisser_deposer', '{"text":"Remets les mots dans l''ordre.","items":["Awa.","name","My","is"]}'::jsonb, '{"explanation":"My name is Awa.","order":["My","name","is","Awa."]}'::jsonb, 4),
    ('association', '{"text":"Relie chaque mot anglais à son sens en français.","pairs":[{"left":"Hello","right":"bonjour"},{"left":"Goodbye","right":"au revoir"},{"left":"Thank you","right":"merci"},{"left":"Please","right":"s''il te plaît"}]}'::jsonb, '{"explanation":"Hello, Goodbye, Thank you, Please."}'::jsonb, 5)
) as v(t, q, a, p);

-- cp-anglais-nombres-1-10 : Les nombres de 1 à 10 en anglais
with ch as (
  insert into public.chapters (code, subject_id, level, title, position, content, is_published)
  select 'cp-anglais-nombres-1-10', s.id, 'cp'::public.school_level, 'Les nombres de 1 à 10 en anglais',
         2, '{"blocks":[{"type":"text","value":"One, two, three, four, five, six, seven, eight, nine, ten.","lang":"en-US"},{"type":"text","value":"Six veut dire six, seven veut dire sept, eight veut dire huit, nine veut dire neuf, ten veut dire dix."}]}'::jsonb, true
  from public.subjects s where s.slug = 'anglais'
  on conflict (code) do update set
    subject_id = excluded.subject_id, level = excluded.level, title = excluded.title,
    position = excluded.position, content = excluded.content, is_published = excluded.is_published
  returning id
), del as (
  delete from public.exercises where chapter_id in (select id from ch)
)
insert into public.exercises (chapter_id, type, question, answer, position)
select ch.id, v.t::public.exercise_type, v.q::jsonb, v.a::jsonb, v.p
from ch, (values
    ('qcm', '{"text":"Comment dit-on « sept » en anglais ?","options":["eight","seven","six"]}'::jsonb, '{"explanation":"Sept se dit seven.","correct":1}'::jsonb, 1),
    ('qcm', '{"text":"Que veut dire « ten » ?","options":["dix","neuf","huit"]}'::jsonb, '{"explanation":"Ten veut dire dix.","correct":0}'::jsonb, 2),
    ('association', '{"text":"Relie chaque nombre anglais à son chiffre.","pairs":[{"left":"six","right":"6"},{"left":"seven","right":"7"},{"left":"eight","right":"8"},{"left":"nine","right":"9"},{"left":"ten","right":"10"}]}'::jsonb, '{"explanation":"six 6, seven 7, eight 8, nine 9, ten 10."}'::jsonb, 3),
    ('glisser_deposer', '{"text":"Range les nombres dans l''ordre.","items":["eight","ten","nine","seven"]}'::jsonb, '{"explanation":"seven, eight, nine, ten.","order":["seven","eight","nine","ten"]}'::jsonb, 4),
    ('saisie', '{"text":"Écris le chiffre de « nine ».","keyboard":"number"}'::jsonb, '{"explanation":"Nine veut dire neuf : 9.","accepted":["9"]}'::jsonb, 5),
    ('vrai_faux', '{"text":"« Eight » veut dire huit.","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"Eight veut dire huit.","correct":0}'::jsonb, 6)
) as v(t, q, a, p);

-- cp-anglais-fruits : Les fruits en anglais
with ch as (
  insert into public.chapters (code, subject_id, level, title, position, content, is_published)
  select 'cp-anglais-fruits', s.id, 'cp'::public.school_level, 'Les fruits en anglais',
         3, '{"blocks":[{"type":"text","value":"🍎 apple, 🍌 banana, 🍊 orange, 🍍 pineapple, 🍇 grapes.","lang":"en-US","speak":"apple, banana, orange, pineapple, grapes."},{"type":"text","value":"Apple veut dire pomme. Banana veut dire banane. Pineapple veut dire ananas. Grapes veut dire raisins."}]}'::jsonb, true
  from public.subjects s where s.slug = 'anglais'
  on conflict (code) do update set
    subject_id = excluded.subject_id, level = excluded.level, title = excluded.title,
    position = excluded.position, content = excluded.content, is_published = excluded.is_published
  returning id
), del as (
  delete from public.exercises where chapter_id in (select id from ch)
)
insert into public.exercises (chapter_id, type, question, answer, position)
select ch.id, v.t::public.exercise_type, v.q::jsonb, v.a::jsonb, v.p
from ch, (values
    ('association', '{"text":"Relie chaque fruit à son nom anglais.","pairs":[{"left":"🍎","right":"apple"},{"left":"🍌","right":"banana"},{"left":"🍊","right":"orange"},{"left":"🍍","right":"pineapple"}]}'::jsonb, '{"explanation":"apple, banana, orange, pineapple."}'::jsonb, 1),
    ('qcm', '{"text":"Comment dit-on « banane » en anglais ?","options":["apple","banana","orange"]}'::jsonb, '{"explanation":"Banane se dit banana.","correct":1}'::jsonb, 2),
    ('qcm', '{"text":"Quel fruit est « pineapple » ?","options":["🍇","🍍","🍎"]}'::jsonb, '{"explanation":"Pineapple veut dire ananas : 🍍.","correct":1}'::jsonb, 3),
    ('saisie', '{"text":"Écris en anglais : pomme","keyboard":"text"}'::jsonb, '{"explanation":"Pomme se dit apple.","accepted":["apple"]}'::jsonb, 4),
    ('vrai_faux', '{"text":"« Apple » veut dire pomme.","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"Apple veut dire pomme.","correct":0}'::jsonb, 5)
) as v(t, q, a, p);

-- cp-anglais-classe : Les objets de la classe en anglais
with ch as (
  insert into public.chapters (code, subject_id, level, title, position, content, is_published)
  select 'cp-anglais-classe', s.id, 'cp'::public.school_level, 'Les objets de la classe en anglais',
         4, '{"blocks":[{"type":"text","value":"📖 book, ✏️ pencil, 🎒 bag, 📏 ruler.","lang":"en-US","speak":"book, pencil, bag, ruler."},{"type":"text","value":"Book veut dire livre. Pencil veut dire crayon. Bag veut dire sac. Ruler veut dire règle."}]}'::jsonb, true
  from public.subjects s where s.slug = 'anglais'
  on conflict (code) do update set
    subject_id = excluded.subject_id, level = excluded.level, title = excluded.title,
    position = excluded.position, content = excluded.content, is_published = excluded.is_published
  returning id
), del as (
  delete from public.exercises where chapter_id in (select id from ch)
)
insert into public.exercises (chapter_id, type, question, answer, position)
select ch.id, v.t::public.exercise_type, v.q::jsonb, v.a::jsonb, v.p
from ch, (values
    ('association', '{"text":"Relie chaque objet à son nom anglais.","pairs":[{"left":"📖","right":"book"},{"left":"✏️","right":"pencil"},{"left":"🎒","right":"bag"},{"left":"📏","right":"ruler"}]}'::jsonb, '{"explanation":"book, pencil, bag, ruler."}'::jsonb, 1),
    ('qcm', '{"text":"Comment dit-on « livre » en anglais ?","options":["bag","ruler","book"]}'::jsonb, '{"explanation":"Livre se dit book.","correct":2}'::jsonb, 2),
    ('qcm', '{"text":"Que veut dire « pencil » ?","options":["sac","règle","crayon"]}'::jsonb, '{"explanation":"Pencil veut dire crayon.","correct":2}'::jsonb, 3),
    ('vrai_faux', '{"text":"« Bag » veut dire sac.","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"Bag veut dire sac.","correct":0}'::jsonb, 4),
    ('saisie', '{"text":"Écris en anglais : règle","keyboard":"text"}'::jsonb, '{"explanation":"Règle se dit ruler.","accepted":["ruler"]}'::jsonb, 5)
) as v(t, q, a, p);

-- cp-sciences-cinq-sens : Les cinq sens et leurs organes
with ch as (
  insert into public.chapters (code, subject_id, level, title, position, content, is_published)
  select 'cp-sciences-cinq-sens', s.id, 'cp'::public.school_level, 'Les cinq sens et leurs organes',
         1, '{"blocks":[{"type":"text","value":"La vue, c''est voir avec les yeux. L''ouïe, c''est entendre avec les oreilles."},{"type":"text","value":"L''odorat, c''est sentir avec le nez. Le goût, c''est goûter avec la langue. Le toucher, c''est toucher avec la peau."}]}'::jsonb, true
  from public.subjects s where s.slug = 'sciences'
  on conflict (code) do update set
    subject_id = excluded.subject_id, level = excluded.level, title = excluded.title,
    position = excluded.position, content = excluded.content, is_published = excluded.is_published
  returning id
), del as (
  delete from public.exercises where chapter_id in (select id from ch)
)
insert into public.exercises (chapter_id, type, question, answer, position)
select ch.id, v.t::public.exercise_type, v.q::jsonb, v.a::jsonb, v.p
from ch, (values
    ('association', '{"text":"Relie chaque sens à son organe.","pairs":[{"left":"la vue","right":"les yeux"},{"left":"l''ouïe","right":"les oreilles"},{"left":"l''odorat","right":"le nez"},{"left":"le goût","right":"la langue"},{"left":"le toucher","right":"la peau"}]}'::jsonb, '{"explanation":"Chaque sens a son organe."}'::jsonb, 1),
    ('qcm', '{"text":"Quel sens utilise-t-on pour reconnaître le bruit d''un tambour ?","options":["l''ouïe","le goût","la vue"]}'::jsonb, '{"explanation":"On entend le tambour avec les oreilles : c''est l''ouïe.","correct":0}'::jsonb, 2),
    ('qcm', '{"text":"Avec quel sens sent-on que l''eau est froide ?","options":["la vue","l''odorat","le toucher"]}'::jsonb, '{"explanation":"On sent le froid avec la peau : c''est le toucher.","correct":2}'::jsonb, 3),
    ('qcm', '{"text":"Quel sens utilise-t-on pour goûter une mangue ?","options":["le goût","l''ouïe","la vue"]}'::jsonb, '{"explanation":"On goûte avec la langue : c''est le goût.","correct":0}'::jsonb, 4),
    ('vrai_faux', '{"text":"Le nez sert à sentir les odeurs.","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"Le nez sert à sentir : c''est l''odorat.","correct":0}'::jsonb, 5)
) as v(t, q, a, p);

-- cp-sciences-animaux-domestiques-sauvages : Animaux domestiques et animaux sauvages
with ch as (
  insert into public.chapters (code, subject_id, level, title, position, content, is_published)
  select 'cp-sciences-animaux-domestiques-sauvages', s.id, 'cp'::public.school_level, 'Animaux domestiques et animaux sauvages',
         2, '{"blocks":[{"type":"text","value":"Les animaux domestiques vivent près des hommes : le chien, le chat, la poule, la chèvre, le mouton."},{"type":"text","value":"Les animaux sauvages vivent dans la nature : l''éléphant, le singe, le lion, le serpent."}]}'::jsonb, true
  from public.subjects s where s.slug = 'sciences'
  on conflict (code) do update set
    subject_id = excluded.subject_id, level = excluded.level, title = excluded.title,
    position = excluded.position, content = excluded.content, is_published = excluded.is_published
  returning id
), del as (
  delete from public.exercises where chapter_id in (select id from ch)
)
insert into public.exercises (chapter_id, type, question, answer, position)
select ch.id, v.t::public.exercise_type, v.q::jsonb, v.a::jsonb, v.p
from ch, (values
    ('qcm', '{"text":"Quel animal est domestique ?","options":["le serpent","l''éléphant","la poule"]}'::jsonb, '{"explanation":"La poule vit près des hommes.","correct":2}'::jsonb, 1),
    ('qcm', '{"text":"Quel animal est sauvage ?","options":["le mouton","le singe","le chat"]}'::jsonb, '{"explanation":"Le singe vit dans la nature.","correct":1}'::jsonb, 2),
    ('association', '{"text":"Relie chaque animal à son milieu de vie.","pairs":[{"left":"le chien","right":"à la maison"},{"left":"la chèvre","right":"au village"},{"left":"l''éléphant","right":"dans la forêt"},{"left":"le poisson","right":"dans l''eau"}]}'::jsonb, '{"explanation":"Chaque animal vit dans son milieu."}'::jsonb, 3),
    ('qcm', '{"text":"Que donne la poule ?","options":["des œufs","du lait","de la laine"]}'::jsonb, '{"explanation":"La poule pond des œufs.","correct":0}'::jsonb, 4),
    ('vrai_faux', '{"text":"Un animal domestique vit près des hommes.","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"Domestique veut dire qui vit près des hommes.","correct":0}'::jsonb, 5),
    ('vrai_faux', '{"text":"Le lion est un animal domestique.","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"Le lion est un animal sauvage.","correct":1}'::jsonb, 6)
) as v(t, q, a, p);

-- cp-sciences-parties-plante : Les parties d'une plante
with ch as (
  insert into public.chapters (code, subject_id, level, title, position, content, is_published)
  select 'cp-sciences-parties-plante', s.id, 'cp'::public.school_level, 'Les parties d''une plante',
         3, '{"blocks":[{"type":"text","value":"La racine est dans la terre : elle boit l''eau. La tige porte les feuilles et les fleurs."},{"type":"text","value":"La fleur devient un fruit. Le fruit contient les graines."}]}'::jsonb, true
  from public.subjects s where s.slug = 'sciences'
  on conflict (code) do update set
    subject_id = excluded.subject_id, level = excluded.level, title = excluded.title,
    position = excluded.position, content = excluded.content, is_published = excluded.is_published
  returning id
), del as (
  delete from public.exercises where chapter_id in (select id from ch)
)
insert into public.exercises (chapter_id, type, question, answer, position)
select ch.id, v.t::public.exercise_type, v.q::jsonb, v.a::jsonb, v.p
from ch, (values
    ('qcm', '{"text":"Quelle partie de la plante est dans la terre ?","options":["la fleur","la racine","la feuille"]}'::jsonb, '{"explanation":"La racine est dans la terre.","correct":1}'::jsonb, 1),
    ('qcm', '{"text":"Quelle partie porte les feuilles ?","options":["la tige","la racine","le fruit"]}'::jsonb, '{"explanation":"La tige porte les feuilles et les fleurs.","correct":0}'::jsonb, 2),
    ('association', '{"text":"Relie chaque partie à son rôle.","pairs":[{"left":"la racine","right":"boit l''eau"},{"left":"la tige","right":"porte les feuilles"},{"left":"la fleur","right":"devient un fruit"},{"left":"le fruit","right":"contient les graines"}]}'::jsonb, '{"explanation":"Chaque partie de la plante a son rôle."}'::jsonb, 3),
    ('vrai_faux', '{"text":"Le fruit contient les graines.","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"Dans le fruit, il y a les graines.","correct":0}'::jsonb, 4),
    ('vrai_faux', '{"text":"Les racines sont au-dessus de la terre.","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"Les racines sont dans la terre.","correct":1}'::jsonb, 5),
    ('glisser_deposer', '{"text":"Range les parties de la plante, de la terre vers le haut.","items":["la feuille","la racine","la tige"]}'::jsonb, '{"explanation":"La racine est en bas, la feuille en haut.","order":["la racine","la tige","la feuille"]}'::jsonb, 6)
) as v(t, q, a, p);

-- cp-sciences-hygiene : L'hygiène : se laver les mains
with ch as (
  insert into public.chapters (code, subject_id, level, title, position, content, is_published)
  select 'cp-sciences-hygiene', s.id, 'cp'::public.school_level, 'L''hygiène : se laver les mains',
         4, '{"blocks":[{"type":"text","value":"On se lave les mains avec de l''eau et du savon."},{"type":"text","value":"On se lave les mains avant de manger et après les toilettes."},{"type":"text","value":"On se brosse les dents le matin et le soir."}]}'::jsonb, true
  from public.subjects s where s.slug = 'sciences'
  on conflict (code) do update set
    subject_id = excluded.subject_id, level = excluded.level, title = excluded.title,
    position = excluded.position, content = excluded.content, is_published = excluded.is_published
  returning id
), del as (
  delete from public.exercises where chapter_id in (select id from ch)
)
insert into public.exercises (chapter_id, type, question, answer, position)
select ch.id, v.t::public.exercise_type, v.q::jsonb, v.a::jsonb, v.p
from ch, (values
    ('qcm', '{"text":"Avec quoi se lave-t-on les mains ?","options":["de l''eau et du savon","du sable","de l''huile"]}'::jsonb, '{"explanation":"On utilise de l''eau propre et du savon.","correct":0}'::jsonb, 1),
    ('qcm', '{"text":"Quand se lave-t-on les mains ?","options":["seulement le dimanche","avant de manger et après les toilettes","jamais"]}'::jsonb, '{"explanation":"Se laver les mains évite de tomber malade.","correct":1}'::jsonb, 2),
    ('qcm', '{"text":"Que fait le savon ?","options":["il donne faim","il fait dormir","il enlève la saleté et les microbes"]}'::jsonb, '{"explanation":"Le savon nettoie les mains.","correct":2}'::jsonb, 3),
    ('glisser_deposer', '{"text":"Remets les gestes dans l''ordre pour se laver les mains.","items":["Mouiller les mains","Rincer à l''eau","Mettre du savon","Frotter les mains"]}'::jsonb, '{"explanation":"On mouille, on savonne, on frotte, on rince.","order":["Mouiller les mains","Mettre du savon","Frotter les mains","Rincer à l''eau"]}'::jsonb, 4),
    ('vrai_faux', '{"text":"Il faut se brosser les dents le matin et le soir.","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"On se brosse les dents deux fois par jour.","correct":0}'::jsonb, 5),
    ('vrai_faux', '{"text":"On peut boire l''eau sale d''une flaque.","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"L''eau sale rend malade. On boit de l''eau propre.","correct":1}'::jsonb, 6)
) as v(t, q, a, p);

-- cp-informatique-parties-ordinateur : Les parties de l'ordinateur
with ch as (
  insert into public.chapters (code, subject_id, level, title, position, content, is_published)
  select 'cp-informatique-parties-ordinateur', s.id, 'cp'::public.school_level, 'Les parties de l''ordinateur',
         1, '{"blocks":[{"type":"text","value":"L''écran 🖥️ montre les images et les textes.","speak":"L''écran montre les images et les textes."},{"type":"text","value":"Le clavier ⌨️ sert à écrire. La souris 🖱️ sert à déplacer la flèche.","speak":"Le clavier sert à écrire. La souris sert à déplacer la flèche."},{"type":"text","value":"L''unité centrale est le boîtier : c''est le cerveau de l''ordinateur."}]}'::jsonb, true
  from public.subjects s where s.slug = 'informatique'
  on conflict (code) do update set
    subject_id = excluded.subject_id, level = excluded.level, title = excluded.title,
    position = excluded.position, content = excluded.content, is_published = excluded.is_published
  returning id
), del as (
  delete from public.exercises where chapter_id in (select id from ch)
)
insert into public.exercises (chapter_id, type, question, answer, position)
select ch.id, v.t::public.exercise_type, v.q::jsonb, v.a::jsonb, v.p
from ch, (values
    ('association', '{"text":"Relie chaque partie de l''ordinateur à son rôle.","pairs":[{"left":"l''écran","right":"montrer les images"},{"left":"le clavier","right":"écrire"},{"left":"la souris","right":"déplacer la flèche"}]}'::jsonb, '{"explanation":"L''écran montre, le clavier écrit, la souris déplace la flèche."}'::jsonb, 1),
    ('qcm', '{"text":"Quelle partie sert à écrire ?","options":["l''écran","la souris","le clavier"]}'::jsonb, '{"explanation":"On écrit avec le clavier.","correct":2}'::jsonb, 2),
    ('qcm', '{"text":"Quelle partie montre les images ?","options":["l''écran","la souris","le clavier"]}'::jsonb, '{"explanation":"L''écran montre les images.","correct":0}'::jsonb, 3),
    ('qcm', '{"text":"Comment s''appelle le boîtier de l''ordinateur ?","options":["l''unité centrale","la souris","l''écran"]}'::jsonb, '{"explanation":"Le boîtier s''appelle l''unité centrale.","correct":0}'::jsonb, 4),
    ('vrai_faux', '{"text":"La souris sert à déplacer la flèche sur l''écran.","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"On bouge la souris pour déplacer la flèche.","correct":0}'::jsonb, 5)
) as v(t, q, a, p);

-- cp-informatique-allumer-eteindre : Allumer et éteindre l'ordinateur
with ch as (
  insert into public.chapters (code, subject_id, level, title, position, content, is_published)
  select 'cp-informatique-allumer-eteindre', s.id, 'cp'::public.school_level, 'Allumer et éteindre l''ordinateur',
         2, '{"blocks":[{"type":"text","value":"Pour allumer l''ordinateur, on appuie sur le bouton marche."},{"type":"text","value":"Pour l''éteindre, on ferme les programmes, puis on choisit « Arrêter » dans le menu."},{"type":"text","value":"On ne coupe jamais le courant d''un coup."}]}'::jsonb, true
  from public.subjects s where s.slug = 'informatique'
  on conflict (code) do update set
    subject_id = excluded.subject_id, level = excluded.level, title = excluded.title,
    position = excluded.position, content = excluded.content, is_published = excluded.is_published
  returning id
), del as (
  delete from public.exercises where chapter_id in (select id from ch)
)
insert into public.exercises (chapter_id, type, question, answer, position)
select ch.id, v.t::public.exercise_type, v.q::jsonb, v.a::jsonb, v.p
from ch, (values
    ('qcm', '{"text":"Comment allume-t-on l''ordinateur ?","options":["en le secouant","avec le bouton marche","avec la souris seulement"]}'::jsonb, '{"explanation":"On appuie sur le bouton marche.","correct":1}'::jsonb, 1),
    ('glisser_deposer', '{"text":"Remets les gestes dans l''ordre pour éteindre l''ordinateur.","items":["Ouvrir le menu","Fermer les programmes","Choisir Arrêter"]}'::jsonb, '{"explanation":"On ferme, on ouvre le menu, on choisit Arrêter.","order":["Fermer les programmes","Ouvrir le menu","Choisir Arrêter"]}'::jsonb, 2),
    ('vrai_faux', '{"text":"Pour éteindre l''ordinateur, on débranche le courant d''un coup.","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"On l''éteint avec le menu, sans débrancher.","correct":1}'::jsonb, 3),
    ('vrai_faux', '{"text":"On appuie sur le bouton marche pour allumer l''ordinateur.","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"Le bouton marche allume l''ordinateur.","correct":0}'::jsonb, 4)
) as v(t, q, a, p);

-- cp-informatique-souris-clavier : La souris et le clavier
with ch as (
  insert into public.chapters (code, subject_id, level, title, position, content, is_published)
  select 'cp-informatique-souris-clavier', s.id, 'cp'::public.school_level, 'La souris et le clavier',
         3, '{"blocks":[{"type":"text","value":"Avec la souris, on fait un clic pour choisir et un double-clic pour ouvrir."},{"type":"text","value":"Sur le clavier, il y a des lettres, des chiffres et la grande barre d''espace."},{"type":"text","value":"La touche Entrée sert à aller à la ligne."}]}'::jsonb, true
  from public.subjects s where s.slug = 'informatique'
  on conflict (code) do update set
    subject_id = excluded.subject_id, level = excluded.level, title = excluded.title,
    position = excluded.position, content = excluded.content, is_published = excluded.is_published
  returning id
), del as (
  delete from public.exercises where chapter_id in (select id from ch)
)
insert into public.exercises (chapter_id, type, question, answer, position)
select ch.id, v.t::public.exercise_type, v.q::jsonb, v.a::jsonb, v.p
from ch, (values
    ('qcm', '{"text":"Que fait la barre d''espace ?","options":["elle sépare les mots","elle éteint l''ordinateur","elle efface l''écran"]}'::jsonb, '{"explanation":"La barre d''espace laisse un espace entre les mots.","correct":0}'::jsonb, 1),
    ('qcm', '{"text":"Que fait un double-clic sur un dossier ?","options":["il l''ouvre","il fait du bruit","il éteint l''écran"]}'::jsonb, '{"explanation":"Un double-clic ouvre le dossier.","correct":0}'::jsonb, 2),
    ('vrai_faux', '{"text":"Le clavier a des lettres et des chiffres.","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"Il y a des lettres et des chiffres sur le clavier.","correct":0}'::jsonb, 3),
    ('association', '{"text":"Relie chaque touche à son rôle.","pairs":[{"left":"la barre d''espace","right":"séparer les mots"},{"left":"la touche Entrée","right":"aller à la ligne"}]}'::jsonb, '{"explanation":"Espace sépare les mots, Entrée va à la ligne."}'::jsonb, 4)
) as v(t, q, a, p);


