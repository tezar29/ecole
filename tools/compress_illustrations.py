#!/usr/bin/env python3
"""Compresse les illustrations brutes pour l'application.

Les PNG générés sont placés dans .tmp_illustrations/<code>.png ; ce script
produit des JPEG légers dans assets/images/lessons/<code>.jpg (1 000 px de
large maximum), puis signale les chapitres sans illustration.

Utilisation :
    py tools/compress_illustrations.py
"""
import sys
from pathlib import Path

try:
    from PIL import Image
except ImportError:
    sys.exit("Pillow est requis :  py -m pip install pillow")

try:
    import yaml
except ImportError:
    sys.exit("PyYAML est requis :  py -m pip install pyyaml")

ROOT = Path(__file__).resolve().parent.parent
RAW = ROOT / ".tmp_illustrations"
OUT = ROOT / "assets" / "images" / "lessons"
MAX_WIDTH = 1000
QUALITY = 82


def compress_all():
    OUT.mkdir(parents=True, exist_ok=True)
    for src in sorted(RAW.glob("*.png")):
        im = Image.open(src).convert("RGB")
        if im.width > MAX_WIDTH:
            height = round(im.height * MAX_WIDTH / im.width)
            im = im.resize((MAX_WIDTH, height), Image.LANCZOS)
        dest = OUT / f"{src.stem}.jpg"
        im.save(dest, "JPEG", quality=QUALITY, optimize=True)
        print(f"écrit : {dest.relative_to(ROOT)}  ({dest.stat().st_size // 1024} Ko)")


def report_coverage():
    codes = []
    for path in sorted((ROOT / "content").glob("*/*.yaml")):
        data = yaml.safe_load(path.read_text(encoding="utf-8"))
        for ch in data.get("chapters") or []:
            codes.append(f"{data['level']}-{data['subject']}-{ch['id']}")
    have = {p.stem for p in OUT.glob("*.jpg")}
    missing = [c for c in codes if c not in have]
    print(f"\nIllustrations : {len(have)} / {len(codes)} chapitres")
    if missing:
        for c in missing:
            print(f"  manquante : {c}")
    extra = sorted(have - set(codes))
    for c in extra:
        print(f"  sans chapitre : {c}")


if __name__ == "__main__":
    if RAW.exists():
        compress_all()
    report_coverage()
