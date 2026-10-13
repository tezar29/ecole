-- Contenu SIL — généré par tools/build_content.py (ne pas modifier à la main)
-- À coller dans Supabase > SQL Editor. Peut être relancé sans risque.

-- sil-maths-chiffres-0-5 : Les chiffres de 0 à 5
with ch as (
  insert into public.chapters (code, subject_id, level, title, position, content, is_published)
  select 'sil-maths-chiffres-0-5', s.id, 'sil'::public.school_level, 'Les chiffres de 0 à 5',
         1, '{"blocks":[{"type":"text","value":"Voici les chiffres : 0, 1, 2, 3, 4, 5.","speak":"Voici les chiffres: 0, 1, 2, 3, 4, 5."},{"type":"text","value":"1 🍎  Un, c''est une seule pomme.","speak":"Un, c''est une seule pomme."},{"type":"text","value":"2 🍎🍎  Deux, c''est une paire.","speak":"Deux, c''est une paire."},{"type":"text","value":"3 🍎🍎🍎  Trois.","speak":"Trois pommes."},{"type":"text","value":"4 🍎🍎🍎🍎  Quatre.","speak":"Quatre pommes."},{"type":"text","value":"5 🍎🍎🍎🍎🍎  Cinq.","speak":"Cinq pommes."},{"type":"text","value":"0  Zéro, c''est quand il n''y a rien du tout.","speak":"Zéro, c''est quand il n''y a rien du tout."}]}'::jsonb, true
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
    ('qcm', '{"text":"Combien y a-t-il de bananes ? 🍌🍌🍌","speak":"Combien y a-t-il de bananes?","options":["3","2","4"]}'::jsonb, '{"explanation":"Il y a 3 bananes : 1, 2, 3.","correct":0}'::jsonb, 1),
    ('qcm', '{"text":"Combien y a-t-il d''ananas ? 🍍🍍🍍🍍🍍","speak":"Combien y a-t-il d''ananas?","options":["3","5","4"]}'::jsonb, '{"explanation":"Il y a 5 ananas : 1, 2, 3, 4, 5.","correct":1}'::jsonb, 2),
    ('association', '{"text":"Relie chaque chiffre au bon nombre de pommes.","pairs":[{"left":"1","right":"🍎"},{"left":"2","right":"🍎🍎"},{"left":"3","right":"🍎🍎🍎"}]}'::jsonb, '{"explanation":"Le chiffre dit combien il y a de pommes."}'::jsonb, 3),
    ('glisser_deposer', '{"text":"Mets les chiffres dans l''ordre, du plus petit au plus grand.","items":["3","1","2","4"]}'::jsonb, '{"explanation":"On compte : 1, 2, 3, 4.","order":["1","2","3","4"]}'::jsonb, 4),
    ('vrai_faux', '{"text":"Zéro, c''est quand il n''y a rien du tout.","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"Zéro veut dire : il n''y en a pas.","correct":0}'::jsonb, 5),
    ('saisie', '{"text":"Combien d''oranges ? Écris le chiffre. 🍊🍊🍊🍊","speak":"Combien d''oranges? Écris le chiffre.","keyboard":"number"}'::jsonb, '{"explanation":"Il y a 4 oranges.","accepted":["4"]}'::jsonb, 6)
) as v(t, q, a, p);

-- sil-maths-chiffres-6-10 : Les chiffres de 6 à 10
with ch as (
  insert into public.chapters (code, subject_id, level, title, position, content, is_published)
  select 'sil-maths-chiffres-6-10', s.id, 'sil'::public.school_level, 'Les chiffres de 6 à 10',
         2, '{"blocks":[{"type":"text","value":"Après 5, on compte : 6, 7, 8, 9, 10.","speak":"Après 5, on compte: 6, 7, 8, 9, 10."},{"type":"text","value":"Dix, c''est comme les dix doigts de tes deux mains ✋✋","speak":"Dix, c''est comme les dix doigts de tes deux mains"},{"type":"text","value":"Plus on avance dans les chiffres, plus il y a d''objets."}]}'::jsonb, true
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
    ('qcm', '{"text":"Quel chiffre vient après 6 ?","speak":"Quel chiffre vient après 6?","options":["5","8","7"]}'::jsonb, '{"explanation":"On compte : 5, 6, 7.","correct":2}'::jsonb, 1),
    ('qcm', '{"text":"Combien de doigts as-tu sur tes deux mains ?","speak":"Combien de doigts as-tu sur tes deux mains?","options":["10","5","8"]}'::jsonb, '{"explanation":"5 doigts et 5 doigts, ça fait 10 doigts.","correct":0}'::jsonb, 2),
    ('qcm', '{"text":"Combien y a-t-il de raisins ? 🍇🍇🍇🍇🍇🍇🍇🍇","speak":"Combien y a-t-il de raisins?","options":["7","8","9"]}'::jsonb, '{"explanation":"Il y a 8 raisins.","correct":1}'::jsonb, 3),
    ('glisser_deposer', '{"text":"Remets les chiffres dans l''ordre.","items":["7","8","9","10","6"]}'::jsonb, '{"explanation":"On compte : 6, 7, 8, 9, 10.","order":["6","7","8","9","10"]}'::jsonb, 4),
    ('saisie', '{"text":"Quel chiffre vient juste avant 10 ? Écris-le.","speak":"Quel chiffre vient juste avant 10? Écris-le.","keyboard":"number"}'::jsonb, '{"explanation":"Avant 10, il y a 9.","accepted":["9"]}'::jsonb, 5),
    ('vrai_faux', '{"text":"8 vient après 7.","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"On compte : 7, 8.","correct":0}'::jsonb, 6)
) as v(t, q, a, p);

