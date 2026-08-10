// Builds the three movepool tabs (Level-up / TM+HM / Mutagenated) for a
// species, ready to render -- each entry already carries its move's display
// name, type, power, accuracy, pp and effect description.

// HYPER BEAM ignores the 150 in the move table. ApplyHyperBeamPower
// (engine/battle/hyper_beam_power.asm) overwrites it every time the move is
// loaded with the user's live Attack + Speed, minus 50 -- or minus 30 when the
// user is NORMAL-type, so the types that naturally learn it keep an edge.
// Floored at 1, capped at 255 because it has to fit in a power byte.
//
// Reading *live* stats means stat stages and badge boosts feed in, so there is
// no single true number. What we can state exactly is the value it starts at:
// level 100, perfect DVs, untrained -- which is what a Mutagenstone produces,
// since the stone jumps a mon to 100 without granting any stat experience.
const HYPER_BEAM_PENALTY_NORMAL = 30;
const HYPER_BEAM_PENALTY_OTHER = 50;

function statAt100(base) {
  // Gen 1: ((base + DV) * 2 + sqrt(statexp)/4) * level/100 + 5, at DV 15 and
  // zero stat exp.
  return 2 * base + 35;
}

export function hyperBeamPower(rec) {
  const penalty = rec.types.includes("NORMAL")
    ? HYPER_BEAM_PENALTY_NORMAL
    : HYPER_BEAM_PENALTY_OTHER;
  const raw = statAt100(rec.base_stats.atk) + statAt100(rec.base_stats.spd) - penalty;
  return { power: Math.max(1, Math.min(255, raw)), capped: raw > 255 };
}

function moveEntry(data, moveName, extra) {
  const info = data.moves[moveName] || {};
  return {
    name: moveName,
    display_name: info.display_name || moveName,
    type: info.type,
    power: info.power,
    accuracy: info.accuracy,
    pp: info.pp,
    tm_number: info.tm_number,
    description: info.description,
    ...extra,
  };
}

export function buildMovepool(data, speciesKey) {
  const rec = data.species[speciesKey];

  // Only the Mutagenstone set is guaranteed to be at level 100, so that is the
  // only tab where a concrete HYPER BEAM number is honest.
  const hb = hyperBeamPower(rec);
  const withHyperBeam = (mv) =>
    mv.name === "HYPER_BEAM"
      ? { ...mv, power: hb.power, power_note: hb.capped ? "capped" : null, computed_power: true }
      : mv;

  const levelUp = rec.level_up_moves.map((m) =>
    moveEntry(data, m.move, { level: m.level, base: !!m.base }));

  const tmhmRank = (mv) => {
    const num = data.moves[mv]?.tm_number || "";
    const isHm = num.startsWith("HM");
    return [isHm ? 1 : 0, parseInt(num.slice(2), 10) || 999];
  };
  const tmhm = [...rec.tm_hm_moves]
    .sort((a, b) => {
      const [ra, na] = tmhmRank(a);
      const [rb, nb] = tmhmRank(b);
      return ra - rb || na - nb;
    })
    .map((mv) => moveEntry(data, mv));

  let mutagenNote = null;
  let mutagen = [];
  if (rec.mutagen_moveset) {
    mutagen = rec.mutagen_moveset.map((mv) => withHyperBeam(moveEntry(data, mv)));
  } else if (rec.final_evolution_of_self) {
    mutagenNote = "Not yet curated for this species.";
  } else {
    mutagenNote =
      "No curated set today: Mutagenstone levels a mon to 100 but doesn't " +
      "evolve it yet, so a pre-evolution falls back to its own last few " +
      "level-up moves instead of inheriting its final evolution's kit.";
  }

  return { levelUp, tmhm, mutagen, mutagenNote };
}
