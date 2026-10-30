import { View, div } from "gpui-kit";
import { closeOverlay, focused, hc, notify, props, run } from "herdr";
import { foregroundName, isVim } from "./model.js";

/** Capture the source before any asynchronous work; never navigate a new focus. */
export async function navigate(direction, source, api) {
  if (!source?.terminal) return;
  const keys = { left: "ctrl+h", down: "ctrl+j", up: "ctrl+k", right: "ctrl+l" };
  const key = keys[direction];
  if (!key) throw new Error("Invalid navigation direction");
  const result = await api.hc(["get", source.terminal]);
  if (result.code !== 0) throw new Error(result.stderr || "Could not inspect the focused terminal.");
  /** @type {unknown} */
  const terminal = JSON.parse(result.stdout);
  const name = foregroundName(terminal);
  if (api.focused()?.terminal !== source.terminal) return;
  if (name === null || isVim(name)) {
    // Unknown foreground: preserve typing rather than accidentally leaving Vim.
    const sent = await api.hc(["keys", source.terminal, key]);
    if (sent.code !== 0) throw new Error(sent.stderr || "Could not forward the navigation key.");
  } else if (source.pane && api.focused()?.pane === source.pane) {
    api.close();
    api.run("pane.go", { direction });
  }
}

export default class Navigation extends View {
  init(_props, cx) {
    const overlay = props()?.overlay;
    if (!overlay) return; // `herdr-app check` must never move real focus.
    const source = focused();
    let closed = false;
    const close = () => { if (!closed) { closed = true; closeOverlay(overlay); } };
    cx.spawn(async () => {
      try {
        await navigate(this.direction, source, { hc, focused, run, close });
      } catch (error) {
        notify({ title: "Pane navigation failed", body: error instanceof Error ? error.message : "Try again.", level: "error" });
      } finally {
        close();
      }
    });
  }

  render() { return div(); }
}