-- sil-maths-plus-moins-autant : Plus, moins, autant
with ch as (
  insert into public.chapters (code, subject_id, level, title, position, content, is_published)
  select 'sil-maths-plus-moins-autant', s.id, 'sil'::public.school_level, 'Plus, moins, autant',
         3, '{"blocks":[{"type":"text","value":"Plus : 🍌🍌🍌🍌 est plus que 🍌🍌.","speak":"Plus. Quatre bananes, c''est plus que deux bananes."},{"type":"text","value":"Moins : 🍌🍌 est moins que 🍌🍌🍌🍌.","speak":"Moins. Deux bananes, c''est moins que quatre bananes."},{"type":"text","value":"Autant : 🍌🍌🍌 et 🍌🍌🍌, c''est autant.","speak":"Autant. Trois bananes et trois bananes, c''est autant."}]}'::jsonb, true
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
    ('qcm', '{"text":"Où y a-t-il le plus de ballons ?","speak":"Où y a-t-il le plus de ballons?","options":["⚽⚽","⚽⚽⚽⚽"]}'::jsonb, '{"explanation":"4 ballons, c''est plus que 2 ballons.","correct":1}'::jsonb, 1),
    ('qcm', '{"text":"Où y a-t-il le moins de fleurs ?","speak":"Où y a-t-il le moins de fleurs?","options":["🌸🌸","🌸🌸🌸🌸🌸"]}'::jsonb, '{"explanation":"2 fleurs, c''est moins que 5 fleurs.","correct":0}'::jsonb, 2),
    ('vrai_faux', '{"text":"4 est plus grand que 2.","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"On compte : 2, 3, 4. Donc 4 est plus grand.","correct":0}'::jsonb, 3),
    ('qcm', '{"text":"Quel nombre est le plus petit ?","speak":"Quel nombre est le plus petit?","options":["5","4","2"]}'::jsonb, '{"explanation":"2 est le plus petit des trois.","correct":2}'::jsonb, 4),
    ('qcm', '{"text":"Awa a 3 mangues et Paul a 3 mangues. Ont-ils plus, moins ou autant ?","speak":"Awa a 3 mangues et Paul a 3 mangues. Ont-ils plus, moins ou autant?","options":["Moins","Autant","Plus"]}'::jsonb, '{"explanation":"3 et 3, c''est autant.","correct":1}'::jsonb, 5)
) as v(t, q, a, p);

-- sil-maths-formes : Les formes : rond, carré, triangle
with ch as (
  insert into public.chapters (code, subject_id, level, title, position, content, is_published)
  select 'sil-maths-formes', s.id, 'sil'::public.school_level, 'Les formes : rond, carré, triangle',
         4, '{"blocks":[{"type":"text","value":"Un rond 🔴 comme le soleil.","speak":"Un rond comme le soleil."},{"type":"text","value":"Un carré ⬛ a quatre côtés pareils.","speak":"Un carré a quatre côtés pareils."},{"type":"text","value":"Un triangle 🔺 a trois côtés.","speak":"Un triangle a trois côtés."}]}'::jsonb, true
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
    ('qcm', '{"text":"Quelle forme est un rond ?","speak":"Quelle forme est un rond?","options":["⬛","🔴","🔺"]}'::jsonb, '{"explanation":"Le rond est tout rond, sans coin.","correct":1}'::jsonb, 1),
    ('qcm', '{"text":"Quelle forme est un carré ?","speak":"Quelle forme est un carré?","options":["🔴","🔺","⬛"]}'::jsonb, '{"explanation":"Le carré a quatre côtés pareils.","correct":2}'::jsonb, 2),
    ('qcm', '{"text":"Quelle forme est un triangle ?","speak":"Quelle forme est un triangle?","options":["🔺","⬛","🔴"]}'::jsonb, '{"explanation":"Le triangle a trois côtés.","correct":0}'::jsonb, 3),
    ('association', '{"text":"Relie chaque forme à son nom.","pairs":[{"left":"🔴","right":"rond"},{"left":"⬛","right":"carré"},{"left":"🔺","right":"triangle"}]}'::jsonb, '{"explanation":"Rond, carré, triangle."}'::jsonb, 4),
    ('qcm', '{"text":"Le soleil ressemble à un…","speak":"Le soleil ressemble à quelle forme ?","options":["carré","triangle","rond"]}'::jsonb, '{"explanation":"Le soleil est tout rond.","correct":2}'::jsonb, 5),
    ('vrai_faux', '{"text":"Un triangle a trois côtés.","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"Tri veut dire trois.","correct":0}'::jsonb, 6)
) as v(t, q, a, p);

-- sil-maths-se-reperer : Se repérer : dessus, dessous, devant, derrière
with ch as (
  insert into public.chapters (code, subject_id, level, title, position, content, is_published)
  select 'sil-maths-se-reperer', s.id, 'sil'::public.school_level, 'Se repérer : dessus, dessous, devant, derrière',
         5, '{"blocks":[{"type":"text","value":"Dessus, c''est sur la table. Dessous, c''est sous la table."},{"type":"text","value":"Devant, c''est en face de toi. Derrière, c''est dans ton dos."},{"type":"text","value":"Le chat 🐱 est sous la chaise : il est dessous.","speak":"Le chat est sous la chaise: il est dessous."}]}'::jsonb, true
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
    ('qcm', '{"text":"Le livre est sur la table. Le livre est…","speak":"Le livre est sur la table. Le livre est où ?","options":["dessus","dessous","derrière"]}'::jsonb, '{"explanation":"Sur la table, c''est dessus.","correct":0}'::jsonb, 1),
    ('qcm', '{"text":"Le chat est sous la chaise. Le chat est…","speak":"Le chat est sous la chaise. Le chat est où ?","options":["dessous","devant","dessus"]}'::jsonb, '{"explanation":"Sous la chaise, c''est dessous.","correct":0}'::jsonb, 2),
    ('association', '{"text":"Relie chaque expression au bon mot.","pairs":[{"left":"sur la table","right":"dessus"},{"left":"sous la table","right":"dessous"},{"left":"en face de moi","right":"devant"},{"left":"dans mon dos","right":"derrière"}]}'::jsonb, '{"explanation":"Dessus, dessous, devant, derrière."}'::jsonb, 3),
    ('qcm', '{"text":"Awa est face à la porte. Paul est dans son dos. Qui est derrière ?","speak":"Awa est face à la porte. Paul est dans son dos. Qui est derrière?","options":["Paul","Awa"]}'::jsonb, '{"explanation":"Paul est dans le dos d''Awa : il est derrière.","correct":0}'::jsonb, 4),
    ('vrai_faux', '{"text":"Derrière veut dire dans le dos.","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"Derrière, c''est dans le dos.","correct":0}'::jsonb, 5),
    ('vrai_faux', '{"text":"Le ballon est au-dessus de la table : il est dessous.","speak":"Le ballon est au-dessus de la table: il est dessous.","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"Au-dessus de la table, c''est dessus.","correct":1}'::jsonb, 6)
) as v(t, q, a, p);

