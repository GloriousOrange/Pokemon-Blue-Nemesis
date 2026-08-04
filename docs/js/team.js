// Team membership state: an ordered list of species keys, max 6. Ghost-view
// is tracked separately (per species, cosmetic only -- it never changes a
// species' actual type, so it has no bearing on coverage math).
//
// Moveset is tracked separately too: which up-to-4 moves (from any of the
// three movepool tabs) a team member is actually carrying. This is what
// offensive type coverage is computed from -- a species' full learnable
// movepool is NOT the same as what it currently knows, so e.g. a Charizard
// with no Fire move picked contributes no Fire coverage, only its usual
// Fire/Flying defensive weaknesses.
export const MAX_TEAM_SIZE = 6;
export const MAX_MOVESET_SIZE = 4;

export class TeamState {
  constructor() {
    this.members = [];
    this.ghostView = new Set();
    this.moveset = new Map(); // species key -> ordered array of move names
  }

  isFull() {
    return this.members.length >= MAX_TEAM_SIZE;
  }

  has(species) {
    return this.members.includes(species);
  }

  toggle(species) {
    if (this.has(species)) {
      this.members = this.members.filter((s) => s !== species);
      return true;
    }
    if (this.isFull()) return false;
    this.members.push(species);
    return true;
  }

  remove(species) {
    this.members = this.members.filter((s) => s !== species);
  }

  toggleGhost(species) {
    if (this.ghostView.has(species)) this.ghostView.delete(species);
    else this.ghostView.add(species);
  }

  isGhostView(species) {
    return this.ghostView.has(species);
  }

  getMoveset(species) {
    return this.moveset.get(species) || [];
  }

  hasMove(species, moveName) {
    return this.getMoveset(species).includes(moveName);
  }

  // Returns true if the toggle took effect (add ignored past the 4-move cap).
  toggleMove(species, moveName) {
    const current = this.getMoveset(species);
    if (current.includes(moveName)) {
      this.moveset.set(species, current.filter((m) => m !== moveName));
      return true;
    }
    if (current.length >= MAX_MOVESET_SIZE) return false;
    this.moveset.set(species, [...current, moveName]);
    return true;
  }
}
