#!/usr/bin/env python3
"""
Construit le contenu pédagogique de l'application.

  1. Lit les fichiers  content/<classe>/<matiere>.yaml
  2. Vérifie tout (structure, réponses, doublons, emojis risqués...)
  3. Génère  sql/out/seed_<classe>.sql  à coller dans Supabase > SQL Editor

Utilisation :
    pip install pyyaml
    python tools/build_content.py            # vérifie + génère le SQL
    python tools/build_content.py --check    # vérifie seulement

Le script peut être relancé autant de fois que nécessaire : chaque chapitre a un
identifiant stable (id), donc les chapitres sont mis à jour, jamais dupliqués, et la
progression des enfants est conservée.
"""
import argparse
import hashlib
import json
import random
import re
import sys
from collections import defaultdict
from pathlib import Path

try:
    import yaml
except ImportError:
    sys.exit("PyYAML est requis :  pip install pyyaml")

LEVELS = ["sil", "cp", "ce1", "ce2", "cm1", "cm2"]
SUBJECTS = ["maths", "francais", "anglais", "sciences", "informatique"]
TYPES = ["qcm", "vrai_faux", "association", "saisie", "ordre"]
DB_TYPE = {"qcm": "qcm", "vrai_faux": "vrai_faux", "association": "association",
           "saisie": "saisie", "ordre": "glisser_deposer"}

SLUG = re.compile(r"^[a-z0-9]+(-[a-z0-9]+)*$")
# Emojis / pictogrammes (retirés de la lecture à voix haute)
EMOJI = re.compile("[\U0001F000-\U0001FAFF\u2600-\u27BF\u2B00-\u2BFF\uFE0F\u200D]")
# Emojis récents : peuvent s'afficher comme des carrés sur les vieux Android (< 9)
RISKY = re.compile("[\U0001F900-\U0001FAFF\U0001F7E0-\U0001F7FF]")


class Report:
    def __init__(self):
        self.errors, self.warnings = [], []

    def err(self, where, msg):
        self.errors.append(f"ERREUR   {where} : {msg}")

    def warn(self, where, msg):
        self.warnings.append(f"attention {where} : {msg}")


def make_speak(text):
    """Version du texte pour la voix de synthèse (sans emojis, symboles lus)."""
    t = text.replace(" = ?", " égale combien ?")
    for a, b in ((" + ", " plus "), (" − ", " moins "), (" × ", " fois "), (" = ", " égale ")):
        t = t.replace(a, b)
    t = EMOJI.sub("", t)
    t = re.sub(r"\s+", " ", t).strip()
    return re.sub(r"\s+([?!.,:;])", r"\1", t)


def speak_field(text, explicit, where, rep):
    """Retourne le champ speak à enregistrer, ou None s'il est inutile."""
    if explicit:
        return str(explicit)
    if "…" in text:
        rep.warn(where, "le texte contient « … » : ajoute un champ speak: pour la voix")
    auto = make_speak(text)
    return auto if auto != text and auto else None


def as_str_list(value):
    return [str(x) for x in value]


def seeded_rng(*parts):
    h = hashlib.sha1("|".join(parts).encode("utf-8")).hexdigest()
    return random.Random(int(h, 16))