-- sil-maths-suites-logiques : Les suites logiques
with ch as (
  insert into public.chapters (code, subject_id, level, title, position, content, is_published)
  select 'sil-maths-suites-logiques', s.id, 'sil'::public.school_level, 'Les suites logiques',
         6, '{"blocks":[{"type":"text","value":"Une suite, c''est un dessin qui se répète toujours de la même façon."},{"type":"text","value":"🔴 🔵 🔴 🔵 🔴 … ensuite vient 🔵.","speak":"Rond, bleu, rond, bleu, rond. Ensuite vient le bleu."},{"type":"text","value":"🍌 🍊 🍌 🍊 🍌 … ensuite vient 🍊.","speak":"Banane, orange, banane, orange, banane. Ensuite vient l''orange."}]}'::jsonb, true
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
    ('qcm', '{"text":"Quelle forme vient ensuite ? 🔴 🔺 🔴 🔺 🔴 …","speak":"Rond, triangle, rond, triangle, rond. Quelle forme vient ensuite ?","options":["⬛","🔺","🔴"]}'::jsonb, '{"explanation":"La suite alterne rond et triangle. Après le rond vient le triangle.","correct":1}'::jsonb, 1),
    ('qcm', '{"text":"Quel animal vient ensuite ? 🐱 🐶 🐱 🐶 🐱 …","speak":"Chat, chien, chat, chien, chat. Quel animal vient ensuite ?","options":["🐟","🐶","🐱"]}'::jsonb, '{"explanation":"La suite alterne chat et chien. Après le chat vient le chien.","correct":1}'::jsonb, 2),
    ('qcm', '{"text":"Quel fruit vient ensuite ? 🍌 🍌 🍊 🍌 🍌 …","speak":"Banane, banane, orange, banane, banane. Quel fruit vient ensuite ?","options":["🍊","🍎","🍌"]}'::jsonb, '{"explanation":"La suite fait deux bananes puis une orange. Ensuite vient l''orange.","correct":0}'::jsonb, 3),
    ('association', '{"text":"Relie chaque suite à ce qui vient ensuite.","pairs":[{"left":"🔴 🔴 🔵 🔴 🔴 …","right":"🔵"},{"left":"🍎 🍌 🍎 🍌 🍎 …","right":"🍌"},{"left":"⬛ 🔺 ⬛ 🔺 ⬛ …","right":"🔺"}]}'::jsonb, '{"explanation":"On regarde ce qui se répète dans la suite."}'::jsonb, 4),
    ('vrai_faux', '{"text":"Dans la suite 🔴 🔵 🔴 🔵, après le 🔴 vient le 🔵.","speak":"Dans la suite rond, bleu, rond, bleu, après le rond vient le bleu.","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"La suite alterne rond et bleu.","correct":0}'::jsonb, 5),
    ('vrai_faux', '{"text":"La suite 🔴 🔺 🔴 🔺 continue avec un ⬛.","speak":"La suite rond, triangle, rond, triangle continue-t-elle avec un carré ?","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"La suite alterne rond et triangle, pas carré.","correct":1}'::jsonb, 6)
) as v(t, q, a, p);

-- sil-francais-voyelles : Les voyelles
with ch as (
  insert into public.chapters (code, subject_id, level, title, position, content, is_published)
  select 'sil-francais-voyelles', s.id, 'sil'::public.school_level, 'Les voyelles',
         1, '{"blocks":[{"type":"text","value":"Il y a des voyelles : a, e, i, o, u.","speak":"Il y a des voyelles: a, e, i, o, u."},{"type":"text","value":"On entend « a » au début de ananas 🍍.","speak":"On entend « a » au début de ananas."},{"type":"text","value":"On entend « i » au début de igname."},{"type":"text","value":"On entend « o » au début de orange 🍊.","speak":"On entend « o » au début de orange."}]}'::jsonb, true
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
    ('qcm', '{"text":"Quelle lettre est une voyelle ?","speak":"Quelle lettre est une voyelle?","options":["a","b","m"]}'::jsonb, '{"explanation":"a, e, i, o, u sont les voyelles.","correct":0}'::jsonb, 1),
    ('qcm', '{"text":"Par quelle voyelle commence le mot « ananas » ?","speak":"Par quelle voyelle commence le mot « ananas »?","options":["i","o","a"]}'::jsonb, '{"explanation":"ananas commence par a.","correct":2}'::jsonb, 2),
    ('qcm', '{"text":"Quelle voyelle entends-tu au début de « orange » ?","speak":"Quelle voyelle entends-tu au début de « orange »?","options":["e","a","o"]}'::jsonb, '{"explanation":"orange commence par o.","correct":2}'::jsonb, 3),
    ('association', '{"text":"Relie chaque voyelle à un mot qui commence par cette lettre.","pairs":[{"left":"a","right":"ananas"},{"left":"i","right":"igname"},{"left":"o","right":"orange"},{"left":"u","right":"usine"}]}'::jsonb, '{"explanation":"ananas, igname, orange, usine."}'::jsonb, 4),
    ('vrai_faux', '{"text":"La lettre « m » est une voyelle.","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"m n''est pas une voyelle. Les voyelles sont a, e, i, o, u.","correct":1}'::jsonb, 5)
) as v(t, q, a, p);

-- sil-francais-sons-a-i-o : Écouter les sons a, i, o
with ch as (
  insert into public.chapters (code, subject_id, level, title, position, content, is_published)
  select 'sil-francais-sons-a-i-o', s.id, 'sil'::public.school_level, 'Écouter les sons a, i, o',
         2, '{"blocks":[{"type":"text","value":"Chaque mot est fait de sons. Écoute bien !","speak":"Chaque mot est fait de sons. Écoute bien!"},{"type":"text","value":"Dans « rat », on entend « a »."},{"type":"text","value":"Dans « lit », on entend « i »."},{"type":"text","value":"Dans « pot », on entend « o »."}]}'::jsonb, true
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
    ('qcm', '{"text":"Dans quel mot entends-tu le son « a » ?","speak":"Dans quel mot entends-tu le son « a »?","options":["lit","rat","pot"]}'::jsonb, '{"explanation":"Dans « rat », on entend « a ».","correct":1}'::jsonb, 1),
    ('qcm', '{"text":"Dans quel mot entends-tu le son « i » ?","speak":"Dans quel mot entends-tu le son « i »?","options":["sac","lit","mur"]}'::jsonb, '{"explanation":"Dans « lit », on entend « i ».","correct":1}'::jsonb, 2),
    ('qcm', '{"text":"Dans quel mot entends-tu le son « o » ?","speak":"Dans quel mot entends-tu le son « o »?","options":["chat","riz","pot"]}'::jsonb, '{"explanation":"Dans « pot », on entend « o ».","correct":2}'::jsonb, 3),
    ('association', '{"text":"Relie chaque dessin à son nom.","pairs":[{"left":"🐱","right":"chat"},{"left":"🐟","right":"poisson"},{"left":"🍌","right":"banane"}]}'::jsonb, '{"explanation":"chat, poisson, banane."}'::jsonb, 4),
    ('saisie', '{"text":"Écris la première lettre du mot « banane ».","keyboard":"text"}'::jsonb, '{"explanation":"banane commence par la lettre b.","accepted":["b"]}'::jsonb, 5)
) as v(t, q, a, p);

