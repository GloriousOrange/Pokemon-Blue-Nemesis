#!/usr/bin/env python3
"""Audit every trainer end-battle text for the name-prefix overflow.

PrintEndBattleText (home/trainers.asm) prints TrainerEndBattleText, which is
`_TrainerNameText` -- a `text_ram wNameBuffer` followed by ": " -- and *then*
runs the script's own end-battle text on the same line. So the first line the
author writes does not start at column 0: it starts at len(name) + 2.

A text box row is 18 characters. Anything past that wraps mid-word onto the
next row. That is the "VERMEIL: Enough. Yo / u have" glitch.

The prefix is the trainer *class* name from TrainerNamePointers, not the
individual's -- except for the classes whose pointer is `wTrainerName`, which
GetTrainerName fills with the specific trainer's name (rival, gym leaders,
Elite Four). The rival's is player-settable, so 7 is assumed.

Two ways a script names its end-battle text, both audited here:
  * the `trainer` / `trainer_in` macro, 4th (5th) argument
  * `ld hl, <win>` / `ld de, <lose>` before `call SaveEndBattleTextPointers`

Usage: python3 tools/endbattle_width_audit.py [--all]
       --all also lists texts that fit, for eyeballing the margins.
"""

import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LINE_WIDTH = 18
RIVAL_NAME_LEN = 7  # the player renames him; 7 is the cap

TEXT_DIRS = ["scripts", "text", "data/text", "engine/events", "engine/overworld", "engine/battle"]


def read(path):
    with open(os.path.join(ROOT, path), encoding="utf-8") as f:
        return f.read()


def walk_asm():
    for d in TEXT_DIRS:
        full = os.path.join(ROOT, d)
        if not os.path.isdir(full):
            continue
        for dirpath, _, files in os.walk(full):
            for fn in sorted(files):
                if fn.endswith(".asm"):
                    p = os.path.join(dirpath, fn)
                    yield os.path.relpath(p, ROOT), open(p, encoding="utf-8").read()


# ---------------------------------------------------------------- class names

def trainer_class_order():
    """OPP_ classes in TrainerNamePointers order.

    The constants come from the `trainer_const` macro, and NOBODY ($00) is not
    in the name tables -- SaveTrainerName does `dec a` before indexing.
    """
    names = re.findall(r"^\s*trainer_const\s+(\w+)",
                       read("constants/trainer_constants.asm"), re.M)
    return ["OPP_" + n for n in names[1:]]


def class_display_names():
    src = read("data/trainers/name_pointers.asm")
    short = {m.group(1): m.group(2)
             for m in re.finditer(r'^\.(\w+)Name:\s*db "(.*?)@"', src, re.M)}
    pointers = re.findall(r"^\tdw (\.?\w+)\s*$", src[src.index("TrainerNamePointers:"):], re.M)
    full = re.findall(r'^\tli "(.*?)"', read("data/trainers/names.asm"), re.M)

    names = {}
    for i, cls in enumerate(trainer_class_order()):
        ptr = pointers[i] if i < len(pointers) else "wTrainerName"
        if ptr.startswith("."):
            names[cls] = short.get(ptr[1:-4], ptr)
        elif "RIVAL" in cls:
            names[cls] = "?" * RIVAL_NAME_LEN
        else:
            names[cls] = full[i] if i < len(full) else cls.replace("OPP_", "")
    return names


# --------------------------------------------------------------- text lookup

def build_text_index():
    """label -> (path, first `text "..."` payload) following one text_far hop."""
    raw = {}
    for path, src in walk_asm():
        for m in re.finditer(r"^(\.?\w+):{0,2}\s*$", src, re.M):
            raw.setdefault(m.group(1), []).append((path, src[m.end():]))
    return raw


def resolve_first_line(label, index, local=None, depth=0):
    if depth > 2:
        return None
    bodies = []
    if local:
        m = re.search(r"^%s:{0,2}\s*$" % re.escape(label), local, re.M)
        if m:
            bodies.append(local[m.end():])
    bodies += [b for _, b in index.get(label, [])]

    for body in bodies:
        for line in body.splitlines():
            s = line.strip()
            if not s or s.startswith(";"):
                continue
            m = re.match(r'text\s+"(.*)"\s*$', s)
            if m:
                return m.group(1)
            m = re.match(r"text_far\s+(\w+)", s)
            if m:
                return resolve_first_line(m.group(1), index, None, depth + 1)
            break  # text_asm, db, a jump -- not a plain string
    return None


