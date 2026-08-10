import { loadData } from "./data.js";
import { TeamState, MAX_TEAM_SIZE, MAX_MOVESET_SIZE } from "./team.js";
import { computeCoverage } from "./coverage.js";
import { buildMovepool } from "./movepool.js";
import { createTile, createTeamSlot, spriteSrc } from "./sprites.js";

const team = new TeamState();
let data = null;
let speciesOrder = [];
let filterText = "";
let detailSpecies = null;
let activeTab = "levelUp";

const el = {
  grid: document.getElementById("sprite-grid"),
  gridCount: document.getElementById("grid-count"),
  teamSlots: document.getElementById("team-slots"),
  coverage: document.getElementById("coverage"),
  search: document.getElementById("search"),
  overlay: document.getElementById("detail-overlay"),
  panel: document.getElementById("detail-panel"),
};

async function init() {
  data = await loadData();
  speciesOrder = Object.keys(data.species).sort(
    (a, b) => data.species[a].dex_number - data.species[b].dex_number
  );

  el.search.addEventListener("input", (e) => {
    filterText = e.target.value.trim().toLowerCase();
    renderGrid();
  });

  el.overlay.addEventListener("click", (e) => {
    if (e.target === el.overlay) closeDetail();
  });

  renderGrid();
  renderTeam();
  renderCoverage();
}

function matchesFilter(speciesKey) {
  if (!filterText) return true;
  const rec = data.species[speciesKey];
  if (rec.display_name.toLowerCase().includes(filterText)) return true;
  if (speciesKey.toLowerCase().includes(filterText)) return true;
  return rec.types.some((t) => t.toLowerCase().includes(filterText));
}

function renderGrid() {
  el.grid.innerHTML = "";
  const callbacks = {
    onToggleTeam: (sp) => {
      const changed = team.toggle(sp);
      if (!changed) return; // team full, ignored
      renderGrid();
      renderTeam();
      renderCoverage();
      if (detailSpecies === sp) renderDetail();
    },
    onToggleGhost: (sp) => {
      team.toggleGhost(sp);
      renderGrid();
      if (team.has(sp)) renderTeam();
      if (detailSpecies === sp) renderDetail();
    },
    onOpenDetail: (sp) => openDetail(sp),
  };

  let shown = 0;
  for (const sp of speciesOrder) {
    if (!matchesFilter(sp)) continue;
    shown++;
    el.grid.appendChild(createTile(data, team, sp, callbacks));
  }
  el.gridCount.textContent = `${shown} / ${speciesOrder.length}`;
}

function renderTeam() {
  el.teamSlots.innerHTML = "";
  const callbacks = {
    onRemove: (sp) => {
      team.remove(sp);
      renderGrid();
      renderTeam();
      renderCoverage();
      if (detailSpecies === sp) renderDetail();
    },
  };
  for (let i = 0; i < MAX_TEAM_SIZE; i++) {
    const sp = team.members[i] || null;
    el.teamSlots.appendChild(createTeamSlot(data, team, sp, callbacks));
  }
}

function typeChipRow(types, weakSet) {
  const row = document.createElement("div");
  row.className = "type-chip-row";
  for (const t of types) {
    const chip = document.createElement("span");
    chip.className = "type-chip" + (weakSet && weakSet.has(t) ? " weak" : "");
    chip.textContent = t.replace("_TYPE", "");
    row.appendChild(chip);
  }
  return row;
}

function renderCoverage() {
  el.coverage.innerHTML = "";
  if (team.members.length === 0) {
    const note = document.createElement("p");
    note.className = "empty-note";
    note.textContent = "Add up to 6 Pokémon to see type coverage, gaps, and weaknesses.";
    el.coverage.appendChild(note);
    return;
  }

  const { coverage, gaps, weaknesses } = computeCoverage(data, team);

  const covBox = document.createElement("div");
  covBox.className = "coverage-box coverage";
  covBox.innerHTML = "<h3>Type coverage</h3><p class=\"coverage-hint\">From each member's selected moveset, not everything it could learn.</p>";
  covBox.appendChild(
    coverage.length
      ? typeChipRow(coverage)
      : Object.assign(document.createElement("p"), { className: "empty-note", textContent: "No offensive moves yet." })
  );
  el.coverage.appendChild(covBox);

  const gapBox = document.createElement("div");
  gapBox.className = "coverage-box gaps";
  gapBox.innerHTML = "<h3>Coverage gaps</h3>";
  gapBox.appendChild(
    gaps.length
      ? typeChipRow(gaps)
      : Object.assign(document.createElement("p"), { className: "empty-note", textContent: "No blind spots — every type is either resisted or answered." })
  );
  el.coverage.appendChild(gapBox);

  const weakBox = document.createElement("div");
  weakBox.className = "coverage-box weaknesses";
  weakBox.innerHTML = "<h3>Team weaknesses</h3>";
  if (weaknesses.length) {
    const row = document.createElement("div");
    row.className = "type-chip-row";
    for (const w of weaknesses) {
      const chip = document.createElement("span");
      const tier = Math.min(w.count, 5); // ×1..×4 own colors, ×5+ shares "red"
      chip.className = `type-chip weak weak-${tier}`;
      chip.title = w.members.map((s) => data.species[s].display_name).join(", ");
      chip.innerHTML = `${w.type.replace("_TYPE", "")}<span class="count">×${w.count}</span>`;
      row.appendChild(chip);
    }
    weakBox.appendChild(row);
  } else {
    weakBox.innerHTML += '<p class="empty-note">No shared weaknesses.</p>';
  }
  el.coverage.appendChild(weakBox);
}