-- sil-francais-corps : Les parties du corps
with ch as (
  insert into public.chapters (code, subject_id, level, title, position, content, is_published)
  select 'sil-francais-corps', s.id, 'sil'::public.school_level, 'Les parties du corps',
         3, '{"blocks":[{"type":"text","value":"Voici ton corps : la tête, les bras, les jambes.","speak":"Voici ton corps: la tête, les bras, les jambes."},{"type":"text","value":"Sur la tête, il y a les yeux, le nez, la bouche et les oreilles."},{"type":"text","value":"Au bout des bras, il y a les mains. Au bout des jambes, il y a les pieds."}]}'::jsonb, true
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
    ('qcm', '{"text":"Avec quoi voit-on ?","speak":"Avec quoi voit-on?","options":["le nez","les oreilles","les yeux"]}'::jsonb, '{"explanation":"On voit avec les yeux.","correct":2}'::jsonb, 1),
    ('qcm', '{"text":"Avec quoi entend-on ?","speak":"Avec quoi entend-on?","options":["les yeux","la bouche","les oreilles"]}'::jsonb, '{"explanation":"On entend avec les oreilles.","correct":2}'::jsonb, 2),
    ('qcm', '{"text":"Avec quoi sent-on les odeurs ?","speak":"Avec quoi sent-on les odeurs?","options":["les pieds","les mains","le nez"]}'::jsonb, '{"explanation":"On sent les odeurs avec le nez.","correct":2}'::jsonb, 3),
    ('qcm', '{"text":"Avec quoi marche-t-on ?","speak":"Avec quoi marche-t-on?","options":["les bras","les jambes","la tête"]}'::jsonb, '{"explanation":"On marche avec les jambes.","correct":1}'::jsonb, 4),
    ('association', '{"text":"Relie chaque partie du corps à ce qu''elle fait.","pairs":[{"left":"les yeux","right":"voir"},{"left":"les oreilles","right":"entendre"},{"left":"la bouche","right":"manger"},{"left":"les mains","right":"toucher"}]}'::jsonb, '{"explanation":"Chaque partie du corps a son rôle."}'::jsonb, 5),
    ('vrai_faux', '{"text":"On a deux yeux.","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"On a deux yeux, un à gauche et un à droite.","correct":0}'::jsonb, 6)
) as v(t, q, a, p);

-- sil-francais-famille : La famille
with ch as (
  insert into public.chapters (code, subject_id, level, title, position, content, is_published)
  select 'sil-francais-famille', s.id, 'sil'::public.school_level, 'La famille',
         4, '{"blocks":[{"type":"text","value":"Dans la famille, il y a papa et maman : ce sont les parents.","speak":"Dans la famille, il y a papa et maman: ce sont les parents."},{"type":"text","value":"Le frère est un garçon. La sœur est une fille."},{"type":"text","value":"Le papa de papa ou de maman, c''est le grand-père. La maman de papa ou de maman, c''est la grand-mère."}]}'::jsonb, true
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
    ('qcm', '{"text":"Le garçon qui a les mêmes parents que moi, c''est mon…","speak":"Le garçon qui a les mêmes parents que moi, c''est mon quoi ?","options":["cousin","oncle","frère"]}'::jsonb, '{"explanation":"C''est mon frère.","correct":2}'::jsonb, 1),
    ('qcm', '{"text":"La fille qui a les mêmes parents que moi, c''est ma…","speak":"La fille qui a les mêmes parents que moi, c''est ma quoi ?","options":["sœur","voisine","tante"]}'::jsonb, '{"explanation":"C''est ma sœur.","correct":0}'::jsonb, 2),
    ('qcm', '{"text":"La maman de ma maman, c''est ma…","speak":"La maman de ma maman, c''est ma quoi ?","options":["grand-mère","tante","sœur"]}'::jsonb, '{"explanation":"C''est ma grand-mère.","correct":0}'::jsonb, 3),
    ('vrai_faux', '{"text":"Papa et maman sont mes parents.","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"Papa et maman sont les parents.","correct":0}'::jsonb, 4),
    ('glisser_deposer', '{"text":"Range de la personne la plus jeune à la plus âgée.","items":["le grand frère","le grand-père","le bébé"]}'::jsonb, '{"explanation":"Le bébé est le plus jeune, le grand-père le plus âgé.","order":["le bébé","le grand frère","le grand-père"]}'::jsonb, 5)
) as v(t, q, a, p);

-- sil-francais-mon-prenom : Mon prénom
with ch as (
  insert into public.chapters (code, subject_id, level, title, position, content, is_published)
  select 'sil-francais-mon-prenom', s.id, 'sil'::public.school_level, 'Mon prénom',
         5, '{"blocks":[{"type":"text","value":"Chacun a un prénom. C''est le nom qu''on te donne quand tu nais."},{"type":"text","value":"Quand on appelle ton prénom, tu réponds."},{"type":"text","value":"Un prénom s''écrit avec des lettres. La première lettre est une majuscule."}]}'::jsonb, true
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
    ('qcm', '{"text":"Ton prénom, c''est…","speak":"Ton prénom, c''est quoi ?","options":["ton âge","ta taille","le nom qu''on te donne"]}'::jsonb, '{"explanation":"Le prénom est le nom qu''on te donne.","correct":2}'::jsonb, 1),
    ('qcm', '{"text":"Par quoi commence un prénom écrit ?","speak":"Par quoi commence un prénom écrit?","options":["un point","un chiffre","une majuscule"]}'::jsonb, '{"explanation":"La première lettre du prénom est une majuscule.","correct":2}'::jsonb, 2),
    ('glisser_deposer', '{"text":"Remets les lettres dans l''ordre pour écrire le prénom PAUL.","items":["A","U","L","P"]}'::jsonb, '{"explanation":"On écrit P, A, U, L : cela fait PAUL.","order":["P","A","U","L"]}'::jsonb, 3),
    ('association', '{"text":"Relie chaque prénom à sa première lettre.","pairs":[{"left":"Awa","right":"A"},{"left":"Paul","right":"P"},{"left":"Ngono","right":"N"},{"left":"Marie","right":"M"}]}'::jsonb, '{"explanation":"On regarde la première lettre du prénom."}'::jsonb, 4),
    ('saisie', '{"text":"Écris la première lettre du prénom « Awa ».","keyboard":"text"}'::jsonb, '{"explanation":"Awa commence par la lettre A.","accepted":["a"]}'::jsonb, 5),
    ('vrai_faux', '{"text":"Mon prénom commence par une majuscule.","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"La première lettre d''un prénom est une majuscule.","correct":0}'::jsonb, 6)
) as v(t, q, a, p);

