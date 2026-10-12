-- Exercices d'exemple pour les nouveaux types, ajoutés au chapitre
-- « Compter jusqu'à 10 » (maths, CP) créé par sample_data.sql.
-- À exécuter dans Supabase > SQL Editor

insert into public.exercises (chapter_id, type, question, answer, position)
select ch.id, v.type::public.exercise_type, v.question::jsonb, v.answer::jsonb, v.pos
from public.chapters ch
join public.subjects s on s.id = ch.subject_id
cross join (values
  ('vrai_faux',
   $$ {"text": "6 est plus grand que 9. Vrai ou faux ?", "options": ["Vrai", "Faux"]} $$,
   $$ {"correct": 1, "explanation": "6 est plus petit que 9."} $$, 4),

  ('saisie',
   $$ {"text": "Écris le résultat : 4 + 3", "keyboard": "number"} $$,
   $$ {"accepted": ["7", "sept"], "explanation": "4 + 3 = 7."} $$, 5),

  ('association',
   $$ {"text": "Relie chaque chiffre à son nom",
       "pairs": [{"left": "1", "right": "un"}, {"left": "2", "right": "deux"}, {"left": "3", "right": "trois"}]} $$,
   $$ {"explanation": "1 = un, 2 = deux, 3 = trois."} $$, 6),

  ('glisser_deposer',
   $$ {"text": "Range les nombres du plus petit au plus grand", "items": ["3", "1", "2"]} $$,
   $$ {"order": ["1", "2", "3"], "explanation": "Dans l'ordre : 1, 2, 3."} $$, 7)
) as v(type, question, answer, pos)
where s.slug = 'maths'
  and ch.level = 'cp'
  and ch.title = 'Compter jusqu''à 10';