def printed_length(payload):
    s = payload.replace("<PLAYER>", "A" * 7).replace("<RIVAL>", "A" * RIVAL_NAME_LEN)
    s = re.sub(r"<[A-Z_0-9]+>", "AAAAAAA", s)
    return len(s)


# ------------------------------------------------------------- map -> classes

def map_trainer_objects():
    out = {}
    d = "data/maps/objects"
    for fn in sorted(os.listdir(os.path.join(ROOT, d))):
        if not fn.endswith(".asm"):
            continue
        objs, idx = {}, 0
        for line in read(os.path.join(d, fn)).splitlines():
            if re.match(r"\s*object_event\b", line):
                idx += 1
                m = re.search(r"(OPP_\w+)", line)
                if m:
                    objs[idx] = m.group(1)
        out[fn[:-4]] = objs
    return out


# -------------------------------------------------------------------- collect

def collect():
    """(class, label, source path) for every end-battle text in the game."""
    objects = map_trainer_objects()
    found = []

    for path, src in walk_asm():
        mapname = os.path.basename(path)[:-4]

        # a) trainer headers
        if path.startswith("scripts/"):
            m = re.search(r"^\s*def_trainers\s+(\d+)", src, re.M)
            start = int(m.group(1)) if m else 1
            for k, args in enumerate(re.findall(r"^\s*trainer(_in)?\s+(.*)$", src, re.M)):
                parts = [a.strip() for a in args[1].split(",")]
                label = parts[3] if len(parts) == 5 else parts[4] if len(parts) == 6 else None
                cls = objects.get(mapname, {}).get(start + k)
                if label and cls:
                    found.append((cls, label, path))

        # b) direct SaveEndBattleTextPointers
        for m in re.finditer(r"call SaveEndBattleTextPointers", src):
            window = src[max(0, m.start() - 1400):m.start()]
            hl = re.findall(r"ld hl, (\.?\w+)", window)
            de = re.findall(r"ld de, (\.?\w+)", window)
            # The opponent is usually set just *after* the pointers are saved,
            # so look forward first -- looking back can pick up the previous
            # trainer on a map that hosts two (Oak and Ash share a floor).
            after = re.findall(r"ld a, (OPP_\w+)", src[m.end():m.end() + 400])
            before = re.findall(r"ld a, (OPP_\w+)", window)
            cls = after[0] if after else (before[-1] if before else None)
            if not cls:
                continue
            for label in ([hl[-1]] if hl else []) + ([de[-1]] if de else []):
                found.append((cls, label, path))

    return found


def main():
    show_all = "--all" in sys.argv
    names = class_display_names()
    index = build_text_index()
    locals_by_path = {p: s for p, s in walk_asm()}

    rows, unresolved = [], []
    seen = set()
    for cls, label, path in collect():
        if (cls, label) in seen:
            continue
        seen.add((cls, label))
        payload = resolve_first_line(label, index, locals_by_path.get(path))
        if payload is None:
            unresolved.append((cls, label, path))
            continue
        name = names.get(cls, cls.replace("OPP_", ""))
        total = len(name) + 2 + printed_length(payload)
        rows.append((total, path, name, label, payload))

    rows.sort(key=lambda r: -r[0])
    over = [r for r in rows if r[0] > LINE_WIDTH]
    for total, path, name, label, payload in (rows if show_all else over):
        flag = "!!" if total > LINE_WIDTH else "  "
        print(f"{flag} {total:3}  {name+':':14} {label}")
        print(f"          \"{payload}\"   [{path}]")

    print(f"\n{len(over)} of {len(rows)} end-battle texts overflow the "
          f"{LINE_WIDTH}-character row.")
    if unresolved:
        print(f"{len(unresolved)} not statically resolvable (text_asm / computed):")
        for cls, label, path in unresolved:
            print(f"   {label}  [{path}]")
    return 1 if over else 0


if __name__ == "__main__":
    sys.exit(main())