-- sil-francais-ecole-classe : L'école et la classe
with ch as (
  insert into public.chapters (code, subject_id, level, title, position, content, is_published)
  select 'sil-francais-ecole-classe', s.id, 'sil'::public.school_level, 'L''école et la classe',
         6, '{"blocks":[{"type":"text","value":"À l''école, on apprend à lire, à écrire et à compter."},{"type":"text","value":"Dans la classe, il y a la maîtresse ou le maître, les tables et le tableau."},{"type":"text","value":"À l''école, on lève le doigt pour parler et on range ses affaires."}]}'::jsonb, true
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
    ('qcm', '{"text":"Où va-t-on pour apprendre à lire ?","speak":"Où va-t-on pour apprendre à lire?","options":["au marché","à la rivière","à l''école"]}'::jsonb, '{"explanation":"On apprend à lire à l''école.","correct":2}'::jsonb, 1),
    ('qcm', '{"text":"Qui enseigne dans la classe ?","speak":"Qui enseigne dans la classe?","options":["le médecin","le cuisinier","la maîtresse"]}'::jsonb, '{"explanation":"La maîtresse ou le maître enseigne aux élèves.","correct":2}'::jsonb, 2),
    ('association', '{"text":"Relie chaque objet à ce qu''on en fait.","pairs":[{"left":"le crayon","right":"écrire"},{"left":"le livre","right":"lire"},{"left":"le ballon","right":"jouer"},{"left":"le cartable","right":"porter ses affaires"}]}'::jsonb, '{"explanation":"Chaque objet de l''école sert à quelque chose."}'::jsonb, 3),
    ('glisser_deposer', '{"text":"Remets les moments de la journée d''école dans l''ordre.","items":["on joue à la récréation","on travaille en classe","on arrive à l''école","on rentre à la maison"]}'::jsonb, '{"explanation":"D''abord on arrive, puis on travaille, ensuite on joue, enfin on rentre.","order":["on arrive à l''école","on travaille en classe","on joue à la récréation","on rentre à la maison"]}'::jsonb, 4),
    ('vrai_faux', '{"text":"À l''école, on lève le doigt pour parler.","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"On lève le doigt et on attend la parole.","correct":0}'::jsonb, 5),
    ('vrai_faux', '{"text":"À l''école, on court dans la classe.","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"On ne court pas dans la classe : on peut se faire mal.","correct":1}'::jsonb, 6)
) as v(t, q, a, p);

-- sil-anglais-hello : Hello ! Saluer en anglais
with ch as (
  insert into public.chapters (code, subject_id, level, title, position, content, is_published)
  select 'sil-anglais-hello', s.id, 'sil'::public.school_level, 'Hello ! Saluer en anglais',
         1, '{"blocks":[{"type":"text","value":"Hello ! Hi ! Goodbye !","lang":"en-US","speak":"Hello! Hi! Goodbye!"},{"type":"text","value":"Hello veut dire bonjour. Goodbye veut dire au revoir."},{"type":"text","value":"Thank you ! Yes ! No !","lang":"en-US","speak":"Thank you! Yes! No!"},{"type":"text","value":"Thank you veut dire merci. Yes veut dire oui. No veut dire non."}]}'::jsonb, true
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
    ('qcm', '{"text":"Comment dit-on « bonjour » en anglais ?","speak":"Comment dit-on « bonjour » en anglais?","options":["Thank you","Goodbye","Hello"]}'::jsonb, '{"explanation":"Bonjour se dit Hello.","correct":2}'::jsonb, 1),
    ('qcm', '{"text":"Que veut dire « Goodbye » ?","speak":"Que veut dire « Goodbye »?","options":["Au revoir","Merci","Bonjour"]}'::jsonb, '{"explanation":"Goodbye veut dire au revoir.","correct":0}'::jsonb, 2),
    ('association', '{"text":"Relie chaque mot anglais à son sens en français.","pairs":[{"left":"Hello","right":"bonjour"},{"left":"Goodbye","right":"au revoir"},{"left":"Thank you","right":"merci"},{"left":"Yes","right":"oui"}]}'::jsonb, '{"explanation":"Hello, Goodbye, Thank you, Yes."}'::jsonb, 3),
    ('vrai_faux', '{"text":"« Yes » veut dire oui.","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"Yes veut dire oui.","correct":0}'::jsonb, 4),
    ('saisie', '{"text":"Écris en anglais : bonjour","speak":"Écris en anglais: bonjour","keyboard":"text"}'::jsonb, '{"explanation":"Bonjour se dit Hello.","accepted":["hello"]}'::jsonb, 5)
) as v(t, q, a, p);

-- sil-anglais-couleurs : Les couleurs en anglais
with ch as (
  insert into public.chapters (code, subject_id, level, title, position, content, is_published)
  select 'sil-anglais-couleurs', s.id, 'sil'::public.school_level, 'Les couleurs en anglais',
         2, '{"blocks":[{"type":"text","value":"❤️ red","lang":"en-US","speak":"red"},{"type":"text","value":"💙 blue","lang":"en-US","speak":"blue"},{"type":"text","value":"💚 green","lang":"en-US","speak":"green"},{"type":"text","value":"💛 yellow","lang":"en-US","speak":"yellow"},{"type":"text","value":"Red veut dire rouge, blue veut dire bleu, green veut dire vert, yellow veut dire jaune."}]}'::jsonb, true
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
    ('qcm', '{"text":"Quelle couleur est « red » ?","speak":"Quelle couleur est « red »?","options":["vert","rouge","bleu"]}'::jsonb, '{"explanation":"Red veut dire rouge.","correct":1}'::jsonb, 1),
    ('qcm', '{"text":"Comment dit-on « bleu » en anglais ?","speak":"Comment dit-on « bleu » en anglais?","options":["green","blue","red"]}'::jsonb, '{"explanation":"Bleu se dit blue.","correct":1}'::jsonb, 2),
    ('qcm', '{"text":"De quelle couleur est ce cœur en anglais ? 💛","speak":"De quelle couleur est ce cœur en anglais?","options":["blue","red","yellow"]}'::jsonb, '{"explanation":"Ce cœur est jaune : yellow.","correct":2}'::jsonb, 3),
    ('association', '{"text":"Relie chaque couleur anglaise à sa couleur en français.","pairs":[{"left":"red","right":"rouge"},{"left":"blue","right":"bleu"},{"left":"green","right":"vert"},{"left":"yellow","right":"jaune"}]}'::jsonb, '{"explanation":"red, blue, green, yellow."}'::jsonb, 4),
    ('vrai_faux', '{"text":"« Green » veut dire vert.","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"Green veut dire vert.","correct":0}'::jsonb, 5)
) as v(t, q, a, p);