function openDetail(speciesKey) {
  detailSpecies = speciesKey;
  activeTab = "levelUp";
  el.overlay.hidden = false;
  renderDetail();
}

function closeDetail() {
  el.overlay.hidden = true;
  detailSpecies = null;
}

// selectionCtx is null for species not on the team (plain read-only list).
// When present ({ team, sp, onToggle }), each row gets a checkbox for
// picking that species' actual moveset (up to MAX_MOVESET_SIZE) -- what
// coverage.js reads.
function renderMoveList(entries, kind, selectionCtx) {
  const ul = document.createElement("ul");
  ul.className = "move-list";
  if (entries.length === 0) {
    const li = document.createElement("li");
    li.textContent = "—";
    ul.appendChild(li);
    return ul;
  }
  for (const mv of entries) {
    const li = document.createElement("li");

    if (selectionCtx) {
      const { team, sp, onToggle } = selectionCtx;
      const selected = team.hasMove(sp, mv.name);
      const atCap = team.getMoveset(sp).length >= MAX_MOVESET_SIZE;
      const cb = document.createElement("input");
      cb.type = "checkbox";
      cb.className = "move-select";
      cb.checked = selected;
      cb.disabled = !selected && atCap;
      cb.title = selected ? "Remove from moveset" : atCap ? `Moveset full (${MAX_MOVESET_SIZE}/${MAX_MOVESET_SIZE})` : "Add to moveset";
      cb.addEventListener("change", () => onToggle(mv.name));
      li.appendChild(cb);
      if (selected) li.classList.add("move-selected");
    }

    const content = document.createElement("span");
    content.className = "move-row-content";
    const left = document.createElement("span");
    let prefix = "";
    if (kind === "levelUp") prefix = mv.base ? "Start · " : `L${mv.level} · `;
    if (kind === "tmhm") prefix = `${mv.tm_number || "?"} · `;
    left.textContent = `${prefix}${mv.display_name}`;
    const right = document.createElement("span");
    right.className = "move-meta";
    // HYPER BEAM's table power is a lie -- movepool.js substitutes the real
    // figure on the Mutagenstone tab, where the level is known to be 100.
    const power = mv.computed_power
      ? `${mv.power}${mv.power_note === "capped" ? "*" : ""} pow`
      : `${mv.power ?? "—"} pow`;
    right.textContent = `${mv.type ? mv.type.replace("_TYPE", "") : "?"} · ${power} · ${mv.accuracy ?? "—"}% · ${mv.pp ?? "—"}pp`;
    content.appendChild(left);
    content.appendChild(right);
    li.appendChild(content);

    // Always visible rather than click-to-expand: what a move actually does is
    // the point of the list, not a detail to go hunting for.
    const desc = document.createElement("p");
    desc.className = "move-desc";
    let text = mv.description || "No description recorded for this move.";
    if (mv.computed_power) {
      text += mv.power_note === "capped"
        ? ` *Its power is the user's Attack + Speed, which for this species overflows the 255 ceiling at level 100 -- so it hits at the maximum 255 even before any boosts.`
        : ` At level 100 with perfect DVs that works out to ${mv.power}, and it climbs further with Attack or Speed boosts.`;
    }
    desc.textContent = text;
    li.appendChild(desc);

    ul.appendChild(li);
  }
  return ul;
}