def convert_exercise(ex, where, code, rep):
    if not isinstance(ex, dict):
        rep.err(where, "un exercice doit être un bloc clé: valeur")
        return None
    typ = ex.get("type")
    text = ex.get("text")
    if typ not in TYPES:
        rep.err(where, f"type '{typ}' inconnu (types : {', '.join(TYPES)})")
        return None
    if not text or not isinstance(text, str):
        rep.err(where, "champ 'text' (la consigne) manquant")
        return None
    text = text.strip()
    if len(text) > 140:
        rep.warn(where, "consigne très longue (> 140 caractères)")
    if RISKY.search(json.dumps(ex, ensure_ascii=False)):
        rep.warn(where, "emoji récent : risque de carré vide sur les vieux téléphones Android")

    explanation = ex.get("explanation")
    if not explanation:
        rep.warn(where, "pas d'explication (champ explanation) : recommandé pour l'enfant")
    ans = {"explanation": str(explanation)} if explanation else {}
    q = {"text": text}
    sp = speak_field(text, ex.get("speak"), where, rep)
    if sp:
        q["speak"] = sp

    if typ == "qcm":
        opts = as_str_list(ex.get("options") or [])
        answer = str(ex.get("answer", ""))
        if not 2 <= len(opts) <= 4:
            rep.err(where, "qcm : 2 à 4 options attendues")
            return None
        if len(set(opts)) != len(opts):
            rep.err(where, "qcm : options en double")
            return None
        if answer not in opts:
            rep.err(where, f"qcm : la réponse '{answer}' n'est pas dans options {opts}")
            return None
        if ex.get("shuffle", True):
            seeded_rng(code, text).shuffle(opts)
        q["options"] = opts
        ans["correct"] = opts.index(answer)

    elif typ == "vrai_faux":
        a = ex.get("answer")
        norm = {True: "vrai", False: "faux", "vrai": "vrai", "faux": "faux",
                "true": "vrai", "false": "faux"}.get(a if isinstance(a, bool) else str(a).lower())
        if norm is None:
            rep.err(where, "vrai_faux : answer doit être vrai ou faux")
            return None
        q["options"] = ["Vrai", "Faux"]
        ans["correct"] = 0 if norm == "vrai" else 1

    elif typ == "association":
        pairs = ex.get("pairs")
        if not isinstance(pairs, dict) or not 2 <= len(pairs) <= 5:
            rep.err(where, "association : pairs doit contenir 2 à 5 paires  gauche: droite")
            return None
        lefts = [str(k) for k in pairs.keys()]
        rights = [str(v) for v in pairs.values()]
        if len(set(rights)) != len(rights):
            rep.err(where, "association : deux éléments de droite identiques")
            return None
        q["pairs"] = [{"left": l, "right": r} for l, r in zip(lefts, rights)]

    elif typ == "saisie":
        acc = as_str_list(ex.get("accepted") or [])
        kb = ex.get("keyboard", "text")
        if not acc:
            rep.err(where, "saisie : accepted (liste des réponses acceptées) manquant")
            return None
        if kb not in ("text", "number"):
            rep.err(where, "saisie : keyboard doit être text ou number")
            return None
        if kb == "number" and not all(re.fullmatch(r"\d+", a) for a in acc):
            rep.err(where, "saisie : avec keyboard: number, accepted ne doit contenir que des chiffres")
            return None
        q["keyboard"] = kb
        ans["accepted"] = acc

    elif typ == "ordre":
        order = as_str_list(ex.get("order") or [])
        if not 2 <= len(order) <= 6 or len(set(order)) != len(order):
            rep.err(where, "ordre : 2 à 6 éléments, tous différents, dans le BON ordre")
            return None
        items = order[:]
        rng = seeded_rng(code, text)
        for _ in range(20):
            rng.shuffle(items)
            if items != order:
                break
        q["items"] = items
        ans["order"] = order

    return DB_TYPE[typ], q, ans


def convert_lesson(items, where, rep):
    blocks = []
    if not isinstance(items, list) or not items:
        rep.err(where, "lesson : au moins un bloc attendu")
        return blocks
    for i, it in enumerate(items, 1):
        w = f"{where} > leçon {i}"
        if not isinstance(it, dict):
            rep.err(w, "bloc invalide")
            continue
        if "text" in it:
            text = str(it["text"]).strip()
            if len(text) > 220:
                rep.warn(w, "bloc de texte long (> 220 caractères) : coupe-le en deux")
            if RISKY.search(text):
                rep.warn(w, "emoji récent : risque de carré vide sur les vieux téléphones Android")
            block = {"type": "text", "value": text}
            sp = speak_field(text, it.get("speak"), w, rep)
            if sp:
                block["speak"] = sp
            blocks.append(block)
        elif "image" in it:
            url = str(it["image"])
            if not url.startswith("https://"):
                rep.err(w, "image : l'URL doit commencer par https://")
                continue
            blocks.append({"type": "image", "url": url})
        else:
            rep.err(w, "chaque bloc doit avoir 'text' ou 'image'")
    return blocks


