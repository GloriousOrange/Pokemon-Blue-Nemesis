#!/usr/bin/env python3
"""Fix the end-battle texts that tools/endbattle_width_audit.py flags.

Two transforms, tried in order, both of which keep every word the author wrote:

1. Drop a hand-written speaker prefix. PrintEndBattleText already prepends
   "<NAME>: ", so a text that opens `"<RIVAL>: Weak."` prints the name twice.
   Removing the manual one usually brings the line back inside 18 characters
   on its own.

2. Give the name its own row. `text "" / line <old first line>`, with the rest
   of the first page pushed down a step (`line` -> `cont`). The box then reads
   "SCIENTIST:" on row 1 and the line on row 2, which is what the longer class
   names need -- "SCIENTIST: " alone leaves only 7 columns.

Run the audit afterwards; it should report zero.

Usage: python3 tools/endbattle_width_fix.py [--dry-run]
"""

import importlib.util
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
spec = importlib.util.spec_from_file_location(
    "audit", os.path.join(ROOT, "tools", "endbattle_width_audit.py"))
audit = importlib.util.module_from_spec(spec)
spec.loader.exec_module(audit)

LINE_WIDTH = audit.LINE_WIDTH
END = ("prompt", "done", "text_end")
BREAK = ("para", "page")

SPEAKER = re.compile(r"^(<RIVAL>|<PLAYER>|[A-Zé♀♂][A-Za-zé♀♂.' ]{1,13}):\s*(.*)$")


def locate(label, path, files, depth=0):
    """(path, body_start, body_end) of a text label, following one text_far."""
    if depth > 2:
        return None
    order = [path] + [p for p in files if p != path]
    for p in order:
        src = files[p]
        m = re.search(r"^%s:{0,2}\s*$" % re.escape(label), src, re.M)
        if not m:
            continue
        body = src[m.end():]
        first = next((l for l in body.splitlines() if l.strip()), "")
        far = re.match(r"\s*text_far\s+(\w+)", first)
        if far:
            return locate(far.group(1), p, files, depth + 1)
        if not re.match(r'\s*text\s+"', first):
            return None
        # body runs to the terminator
        end = m.end()
        for line in body.splitlines(keepends=True):
            end += len(line)
            if line.strip() in END:
                return p, m.end(), end
        return None
    return None


def parse(block):
    out = []
    for line in block.splitlines():
        s = line.strip()
        if not s:
            out.append(("blank", None))
            continue
        m = re.match(r'(text|line|cont|para|next|page)\s+"(.*)"\s*$', s)
        if m:
            out.append((m.group(1), m.group(2)))
        else:
            out.append((s, None))
    return out


def emit(parts):
    lines = []
    for kind, payload in parts:
        if kind == "blank":
            lines.append("")
        elif payload is None:
            lines.append("\t" + kind)
        else:
            lines.append('\t%s "%s"' % (kind, payload))
    return "\n".join(lines) + "\n"


def fix_block(block, budget):
    parts = parse(block)
    idx = next((i for i, (k, _) in enumerate(parts) if k == "text"), None)
    if idx is None:
        return None
    changed = False

    # 1. strip a duplicated speaker prefix
    m = SPEAKER.match(parts[idx][1])
    if m and m.group(2):
        parts[idx] = ("text", m.group(2))
        changed = True
    if audit.printed_length(parts[idx][1]) <= budget:
        return emit(parts) if changed else None

    # 2. give the name its own row
    end = len(parts)
    for i in range(idx + 1, len(parts)):
        if parts[i][0] in BREAK or parts[i][1] is None and parts[i][0] in END:
            end = i
            break
    for i in range(idx + 1, end):
        if parts[i][0] == "line":
            parts[i] = ("cont", parts[i][1])
    parts[idx] = ("line", parts[idx][1])
    parts.insert(idx, ("text", ""))
    return emit(parts)


def main():
    dry = "--dry-run" in sys.argv
    names = audit.class_display_names()
    files = {p: s for p, s in audit.walk_asm()}

    targets, seen = [], set()
    index = audit.build_text_index()
    for cls, label, path in audit.collect():
        if (cls, label) in seen:
            continue
        seen.add((cls, label))
        payload = audit.resolve_first_line(label, index, files.get(path))
        if payload is None:
            continue
        name = names.get(cls, cls.replace("OPP_", ""))
        budget = LINE_WIDTH - len(name) - 2
        if audit.printed_length(payload) <= budget:
            continue
        targets.append((label, path, name, budget))

    edits, misses = {}, []
    for label, path, name, budget in targets:
        loc = locate(label, path, files)
        if not loc:
            misses.append((label, path))
            continue
        fpath, a, b = loc
        src = files[fpath]
        new = fix_block(src[a:b], budget)
        if new is None:
            misses.append((label, path))
            continue
        edits.setdefault(fpath, []).append((a, b, new, label, name))

    count = 0
    for fpath, spans in edits.items():
        spans.sort(key=lambda s: -s[0])
        src = files[fpath]
        for a, b, new, label, name in spans:
            print(f"--- {fpath}  {label}   (prefix \"{name}: \")")
            for l in src[a:b].strip("\n").splitlines():
                print("  - " + l)
            for l in new.strip("\n").splitlines():
                print("  + " + l)
            src = src[:a] + new + src[b:]
            count += 1
        if not dry:
            with open(os.path.join(ROOT, fpath), "w", encoding="utf-8") as f:
                f.write(src)

    print(f"\n{count} texts rewritten across {len(edits)} files"
          + (" (dry run)" if dry else ""))
    if misses:
        print(f"{len(misses)} could not be rewritten automatically:")
        for label, path in misses:
            print(f"   {label}  [{path}]")


if __name__ == "__main__":
    main()