function renderDetail() {
  if (!detailSpecies) return;
  const sp = detailSpecies;
  const rec = data.species[sp];
  const ghostOn = team.isGhostView(sp);
  const pool = buildMovepool(data, sp);

  el.panel.innerHTML = "";

  const closeBtn = document.createElement("button");
  closeBtn.className = "detail-close";
  closeBtn.textContent = "✕";
  closeBtn.addEventListener("click", closeDetail);
  el.panel.appendChild(closeBtn);

  const head = document.createElement("div");
  head.className = "detail-head";
  const img = document.createElement("img");
  img.src = spriteSrc(data, sp, ghostOn);
  img.alt = rec.display_name;
  head.appendChild(img);
  const headText = document.createElement("div");
  headText.innerHTML = `<h2>${rec.display_name}</h2>`;
  headText.appendChild(typeChipRow(rec.types));
  head.appendChild(headText);
  el.panel.appendChild(head);

  const stats = document.createElement("div");
  stats.className = "stat-grid";
  for (const [label, key] of [["HP", "hp"], ["ATK", "atk"], ["DEF", "def"], ["SPD", "spd"], ["SPC", "spc"]]) {
    const cell = document.createElement("div");
    cell.innerHTML = `${rec.base_stats[key]}<span>${label}</span>`;
    stats.appendChild(cell);
  }
  el.panel.appendChild(stats);

  const addBtn = document.createElement("button");
  const inTeam = team.has(sp);
  addBtn.className = "detail-add-btn" + (inTeam ? " remove" : "");
  addBtn.textContent = inTeam ? "Remove from team" : "Add to team";
  addBtn.disabled = !inTeam && team.isFull();
  addBtn.addEventListener("click", () => {
    team.toggle(sp);
    renderGrid();
    renderTeam();
    renderCoverage();
    renderDetail();
  });
  el.panel.appendChild(addBtn);

  if (rec.ghost_eligible) {
    const ghostBtn = document.createElement("button");
    ghostBtn.className = "detail-ghost-btn";
    ghostBtn.textContent = ghostOn ? "👻 Showing Ghost form — tap to revert" : "👻 Preview Ghost form";
    ghostBtn.addEventListener("click", () => {
      team.toggleGhost(sp);
      renderGrid();
      if (team.has(sp)) renderTeam();
      renderDetail();
    });
    el.panel.appendChild(ghostBtn);
  }

  const tabs = document.createElement("div");
  tabs.className = "tabs";
  const tabDefs = [
    ["levelUp", "Level-up"],
    ["tmhm", "TM/HM"],
    ["mutagen", "Mutagenated"],
  ];
  for (const [key, label] of tabDefs) {
    const btn = document.createElement("button");
    btn.className = "tab-btn" + (activeTab === key ? " active" : "");
    btn.type = "button";
    btn.textContent = label;
    btn.addEventListener("click", () => {
      activeTab = key;
      renderDetail();
    });
    tabs.appendChild(btn);
  }
  el.panel.appendChild(tabs);

  if (inTeam) {
    const moveset = team.getMoveset(sp);
    const counter = document.createElement("p");
    counter.className = "moveset-counter";
    counter.textContent = `Moveset: ${moveset.length}/${MAX_MOVESET_SIZE} selected — this is what counts toward type coverage.`;
    el.panel.appendChild(counter);
  } else {
    const note = document.createElement("p");
    note.className = "move-note";
    note.textContent = `Add to team to pick its ${MAX_MOVESET_SIZE}-move set for type coverage.`;
    el.panel.appendChild(note);
  }

  if (activeTab === "levelUp" && pool.levelUp.some((m) => m.base)) {
    const note = document.createElement("p");
    note.className = "move-note";
    note.textContent =
      "\u201cStart\u201d moves are what this Pok\u00e9mon knows when you " +
      "obtain it as this species \u2014 caught, traded, or given. They are " +
      "NOT granted by evolving into it: an evolved Pok\u00e9mon keeps the " +
      "moves it already had and picks these up at the levels listed below.";
    el.panel.appendChild(note);
  }

  if (activeTab === "mutagen" && pool.mutagenNote) {
    const note = document.createElement("p");
    note.className = "move-note";
    note.textContent = pool.mutagenNote;
    el.panel.appendChild(note);
  }
  const listSource = { levelUp: pool.levelUp, tmhm: pool.tmhm, mutagen: pool.mutagen }[activeTab];
  const selectionCtx = inTeam
    ? {
        team,
        sp,
        onToggle: (moveName) => {
          team.toggleMove(sp, moveName);
          renderCoverage();
          renderTeam();
          renderDetail();
        },
      }
    : null;
  el.panel.appendChild(renderMoveList(listSource, activeTab, selectionCtx));
}

init().catch((err) => {
  console.error(err);
  el.grid.innerHTML = `<p style="color:#ff6b7b">Failed to load team builder data: ${err.message}</p>`;
});
