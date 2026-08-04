// Pure type-math over docs/data/pokemon.json's dense type_chart -- no DOM
// here, just data in, numbers/labels out.

function defenseMultiplier(data, atkType, defTypes) {
  if (defTypes.length === 1) return data.type_chart[atkType][defTypes[0]];
  return data.type_chart[atkType][defTypes[0]] * data.type_chart[atkType][defTypes[1]];
}

// Offensive coverage comes from each member's actually-selected moveset
// (team.getMoveset), not everything it could theoretically learn -- a
// Charizard nobody taught a Fire move contributes no Fire coverage.
function teamMovesetTypes(data, team) {
  const types = new Set();
  for (const sp of team.members) {
    for (const mv of team.getMoveset(sp)) {
      const info = data.moves[mv];
      if (info) types.add(info.type);
    }
  }
  return types;
}

// coverage: attacking types the team's actual selected movesets can deploy.
// weaknesses: attacking types where at least one team member takes >1x
// (dual-type multiplied), most-affected first -- purely defensive, driven by
// species typing, unaffected by which moves are picked.
// gaps: attacking types where NO team member resists/nullifies it AND the
// team has no selected move type that hits it super-effectively back -- a
// true blind spot against that matchup.
export function computeCoverage(data, team) {
  if (team.members.length === 0) return { coverage: [], gaps: [], weaknesses: [] };

  const offensiveTypes = teamMovesetTypes(data, team);
  const weaknesses = [];
  const gaps = [];

  for (const atk of data.types) {
    const weakMembers = [];
    let anyResists = false;
    for (const sp of team.members) {
      const mult = defenseMultiplier(data, atk, data.species[sp].types);
      if (mult > 1) weakMembers.push(sp);
      if (mult < 1) anyResists = true;
    }
    if (weakMembers.length > 0) {
      weaknesses.push({ type: atk, count: weakMembers.length, members: weakMembers });
    }
    let hitsBack = false;
    for (const off of offensiveTypes) {
      if (data.type_chart[off][atk] > 1) { hitsBack = true; break; }
    }
    if (!anyResists && !hitsBack) gaps.push(atk);
  }

  weaknesses.sort((a, b) => b.count - a.count);
  return { coverage: [...offensiveTypes].sort(), gaps, weaknesses };
}
