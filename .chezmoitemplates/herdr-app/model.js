/** @typedef {{kind: "space", id: string, name: string, path: string, machine: string | null} | {kind: "directory", name: string, path: string} | {kind: "link", name: string, url: string}} Row */

// Shared source: chezmoi renders a local copy in each mod's sandbox.
/** @param {unknown} value */
export function screenText(value) {
  if (typeof value !== "object" || value === null || !("text" in value) || typeof value.text !== "string") {
    throw new Error("herdr-core returned an invalid screen snapshot");
  }
  return value.text;
}

/** @param {unknown} value */
export function foregroundName(value) {
  if (typeof value !== "object" || value === null || !("foreground" in value)) return null;
  const foreground = value.foreground;
  if (typeof foreground !== "object" || foreground === null || !("name" in foreground) || typeof foreground.name !== "string") return null;
  return foreground.name.split(/[\\/]/).at(-1)?.replace(/\.exe$/i, "").toLowerCase() ?? null;
}

/** @param {string | null} name */
export function isVim(name) {
  return name !== null && /^g?(view|l?n?vim?x?)(diff)?$/.test(name);
}

/** Visible HTTP(S) URLs only; never pass arbitrary schemes to the OS opener. */
export function extractLinks(text) {
  const clean = text.replace(/\x1b\][^\x07]*(?:\x07|\x1b\\)/g, "").replace(/\x1b\[[0-?]*[ -/]*[@-~]/g, "");
  const urls = new Set();
  for (const match of clean.matchAll(/https?:\/\/[^\s<>\[\]{}|\\^`"\x00-\x1f]+/gi)) {
    let url = match[0].replace(/[,;:!?.'"“”’]+$/g, "");
    while (url.endsWith(")") && (url.match(/\)/g)?.length ?? 0) > (url.match(/\(/g)?.length ?? 0)) url = url.slice(0, -1);
    if (/^https?:\/\/[^/\s]+/i.test(url)) urls.add(url);
  }
  return [...urls];
}

export function normalizedPath(path) {
  return path.replace(/\/+$/, "") || "/";
}

/** @param {import("herdr").SpaceInfo[]} spaces @param {string[]} paths @returns {Row[]} */
export function sessionRows(spaces, paths) {
  const existing = new Set(spaces.filter(s => s.machine === null).map(s => normalizedPath(s.folder)));
  /** @type {Row[]} */
  const rows = spaces.map(s => ({ kind: "space", id: s.id, name: s.name, path: s.folder, machine: s.machine }));
  for (const path of paths) {
    if (!path.startsWith("/")) continue;
    const normalized = normalizedPath(path);
    if (existing.has(normalized)) continue;
    existing.add(normalized);
    rows.push({ kind: "directory", path, name: normalized.split("/").at(-1) || "/" });
  }
  return rows;
}

/** @param {Row[]} rows @param {string} query */
export function filterRows(rows, query) {
  const terms = query.toLowerCase().split(/[\s/_.-]+/).filter(Boolean);
  return rows.filter(row => {
    const text = `${row.name} ${row.kind === "link" ? row.url : row.path}`.toLowerCase();
    return terms.every(term => text.includes(term));
  });
}
