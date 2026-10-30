// Shared source: chezmoi renders a local copy in each picker mod.
import { View, div } from "gpui-kit";
import { Input, InputState } from "gpui-base";
import { closeOverlay, exec, focused, hc, panes, props, run, spaces, theme } from "herdr";
import { extractLinks, filterRows, normalizedPath, screenText, sessionRows, spacesWithFolders } from "./model.js";

export default class Picker extends View {
  kind = "sessions";

  init(_props, cx) {
    this.source = focused();
    this.paths = [];
    this.links = [];
    this.query = "";
    this.at = 0;
    this.loading = true;
    this.message = "";
    this.alphabetical = false;
    this.handle = cx.focus_handle();
    this.input = InputState.new({ placeholder: this.kind === "links" ? "Filter visible links…" : "Search spaces and zoxide directories…" });
    this.input.on("change", (_event, cx) => { this.query = this.input.value(); this.at = 0; cx.notify(); });
    this.input.on("submit", (_event, cx) => this.choose(cx));
    this.input.focus();
    cx.spawn(async cx => {
      try {
        if (this.kind === "links") {
          if (!this.source?.terminal) throw new Error("Focus a terminal, then press Cmd+P again.");
          const result = await hc(["read", "--json", this.source.terminal]);
          if (result.code !== 0) throw new Error(result.stderr || "Could not read the source terminal.");
          /** @type {unknown} */
          const snapshot = JSON.parse(result.stdout);
          this.links = extractLinks(screenText(snapshot));
        } else {
          const result = await exec("zoxide", ["query", "--list"]);
          if (result.code !== 0) throw new Error("Zoxide history unavailable; showing open spaces.");
          this.paths = result.stdout.split("\n").filter(Boolean);
        }
      } catch (error) {
        this.message = error instanceof Error ? error.message : "Could not load picker entries.";
      }
      this.loading = false;
      cx.notify();
    });
  }

  rows() {
    const rows = this.kind === "links"
      ? this.links.map(url => ({ kind: "link", name: url, url }))
      : sessionRows(spacesWithFolders(spaces(), panes()), this.paths);
    const filtered = filterRows(rows, this.query);
    if (this.alphabetical) filtered.sort((a, b) => a.name.localeCompare(b.name));
    return filtered;
  }

  choose(cx, copy = false) {
    const row = this.rows()[this.at];
    if (!row) return;
    if (row.kind === "link") {
      if (copy) cx.write_to_clipboard(row.url);
      else cx.open_url(row.url);
      closeOverlay(props().overlay);
    } else {
      // Recheck: another screen may have opened this directory while picking.
      const currentSpaces = spacesWithFolders(spaces(), panes());
      const existing = row.kind === "space" ? currentSpaces.find(s => s.id === row.id)
        : currentSpaces.find(s => s.machine === null && normalizedPath(s.folder) === normalizedPath(row.path));
      if (row.kind === "space" && !existing) {
        this.message = "That space was closed. Select another entry.";
        cx.notify();
        return;
      }
      closeOverlay(props().overlay);
      if (existing) run("space.select", { id: existing.id });
      else run("space.new", { name: row.name, folder: row.path });
    }
  }

  render() {
    const t = theme();
    const rows = this.rows();
    this.at = Math.max(0, Math.min(this.at, rows.length - 1));
    const start = Math.max(0, Math.min(this.at - 2, rows.length - 5));
    return div().id("session-picker").track_focus(this.handle).size_full().flex().flex_col().p(16).gap(10)
      .bg(t.popover).text_color(t.foreground).text_size(13)
      .on_key_down((event, cx) => {
        if (event.key === "escape") closeOverlay(props().overlay);
        else if (event.key === "up" || event.key === "down") {
          this.at = Math.max(0, Math.min(rows.length - 1, this.at + (event.key === "up" ? -1 : 1)));
          cx.notify();
        } else if (event.keystroke === "ctrl-y" && this.kind === "links") this.choose(cx, true);
        else if (event.keystroke === "ctrl-s") { this.alphabetical = !this.alphabetical; this.at = 0; cx.notify(); }
        else return;
        cx.stop_propagation();
      })
      .child(div().flex_none().font_semibold().text_size(15).child(this.kind === "links" ? "Visible links" : "Sesh"))
      .child(div().h(36).flex_none().px(10).flex().items_center().border_1().border_color(t.accent).rounded(6).bg(t.background)
        .child(Input.new(this.input).w_full().text_color(t.foreground)))
      .child(div().flex_none().text_color(t.muted).child(this.loading ? "Loading…" : this.message || `${rows.length} entries · ${this.alphabetical ? "alphabetical" : "source order"}`))
      .child(div().flex_1().min_h(0).overflow_y_scrollbar().children(
        rows.length ? rows.slice(start, start + 5).map((row, index) => div()
          .id(`entry-${start + index}`).px(10).py(8).rounded(6).cursor_pointer()
          .bg(start + index === this.at ? t.selected : t.popover)
          .hover(style => style.bg(t.hover))
          .on_click((_event, cx) => { this.at = start + index; this.choose(cx); })
          .child(div().truncate().child(row.name))
          .child(div().text_size(11).text_color(t.muted).truncate().child(
            row.kind === "link" ? "HTTP(S) link" : row.kind === "space" ? `open · ${row.machine ?? "local"} · ${row.path}` : `zoxide · ${row.path}`)))
          : [div().py(16).text_color(t.muted).child(this.loading ? "" : this.kind === "links" ? "No HTTP(S) links in the terminal screen." : "No matching spaces or directories.")]
      ))
      .child(div().flex_none().text_size(11).text_color(t.muted).child(this.kind === "links"
        ? "↑↓ select · Enter open · Ctrl+Y copy · Ctrl+S order · Esc cancel"
        : "↑↓ select · Enter switch / create · Ctrl+S order · Esc cancel"));
  }
}