def load_file(path, rep, seen_pairs):
    where_file = str(path)
    try:
        data = yaml.safe_load(path.read_text(encoding="utf-8"))
    except yaml.YAMLError as e:
        rep.err(where_file, f"YAML invalide : {e}")
        return None
    if not isinstance(data, dict):
        rep.err(where_file, "le fichier doit contenir level, subject et chapters")
        return None
    level, subject = data.get("level"), data.get("subject")
    if level not in LEVELS:
        rep.err(where_file, f"level '{level}' invalide ({', '.join(LEVELS)})")
        return None
    if subject not in SUBJECTS:
        rep.err(where_file, f"subject '{subject}' invalide ({', '.join(SUBJECTS)})")
        return None
    if (level, subject) in seen_pairs:
        rep.err(where_file, f"deux fichiers pour {level}/{subject} : un seul autorisé")
        return None
    seen_pairs.add((level, subject))

    chapters, ids = [], set()
    for pos, ch in enumerate(data.get("chapters") or [], 1):
        cid, title = ch.get("id"), ch.get("title")
        where = f"{level}/{subject} > chapitre {pos}"
        if not cid or not SLUG.match(str(cid)):
            rep.err(where, "id manquant ou invalide (minuscules, chiffres et tirets : ex. addition-10)")
            continue
        if cid in ids:
            rep.err(where, f"id '{cid}' en double")
            continue
        ids.add(cid)
        where = f"{level}/{subject}/{cid}"
        if not title:
            rep.err(where, "title manquant")
            continue
        code = f"{level}-{subject}-{cid}"
        blocks = convert_lesson(ch.get("lesson"), where, rep)
        exercises = []
        for n, ex in enumerate(ch.get("exercises") or [], 1):
            conv = convert_exercise(ex, f"{where} > exercice {n}", code, rep)
            if conv:
                exercises.append(conv)
        if len(exercises) < 3:
            rep.err(where, f"{len(exercises)} exercice(s) valide(s) : minimum 3")
            continue
        chapters.append({
            "code": code, "level": level, "subject": subject, "title": str(title).strip(),
            "position": pos, "published": bool(ch.get("published", True)),
            "content": {"blocks": blocks}, "exercises": exercises,
        })
    return chapters


def q(s):
    return "'" + s.replace("'", "''") + "'"


def jb(obj):
    return q(json.dumps(obj, ensure_ascii=False, separators=(",", ":"))) + "::jsonb"


def chapter_sql(ch):
    rows = ",\n    ".join(
        f"({q(t)}, {jb(qq)}, {jb(aa)}, {i})" for i, (t, qq, aa) in enumerate(ch["exercises"], 1)
    )
    return f"""-- {ch['code']} : {ch['title']}
with ch as (
  insert into public.chapters (code, subject_id, level, title, position, content, is_published)
  select {q(ch['code'])}, s.id, {q(ch['level'])}::public.school_level, {q(ch['title'])},
         {ch['position']}, {jb(ch['content'])}, {'true' if ch['published'] else 'false'}
  from public.subjects s where s.slug = {q(ch['subject'])}
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
    {rows}
) as v(t, q, a, p);
"""


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--content", default="content")
    ap.add_argument("--out", default="sql/out")
    ap.add_argument("--check", action="store_true", help="vérifier sans générer le SQL")
    args = ap.parse_args()

    rep, seen = Report(), set()
    all_chapters = []
    for path in sorted(Path(args.content).rglob("*.yaml")):
        if path.name.startswith("_"):
            continue
        res = load_file(path, rep, seen)
        if res:
            all_chapters.extend(res)

    # ---- Rapport de couverture
    cov = defaultdict(lambda: [0, 0])
    for ch in all_chapters:
        cov[(ch["level"], ch["subject"])][0] += 1
        cov[(ch["level"], ch["subject"])][1] += len(ch["exercises"])
    print("\nCouverture (chapitres / exercices) :")
    print(f"{'':6}" + "".join(f"{s:>16}" for s in SUBJECTS))
    for lv in LEVELS:
        cells = []
        for s in SUBJECTS:
            c = cov.get((lv, s))
            cells.append(f"{c[0]} / {c[1]}".rjust(16) if c else "-".rjust(16))
        print(f"{lv:6}" + "".join(cells))
    print(f"\nTotal : {len(all_chapters)} chapitres, {sum(len(c['exercises']) for c in all_chapters)} exercices")

    for w in rep.warnings:
        print(w)
    for e in rep.errors:
        print(e)
    if rep.errors:
        print(f"\n{len(rep.errors)} erreur(s) : corrige-les puis relance.")
        sys.exit(1)
    print(f"\nAucune erreur ({len(rep.warnings)} avertissement(s)).")

    if args.check:
        return
    out = Path(args.out)
    out.mkdir(parents=True, exist_ok=True)
    for lv in LEVELS:
        chs = [c for c in all_chapters if c["level"] == lv]
        if not chs:
            continue
        chs.sort(key=lambda c: (SUBJECTS.index(c["subject"]), c["position"]))
        body = "\n".join(chapter_sql(c) for c in chs)
        header = (f"-- Contenu {lv.upper()} — généré par tools/build_content.py (ne pas modifier à la main)\n"
                  f"-- À coller dans Supabase > SQL Editor. Peut être relancé sans risque.\n\n")
        (out / f"seed_{lv}.sql").write_text(header + body, encoding="utf-8")
        print(f"écrit : {out / ('seed_' + lv + '.sql')}  ({len(chs)} chapitres)")


if __name__ == "__main__":
    main()


