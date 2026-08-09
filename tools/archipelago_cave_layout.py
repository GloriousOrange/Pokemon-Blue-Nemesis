"""Archipelago Cave floors, built from rock formations that vanilla actually
uses together (verified by rendering them, see formations.png).

  A B / C D / E F  = Mt Moon's 2-wide rock outcrop: 14 16 top, 18 1A body,
                     1C 1E foot. Lit on the west face, shadowed on the east.
                     Its interior is tile $20, walled off from the $05 floor
                     by the CAVERN $20/$05 pair-collision, exactly as in
                     Mt Moon -- an inaccessible pocket, not a trap.
  R                = 1D, a horizontal boulder ridge.
  P                = 2E, a compact boulder pile.
  s q w i K        = stairs icon / stone quay / water / islet / rock in water
"""
LIT = {'A':0x14,'B':0x16,'C':0x18,'D':0x1A,'E':0x1C,'F':0x1E,
       'R':0x1D,'P':0x2E,'s':0x3C,'q':0x29,'w':0x76,'i':0x01,'K':0x4D,'.':0x19,
       'X':0x4D,   # solid rock mass
       'H':0x68}   # the pit: $22 hole tiles along its bottom-left, walled
                   # above by $2F, so it can only be entered from the south
FLOORS = {
 'ArchipelagoCave1F': [
    "..s...AB.",
    "......CD.",
    "P.....CD.",
    "..s...EF.",
    "....P....",
    ".AB....AB",
    ".CD.P..CD",
    ".EF....EF",
    ".....RRR.",
 ],
 'ArchipelagoCave2F': [
    "..s..AB..",
    ".P...CD..",
    ".....EF..",
    "..s....P.",
    "AB.......",
    "CD..RRR..",
    "EF.....AB",
    "...P...CD",
    ".......EF",
 ],
 'ArchipelagoCave3F': [
    "..s..AB..",
    ".....CD..",
    "P....EF..",
    ".........",
    "...qqqqq.",
    "...wwwwww",
    "XX.wwiwww",
    "XH.wwwwKw",
    "...wwwwww",
 ],
}
for name, rows in FLOORS.items():
    assert len(rows)==9 and all(len(r)==9 for r in rows), name
    flat = bytes(LIT[ch] for row in rows for ch in row)
    open(f'maps/{name}.blk','wb').write(flat)
    print(name)
    for r in range(9):
        print("   "+' '.join('%02X'%b for b in flat[r*9:(r+1)*9]))
