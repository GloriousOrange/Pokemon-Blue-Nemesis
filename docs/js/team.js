// Team membership state: an ordered list of species keys, max 6. Ghost-view
// is tracked separately (per species, cosmetic only -- it never changes a
// species' actual type, so it has no bearing on coverage math).
export const MAX_TEAM_SIZE = 6;

export class TeamState {
  constructor() {
    this.members = [];
    this.ghostView = new Set();
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
}
