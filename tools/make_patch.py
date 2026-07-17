#!/usr/bin/env python3
"""
Generate BPS + IPS patches that turn a base ROM into a target ROM.

Usage:
    python3 tools/make_patch.py <base.gb> <target.gbc> <out_basename>

Writes <out_basename>.bps and <out_basename>.ips, and round-trip verifies each
(applies the patch back onto the base and checks it reproduces the target).

For Nemesis: build the CLEAN rom (`make clean && make blue`, no SPEEDTEST),
stamp its title to "PKMN NEMESIS", then diff it against retail Pokemon Blue
(SHA1 d7037c83e1ae5b39bde3c30787637ba1d4c48ce2). No external tools needed.
"""
import sys, zlib


def make_ips(src, tgt):
    if len(src) != len(tgt):
        raise SystemExit("IPS path here assumes equal-size ROMs")
    out = bytearray(b"PATCH")
    i, n = 0, len(tgt)
    while i < n:
        if src[i] == tgt[i]:
            i += 1
            continue
        s = i
        while i < n and src[i] != tgt[i]:
            i += 1
        run = tgt[s:i]
        p = 0
        while p < len(run):
            chunk = run[p:p + 0xFFFF]
            out += (s + p).to_bytes(3, "big")
            out += len(chunk).to_bytes(2, "big")
            out += chunk
            p += 0xFFFF
    out += b"EOF"
    return bytes(out)


def apply_ips(src, patch):
    out = bytearray(src)
    i = 5
    while patch[i:i + 3] != b"EOF":
        off = int.from_bytes(patch[i:i + 3], "big"); i += 3
        ln = int.from_bytes(patch[i:i + 2], "big"); i += 2
        if ln == 0:  # RLE record
            rl = int.from_bytes(patch[i:i + 2], "big"); i += 2
            out[off:off + rl] = bytes([patch[i]]) * rl; i += 1
        else:
            out[off:off + ln] = patch[i:i + ln]; i += ln
    return bytes(out)


def _vw(n):  # BPS/beat variable-width integer
    o = bytearray()
    while True:
        x = n & 0x7F
        n >>= 7
        if n == 0:
            o.append(0x80 | x)
            return o
        o.append(x)
        n -= 1


def _rvw(p, i):
    data, shift = 0, 1
    while True:
        x = p[i]; i += 1
        data += (x & 0x7F) * shift
        if x & 0x80:
            return data, i
        shift <<= 7
        data += shift


def make_bps(src, tgt):
    p = bytearray(b"BPS1")
    p += _vw(len(src)); p += _vw(len(tgt)); p += _vw(0)
    o, n = 0, len(tgt)
    while o < n:
        if o < len(src) and src[o] == tgt[o]:
            s = o
            while o < n and o < len(src) and src[o] == tgt[o]:
                o += 1
            p += _vw(((o - s - 1) << 2) | 0)   # SourceRead
        else:
            s = o
            while o < n and (o >= len(src) or src[o] != tgt[o]):
                o += 1
            p += _vw(((o - s - 1) << 2) | 1)   # TargetRead
            p += tgt[s:o]
    p += zlib.crc32(src).to_bytes(4, "little")
    p += zlib.crc32(tgt).to_bytes(4, "little")
    p += zlib.crc32(bytes(p)).to_bytes(4, "little")
    return bytes(p)


def apply_bps(src, p):
    assert p[:4] == b"BPS1"
    i = 4
    _, i = _rvw(p, i)          # source size
    tgt_size, i = _rvw(p, i)
    meta, i = _rvw(p, i); i += meta
    out = bytearray(tgt_size)
    o, end = 0, len(p) - 12
    while i < end:
        cmd, i = _rvw(p, i)
        act, ln = cmd & 3, (cmd >> 2) + 1
        if act == 0:            # SourceRead
            out[o:o + ln] = src[o:o + ln]; o += ln
        elif act == 1:          # TargetRead
            out[o:o + ln] = p[i:i + ln]; i += ln; o += ln
        else:
            raise SystemExit("this generator only emits SourceRead/TargetRead")
    return bytes(out)


def main():
    if len(sys.argv) != 4:
        raise SystemExit(__doc__)
    base, target, out = sys.argv[1], sys.argv[2], sys.argv[3]
    src = open(base, "rb").read()
    tgt = open(target, "rb").read()
    ips, bps = make_ips(src, tgt), make_bps(src, tgt)
    if apply_ips(src, ips) != tgt:
        raise SystemExit("IPS round-trip FAILED")
    if apply_bps(src, bps) != tgt:
        raise SystemExit("BPS round-trip FAILED")
    open(out + ".bps", "wb").write(bps)
    open(out + ".ips", "wb").write(ips)
    print(f"wrote {out}.bps ({len(bps):,} B) and {out}.ips ({len(ips):,} B)")
    print(f"base SHA1 must be shared with testers; base CRC32 = {zlib.crc32(src):08X}")
    print("round-trip verified: both patches reconstruct the target exactly")


if __name__ == "__main__":
    main()