-- sil-anglais-nombres-1-5 : Les nombres de 1 à 5 en anglais
with ch as (
  insert into public.chapters (code, subject_id, level, title, position, content, is_published)
  select 'sil-anglais-nombres-1-5', s.id, 'sil'::public.school_level, 'Les nombres de 1 à 5 en anglais',
         3, '{"blocks":[{"type":"text","value":"One, two, three, four, five.","lang":"en-US"},{"type":"text","value":"One veut dire un. Two veut dire deux. Three veut dire trois. Four veut dire quatre. Five veut dire cinq."}]}'::jsonb, true
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
    ('qcm', '{"text":"Comment dit-on « trois » en anglais ?","speak":"Comment dit-on « trois » en anglais?","options":["three","two","four"]}'::jsonb, '{"explanation":"Trois se dit three.","correct":0}'::jsonb, 1),
    ('qcm', '{"text":"Que veut dire « five » ?","speak":"Que veut dire « five »?","options":["cinq","quatre","deux"]}'::jsonb, '{"explanation":"Five veut dire cinq.","correct":0}'::jsonb, 2),
    ('association', '{"text":"Relie chaque nombre anglais à son chiffre.","pairs":[{"left":"one","right":"1"},{"left":"two","right":"2"},{"left":"three","right":"3"},{"left":"four","right":"4"}]}'::jsonb, '{"explanation":"one 1, two 2, three 3, four 4."}'::jsonb, 3),
    ('saisie', '{"text":"Écris le chiffre de « two ».","keyboard":"number"}'::jsonb, '{"explanation":"Two veut dire deux : 2.","accepted":["2"]}'::jsonb, 4),
    ('glisser_deposer', '{"text":"Range les nombres dans l''ordre.","items":["three","one","two"]}'::jsonb, '{"explanation":"one, two, three.","order":["one","two","three"]}'::jsonb, 5),
    ('vrai_faux', '{"text":"« Four » veut dire quatre.","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"Four veut dire quatre.","correct":0}'::jsonb, 6)
) as v(t, q, a, p);

-- sil-anglais-animaux : Les animaux en anglais
with ch as (
  insert into public.chapters (code, subject_id, level, title, position, content, is_published)
  select 'sil-anglais-animaux', s.id, 'sil'::public.school_level, 'Les animaux en anglais',
         4, '{"blocks":[{"type":"text","value":"🐱 cat, 🐶 dog, 🐟 fish, 🐦 bird.","lang":"en-US","speak":"cat, dog, fish, bird."},{"type":"text","value":"Cat veut dire chat. Dog veut dire chien. Fish veut dire poisson. Bird veut dire oiseau."}]}'::jsonb, true
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
    ('qcm', '{"text":"Comment dit-on « chat » en anglais ?","speak":"Comment dit-on « chat » en anglais?","options":["dog","fish","cat"]}'::jsonb, '{"explanation":"Chat se dit cat.","correct":2}'::jsonb, 1),
    ('qcm', '{"text":"Quel animal est « dog » ?","speak":"Quel animal est « dog »?","options":["🐱","🐶","🐟"]}'::jsonb, '{"explanation":"Dog veut dire chien : 🐶.","correct":1}'::jsonb, 2),
    ('association', '{"text":"Relie chaque animal à son nom anglais.","pairs":[{"left":"🐱","right":"cat"},{"left":"🐶","right":"dog"},{"left":"🐟","right":"fish"},{"left":"🐦","right":"bird"}]}'::jsonb, '{"explanation":"cat, dog, fish, bird."}'::jsonb, 3),
    ('vrai_faux', '{"text":"« Fish » veut dire poisson.","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"Fish veut dire poisson.","correct":0}'::jsonb, 4),
    ('saisie', '{"text":"Écris en anglais : chien","speak":"Écris en anglais: chien","keyboard":"text"}'::jsonb, '{"explanation":"Chien se dit dog.","accepted":["dog"]}'::jsonb, 5)
) as v(t, q, a, p);

-- sil-anglais-fruits : Les fruits en anglais
with ch as (
  insert into public.chapters (code, subject_id, level, title, position, content, is_published)
  select 'sil-anglais-fruits', s.id, 'sil'::public.school_level, 'Les fruits en anglais',
         5, '{"blocks":[{"type":"text","value":"🍎 apple, 🍌 banana, 🍊 orange, 🍍 pineapple.","lang":"en-US","speak":"apple, banana, orange, pineapple."},{"type":"text","value":"Apple veut dire pomme. Banana veut dire banane."},{"type":"text","value":"Orange veut dire orange. Pineapple veut dire ananas."}]}'::jsonb, true
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
    ('qcm', '{"text":"Comment dit-on « banane » en anglais ?","speak":"Comment dit-on « banane » en anglais?","options":["banana","orange","apple"]}'::jsonb, '{"explanation":"Banane se dit banana.","correct":0}'::jsonb, 2),
    ('qcm', '{"text":"Que veut dire « apple » ?","speak":"Que veut dire « apple »?","options":["pomme","orange","ananas"]}'::jsonb, '{"explanation":"Apple veut dire pomme.","correct":0}'::jsonb, 3),
    ('qcm', '{"text":"Quel fruit est 🍊 ?","speak":"Quel fruit est?","options":["pineapple","banana","orange"]}'::jsonb, '{"explanation":"🍊 est une orange : orange.","correct":2}'::jsonb, 4),
    ('saisie', '{"text":"Écris en anglais : pomme","speak":"Écris en anglais: pomme","keyboard":"text"}'::jsonb, '{"explanation":"Pomme se dit apple.","accepted":["apple"]}'::jsonb, 5),
    ('vrai_faux', '{"text":"« Pineapple » veut dire ananas.","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"Pineapple veut dire ananas.","correct":0}'::jsonb, 6)
) as v(t, q, a, p);

-- sil-sciences-cinq-sens : Les cinq sens
with ch as (
  insert into public.chapters (code, subject_id, level, title, position, content, is_published)
  select 'sil-sciences-cinq-sens', s.id, 'sil'::public.school_level, 'Les cinq sens',
         1, '{"blocks":[{"type":"text","value":"Avec les yeux, on voit. Avec les oreilles, on entend. Avec le nez, on sent. Avec la langue, on goûte. Avec la peau, on touche."}]}'::jsonb, true
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
    ('qcm', '{"text":"Avec quoi goûte-t-on les aliments ?","speak":"Avec quoi goûte-t-on les aliments?","options":["la langue","les oreilles","les yeux"]}'::jsonb, '{"explanation":"On goûte avec la langue.","correct":0}'::jsonb, 1),
    ('qcm', '{"text":"Avec quoi touche-t-on ?","speak":"Avec quoi touche-t-on?","options":["les oreilles","la peau","le nez"]}'::jsonb, '{"explanation":"On touche avec la peau, surtout avec les mains.","correct":1}'::jsonb, 2),
    ('qcm', '{"text":"Tu sens une bonne odeur de beignets. Qu''utilises-tu ?","speak":"Tu sens une bonne odeur de beignets. Qu''utilises-tu?","options":["les mains","les yeux","le nez"]}'::jsonb, '{"explanation":"On sent les odeurs avec le nez.","correct":2}'::jsonb, 3),
    ('association', '{"text":"Relie chaque partie du corps à ce qu''elle permet de faire.","pairs":[{"left":"les yeux","right":"voir"},{"left":"le nez","right":"sentir"},{"left":"les oreilles","right":"entendre"},{"left":"la langue","right":"goûter"}]}'::jsonb, '{"explanation":"Chaque sens a son organe."}'::jsonb, 4),
    ('vrai_faux', '{"text":"On entend avec le nez.","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"On entend avec les oreilles.","correct":1}'::jsonb, 5)
) as v(t, q, a, p);

