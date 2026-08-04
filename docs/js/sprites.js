// DOM builders for the sprite grid tiles and team slots. Pointer/click
// handlers only (no hover-dependent affordances) so this stays touch-friendly.

export function spriteSrc(data, speciesKey, ghost) {
  const rec = data.species[speciesKey];
  if (ghost && rec.ghost_sprite) return rec.ghost_sprite;
  return rec.front_sprite;
}

export function createTile(data, team, speciesKey, callbacks) {
  const rec = data.species[speciesKey];
  const tile = document.createElement("div");
  tile.className = "tile";
  tile.setAttribute("role", "button");
  tile.setAttribute("tabindex", "0");
  tile.dataset.species = speciesKey;

  const inTeam = team.has(speciesKey);
  const ghostOn = team.isGhostView(speciesKey);
  if (inTeam) tile.classList.add("in-team");
  if (!inTeam && team.isFull()) tile.classList.add("full-disabled");

  const img = document.createElement("img");
  img.className = "sprite";
  img.src = spriteSrc(data, speciesKey, ghostOn);
  img.alt = rec.display_name;
  img.loading = "lazy";
  tile.appendChild(img);

  if (rec.ghost_eligible) {
    const ghostBtn = document.createElement("button");
    ghostBtn.className = "ghost-toggle" + (ghostOn ? " active" : "");
    ghostBtn.type = "button";
    ghostBtn.textContent = "👻";
    ghostBtn.title = "Preview Ghost form";
    ghostBtn.addEventListener("click", (e) => {
      e.stopPropagation();
      callbacks.onToggleGhost(speciesKey);
    });
    tile.appendChild(ghostBtn);
  }

  if (inTeam) {
    const badge = document.createElement("div");
    badge.className = "check-badge";
    badge.textContent = "✓";
    tile.appendChild(badge);
  }

  const name = document.createElement("button");
  name.className = "tile-name";
  name.type = "button";
  name.textContent = rec.display_name;
  name.addEventListener("click", (e) => {
    e.stopPropagation();
    callbacks.onOpenDetail(speciesKey);
  });
  tile.appendChild(name);

  const activate = () => callbacks.onToggleTeam(speciesKey);
  tile.addEventListener("click", activate);
  tile.addEventListener("keydown", (e) => {
    if (e.key === "Enter" || e.key === " ") {
      e.preventDefault();
      activate();
    }
  });

  return tile;
}

export function createTeamSlot(data, team, speciesKey, callbacks) {
  const slot = document.createElement("div");
  slot.className = "team-slot";

  if (!speciesKey) {
    slot.textContent = "empty";
    return slot;
  }

  const rec = data.species[speciesKey];
  slot.classList.add("filled");
  slot.setAttribute("role", "button");
  slot.setAttribute("tabindex", "0");
  slot.title = `Remove ${rec.display_name}`;

  const img = document.createElement("img");
  img.src = spriteSrc(data, speciesKey, team.isGhostView(speciesKey));
  img.alt = rec.display_name;
  slot.appendChild(img);

  const name = document.createElement("div");
  name.className = "slot-name";
  name.textContent = rec.display_name;
  slot.appendChild(name);

  const moveCount = team.getMoveset(speciesKey).length;
  const moves = document.createElement("div");
  moves.className = "slot-moves" + (moveCount === 0 ? " no-moves" : "");
  moves.textContent = `${moveCount}/4 moves`;
  slot.appendChild(moves);

  const remove = () => callbacks.onRemove(speciesKey);
  slot.addEventListener("click", remove);
  slot.addEventListener("keydown", (e) => {
    if (e.key === "Enter" || e.key === " ") {
      e.preventDefault();
      remove();
    }
  });

  return slot;
}
