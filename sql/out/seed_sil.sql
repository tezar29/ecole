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