-- sil-sciences-jour-nuit : Le jour et la nuit
with ch as (
  insert into public.chapters (code, subject_id, level, title, position, content, is_published)
  select 'sil-sciences-jour-nuit', s.id, 'sil'::public.school_level, 'Le jour et la nuit',
         2, '{"blocks":[{"type":"text","value":"Le jour, le Soleil ☀️ éclaire la Terre. On voit bien.","speak":"Le jour, le Soleil éclaire la Terre. On voit bien."},{"type":"text","value":"La nuit, il fait noir. On voit la Lune 🌙 et les étoiles ⭐.","speak":"La nuit, il fait noir. On voit la Lune et les étoiles."},{"type":"text","value":"Le matin, on se réveille. Le soir, on va dormir."}]}'::jsonb, true
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
    ('qcm', '{"text":"Quand voit-on le Soleil ?","speak":"Quand voit-on le Soleil?","options":["le jour","la nuit"]}'::jsonb, '{"explanation":"Le Soleil éclaire la Terre le jour.","correct":0}'::jsonb, 1),
    ('qcm', '{"text":"Quand voit-on les étoiles ?","speak":"Quand voit-on les étoiles?","options":["le jour","la nuit"]}'::jsonb, '{"explanation":"La nuit, on voit la Lune et les étoiles.","correct":1}'::jsonb, 2),
    ('qcm', '{"text":"Qui éclaire la Terre le jour ?","speak":"Qui éclaire la Terre le jour?","options":["le Soleil","la Lune","un nuage"]}'::jsonb, '{"explanation":"Le Soleil éclaire la Terre.","correct":0}'::jsonb, 3),
    ('association', '{"text":"Relie chaque dessin au bon moment.","pairs":[{"left":"☀️","right":"le jour"},{"left":"🌙","right":"la nuit"}]}'::jsonb, '{"explanation":"Soleil le jour, Lune la nuit."}'::jsonb, 4),
    ('glisser_deposer', '{"text":"Range les moments de la journée dans l''ordre.","items":["le soir","le matin","le midi","la nuit"]}'::jsonb, '{"explanation":"Matin, midi, soir, nuit.","order":["le matin","le midi","le soir","la nuit"]}'::jsonb, 5),
    ('vrai_faux', '{"text":"La nuit, on dort dans son lit.","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"La nuit, on dort pour se reposer.","correct":0}'::jsonb, 6)
) as v(t, q, a, p);

-- sil-sciences-animaux : Les animaux
with ch as (
  insert into public.chapters (code, subject_id, level, title, position, content, is_published)
  select 'sil-sciences-animaux', s.id, 'sil'::public.school_level, 'Les animaux',
         3, '{"blocks":[{"type":"text","value":"Certains animaux vivent avec nous : le chat 🐱, le chien 🐶, la poule 🐔.","speak":"Certains animaux vivent avec nous: le chat, le chien, la poule."},{"type":"text","value":"D''autres animaux vivent dans la forêt : l''éléphant 🐘, le singe 🐒, le serpent 🐍.","speak":"D''autres animaux vivent dans la forêt: l''éléphant, le singe, le serpent."},{"type":"text","value":"Les animaux ont besoin de manger et de boire."}]}'::jsonb, true
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
    ('qcm', '{"text":"Quel animal vit avec nous à la maison ?","speak":"Quel animal vit avec nous à la maison?","options":["le chat","l''éléphant","le serpent"]}'::jsonb, '{"explanation":"Le chat vit avec nous.","correct":0}'::jsonb, 1),
    ('qcm', '{"text":"Quel animal vit dans la forêt ?","speak":"Quel animal vit dans la forêt?","options":["la poule","le chien","l''éléphant"]}'::jsonb, '{"explanation":"L''éléphant vit dans la nature.","correct":2}'::jsonb, 2),
    ('association', '{"text":"Relie chaque dessin à son nom.","pairs":[{"left":"🐱","right":"chat"},{"left":"🐘","right":"éléphant"},{"left":"🐒","right":"singe"},{"left":"🐔","right":"poule"}]}'::jsonb, '{"explanation":"chat, éléphant, singe, poule."}'::jsonb, 3),
    ('vrai_faux', '{"text":"Les animaux ont besoin de manger et de boire.","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"Comme nous, les animaux ont faim et soif.","correct":0}'::jsonb, 4),
    ('vrai_faux', '{"text":"Le serpent vit dans la maison avec nous.","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"Le serpent vit dans la nature.","correct":1}'::jsonb, 5),
    ('saisie', '{"text":"Écris le nom de cet animal. 🐘","speak":"Écris le nom de cet animal.","keyboard":"text"}'::jsonb, '{"explanation":"C''est un éléphant.","accepted":["éléphant","elephant"]}'::jsonb, 6)
) as v(t, q, a, p);

-- sil-sciences-plantes : Les plantes
with ch as (
  insert into public.chapters (code, subject_id, level, title, position, content, is_published)
  select 'sil-sciences-plantes', s.id, 'sil'::public.school_level, 'Les plantes',
         4, '{"blocks":[{"type":"text","value":"Les plantes poussent dans la terre. Il y a des arbres 🌳, des fleurs 🌸 et des herbes.","speak":"Les plantes poussent dans la terre. Il y a des arbres, des fleurs et des herbes."},{"type":"text","value":"Pour grandir, une plante a besoin d''eau, de lumière et de terre."}]}'::jsonb, true
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
    ('qcm', '{"text":"De quoi une plante a-t-elle besoin pour grandir ?","speak":"De quoi une plante a-t-elle besoin pour grandir?","options":["de bonbons","de jouets","d''eau"]}'::jsonb, '{"explanation":"Une plante a besoin d''eau, de lumière et de terre.","correct":2}'::jsonb, 1),
    ('qcm', '{"text":"Où poussent les plantes ?","speak":"Où poussent les plantes?","options":["dans un sac","dans un lit","dans la terre"]}'::jsonb, '{"explanation":"Les plantes poussent dans la terre.","correct":2}'::jsonb, 2),
    ('association', '{"text":"Relie chaque dessin à son nom.","pairs":[{"left":"🌳","right":"arbre"},{"left":"🌸","right":"fleur"},{"left":"🌱","right":"jeune plante"}]}'::jsonb, '{"explanation":"arbre, fleur, jeune plante."}'::jsonb, 3),
    ('vrai_faux', '{"text":"Un arbre est une plante.","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"L''arbre est une grande plante.","correct":0}'::jsonb, 4),
    ('vrai_faux', '{"text":"Une plante n''a pas besoin d''eau.","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"Sans eau, la plante meurt.","correct":1}'::jsonb, 5)
) as v(t, q, a, p);

