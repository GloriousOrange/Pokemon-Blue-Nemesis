// Builds the three movepool tabs (Level-up / TM+HM / Mutagenated) for a
// species, ready to render -- each entry already carries its move's display
// name, type, power, accuracy, pp and effect description.

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

  const levelUp = rec.level_up_moves.map((m) => moveEntry(data, m.move, { level: m.level }));

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
    mutagen = rec.mutagen_moveset.map((mv) => moveEntry(data, mv));
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
