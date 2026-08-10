// The move browser under the sprite grid, and the HYPER BEAM power ranking.
//
// Both share the grid's search box: typing "ice" narrows the Pokemon *and* the
// moves, so one filter answers "what Ice-type options do I have" from both
// directions at once.

import { hyperBeamPower } from "./movepool.js";

const HYPER_BEAM = "HYPER_BEAM";

function typeLabel(t) {
  return (t || "?").replace("_TYPE", "");
}

// move -> [species...] , built once. A species counts if the move is anywhere
// it could legitimately come from: its start/level-up list, its TM+HM list, or
// its curated Mutagenstone row.
export function buildLearnerIndex(data) {
  const index = {};
  const add = (mv, sp) => {
    if (!mv) return;
    (index[mv] ||= new Set()).add(sp);
  };
  for (const [sp, rec] of Object.entries(data.species)) {
    for (const m of rec.level_up_moves) add(m.move, sp);
    for (const mv of rec.tm_hm_moves) add(mv, sp);
    for (const mv of rec.mutagen_moveset || []) add(mv, sp);
  }
  return index;
}

function matches(moveKey, info, filterText) {
  if (!filterText) return true;
  const f = filterText;
  if ((info.display_name || "").toLowerCase().includes(f)) return true;
  if (moveKey.toLowerCase().includes(f)) return true;
  return typeLabel(info.type).toLowerCase().includes(f);
}

export function renderMoveBrowser(data, learners, filterText, host, countHost) {
  host.innerHTML = "";
  const keys = Object.keys(data.moves).sort((a, b) =>
    (data.moves[a].display_name || a).localeCompare(data.moves[b].display_name || b)
  );

  let shown = 0;
  const ul = document.createElement("ul");
  ul.className = "move-list browse-list";
  for (const key of keys) {
    const info = data.moves[key];
    if (!matches(key, info, filterText)) continue;
    shown++;

    const li = document.createElement("li");
    const row = document.createElement("span");
    row.className = "move-row-content";

    const left = document.createElement("span");
    left.className = "browse-name";
    left.textContent = info.display_name || key;
    if (info.tm_number) {
      const tm = document.createElement("span");
      tm.className = "browse-tm";
      tm.textContent = info.tm_number;
      left.appendChild(tm);
    }

    const right = document.createElement("span");
    right.className = "move-meta";
    const power = key === HYPER_BEAM ? "varies" : (info.power || "—");
    const n = (learners[key] || new Set()).size;
    right.textContent =
      `${typeLabel(info.type)} · ${power} pow · ${info.accuracy ?? "—"}% · ` +
      `${info.pp ?? "—"}pp · ${n} can learn`;

    row.appendChild(left);
    row.appendChild(right);
    li.appendChild(row);

    const desc = document.createElement("p");
    desc.className = "move-desc";
    desc.textContent = info.description || "No description recorded for this move.";
    li.appendChild(desc);

    ul.appendChild(li);
  }

  if (shown === 0) {
    const p = document.createElement("p");
    p.className = "empty-note";
    p.textContent = "No moves match that filter.";
    host.appendChild(p);
  } else {
    host.appendChild(ul);
  }
  countHost.textContent = `${shown} / ${keys.length}`;
}

// HYPER BEAM is the only move whose power depends on who is using it, so it
// gets its own ranking: base Attack + base Speed, -50, or -30 for a NORMAL-type
// user. Rendered once at load -- it never changes with the filter.
export function renderHyperBeamRanking(data, learners, host) {
  host.innerHTML = "";
  const users = [...(learners[HYPER_BEAM] || new Set())].map((sp) => {
    const rec = data.species[sp];
    const { power } = hyperBeamPower(rec);
    return { sp, rec, power };
  });
  users.sort((a, b) => b.power - a.power || a.rec.display_name.localeCompare(b.rec.display_name));

  const intro = document.createElement("p");
  intro.className = "coverage-hint";
  intro.textContent =
    `All ${users.length} Pokémon that can learn HYPER BEAM, strongest first. ` +
    `Its power is never the 150 in the move table — it is the user's base ` +
    `Attack plus base Speed, -50, or -30 for a Normal-type user. Because it ` +
    `comes off base stats it is fixed per species: level, DVs and stat boosts ` +
    `do not change it.`;
  host.appendChild(intro);

  const table = document.createElement("table");
  table.className = "hb-table";
  table.innerHTML =
    "<thead><tr><th>#</th><th>Pokémon</th><th>Type</th>" +
    "<th class=\"num\">Atk</th><th class=\"num\">Spd</th>" +
    "<th class=\"num\">Pen</th><th class=\"num\">Power</th></tr></thead>";
  const tbody = document.createElement("tbody");

  users.forEach((u, i) => {
    const b = u.rec.base_stats;
    const pen = u.rec.types.includes("NORMAL") ? 30 : 50;
    const tr = document.createElement("tr");
    if (u.power >= 150) tr.className = "hb-strong";
    const types = [...new Set(u.rec.types)].map(typeLabel).join("/");
    tr.innerHTML =
      `<td class="num dim">${i + 1}</td>` +
      `<td>${u.rec.display_name}</td>` +
      `<td class="dim">${types}</td>` +
      `<td class="num">${b.atk}</td>` +
      `<td class="num">${b.spd}</td>` +
      `<td class="num dim">-${pen}</td>` +
      `<td class="num strong">${u.power}</td>`;
    tbody.appendChild(tr);
  });

  table.appendChild(tbody);
  const scroller = document.createElement("div");
  scroller.className = "hb-scroll";
  scroller.appendChild(table);
  host.appendChild(scroller);
}