-- sil-sciences-eau : L'eau
with ch as (
  insert into public.chapters (code, subject_id, level, title, position, content, is_published)
  select 'sil-sciences-eau', s.id, 'sil'::public.school_level, 'L''eau',
         5, '{"blocks":[{"type":"text","value":"L''eau sert à boire, à se laver et à cuisiner."},{"type":"text","value":"L''eau propre n''a pas de couleur et n''a pas de goût."},{"type":"text","value":"On boit seulement de l''eau propre. On ferme le robinet pour ne pas gaspiller."}]}'::jsonb, true
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
    ('qcm', '{"text":"À quoi sert l''eau ?","speak":"À quoi sert l''eau?","options":["à écrire","à boire et à se laver","à coudre"]}'::jsonb, '{"explanation":"On utilise l''eau pour boire, se laver et cuisiner.","correct":1}'::jsonb, 1),
    ('qcm', '{"text":"Quelle eau peut-on boire ?","speak":"Quelle eau peut-on boire?","options":["l''eau propre","l''eau sale d''une flaque","l''eau de mer"]}'::jsonb, '{"explanation":"On boit seulement de l''eau propre.","correct":0}'::jsonb, 2),
    ('qcm', '{"text":"Où trouve-t-on de l''eau ?","speak":"Où trouve-t-on de l''eau?","options":["dans la rivière","dans le sable sec","dans le feu"]}'::jsonb, '{"explanation":"Il y a de l''eau dans la rivière.","correct":0}'::jsonb, 3),
    ('association', '{"text":"Relie chaque geste à l''objet qu''on utilise.","pairs":[{"left":"boire","right":"un verre d''eau propre"},{"left":"se laver","right":"de l''eau et du savon"},{"left":"cuisiner","right":"de l''eau dans la marmite"}]}'::jsonb, '{"explanation":"Chaque geste se fait avec de l''eau propre."}'::jsonb, 4),
    ('vrai_faux', '{"text":"L''eau propre a un goût sucré.","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"L''eau propre n''a pas de goût.","correct":1}'::jsonb, 5),
    ('vrai_faux', '{"text":"Il faut fermer le robinet pour ne pas gaspiller l''eau.","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"On ne laisse pas couler l''eau pour rien.","correct":0}'::jsonb, 6)
) as v(t, q, a, p);

-- sil-informatique-telephone-tablette : Le téléphone et la tablette
with ch as (
  insert into public.chapters (code, subject_id, level, title, position, content, is_published)
  select 'sil-informatique-telephone-tablette', s.id, 'sil'::public.school_level, 'Le téléphone et la tablette',
         1, '{"blocks":[{"type":"text","value":"Un téléphone 📱 et une tablette sont des appareils avec un écran.","speak":"Un téléphone et une tablette sont des appareils avec un écran."},{"type":"text","value":"On touche l''écran avec le doigt."},{"type":"text","value":"On prend soin de l''appareil : on a les mains propres et on ne le jette pas.","speak":"On prend soin de l''appareil: on a les mains propres et on ne le jette pas."}]}'::jsonb, true
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
    ('qcm', '{"text":"Avec quoi touche-t-on l''écran ?","speak":"Avec quoi touche-t-on l''écran?","options":["le pied","la tête","le doigt"]}'::jsonb, '{"explanation":"On touche l''écran avec le doigt.","correct":2}'::jsonb, 1),
    ('qcm', '{"text":"Quel objet a un écran ?","speak":"Quel objet a un écran?","options":["⚽","📱","🍌"]}'::jsonb, '{"explanation":"Le téléphone a un écran.","correct":1}'::jsonb, 2),
    ('vrai_faux', '{"text":"On peut jeter le téléphone par terre.","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"On prend soin de l''appareil.","correct":1}'::jsonb, 3),
    ('vrai_faux', '{"text":"Une tablette a un écran.","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"La tablette a un grand écran.","correct":0}'::jsonb, 4),
    ('qcm', '{"text":"Pour prendre soin de la tablette, on a les mains…","speak":"Pour prendre soin de la tablette, comment doivent être tes mains ?","options":["sales","mouillées","propres"]}'::jsonb, '{"explanation":"On a les mains propres.","correct":2}'::jsonb, 5)
) as v(t, q, a, p);

-- sil-informatique-gestes-ecran : Toucher, glisser, appuyer
with ch as (
  insert into public.chapters (code, subject_id, level, title, position, content, is_published)
  select 'sil-informatique-gestes-ecran', s.id, 'sil'::public.school_level, 'Toucher, glisser, appuyer',
         2, '{"blocks":[{"type":"text","value":"Toucher : on pose le doigt sur l''écran.","speak":"Toucher: on pose le doigt sur l''écran."},{"type":"text","value":"Glisser : on déplace le doigt sur l''écran.","speak":"Glisser: on déplace le doigt sur l''écran."},{"type":"text","value":"Appuyer sur un bouton ouvre une application."}]}'::jsonb, true
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
    ('qcm', '{"text":"Que fait-on pour déplacer une image sur l''écran ?","speak":"Que fait-on pour déplacer une image sur l''écran?","options":["on crie","on ferme les yeux","on glisse le doigt"]}'::jsonb, '{"explanation":"On glisse le doigt sur l''écran.","correct":2}'::jsonb, 1),
    ('association', '{"text":"Relie chaque geste à ce qu''on fait.","pairs":[{"left":"toucher","right":"poser le doigt"},{"left":"glisser","right":"déplacer le doigt"}]}'::jsonb, '{"explanation":"Toucher, c''est poser le doigt. Glisser, c''est le déplacer."}'::jsonb, 2),
    ('vrai_faux', '{"text":"Pour ouvrir une application, on appuie sur son bouton.","options":["Vrai","Faux"]}'::jsonb, '{"explanation":"On appuie sur le bouton de l''application.","correct":0}'::jsonb, 3),
    ('qcm', '{"text":"Quel geste permet de faire défiler les pages ?","speak":"Quel geste permet de faire défiler les pages?","options":["souffler dessus","glisser le doigt","donner un coup"]}'::jsonb, '{"explanation":"On glisse le doigt pour faire défiler.","correct":1}'::jsonb, 4)
) as v(t, q, a, p);
