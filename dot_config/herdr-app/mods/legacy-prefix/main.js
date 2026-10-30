import { View, div } from "gpui-kit";
import { closeOverlay, focused, props, run, theme } from "herdr";

// Only native equivalents: legacy plugin actions deliberately remain unbound.
export function actionFor(key) {
  switch (key) {
    case "h":
    case "l": return { name: "pane.split", args: { direction: "right" } };
    case "j":
    case "k": return { name: "pane.split", args: { direction: "down" } };
    case "x": return { name: "pane.close" };
    case "z": return { name: "pane.zoom" };
    case "b": return { name: "layout.toggle", args: { id: "sidebar" } };
    case "s": return { name: "app.settings" };
    case "?":
    case "shift-/": return { name: "app.help" };
    case "w": return { name: "mod.open", args: { name: "picker" } };
    case "shift-n": return { name: "space.new" };
    case "shift-w": return { name: "space.rename" };
    case "shift-d": return { name: "space.close" };
    case "shift-t": return { name: "tab.rename" };
    default:
      if (/^[1-9]$/.test(key)) return { name: "tab.select", args: { index: Number(key) } };
      return null;
  }
}

export default class LegacyPrefix extends View {
  init(_props, cx) {
    this.pane = focused()?.pane;
    this.handle = cx.focus_handle();
    this.handle.focus();
  }

  render() {
    const t = theme();
    return div().id("legacy-prefix").track_focus(this.handle)
      .size_full().p(16).bg(t.popover).text_color(t.foreground).text_size(13)
      .on_key_down((event, cx) => {
        cx.stop_propagation();
        closeOverlay(props().overlay);
        const action = actionFor(event.keystroke);
        if (!action) return;
        if (action.name.startsWith("pane.")) {
          if (this.pane) run(action.name, { ...action.args, pane: this.pane });
        } else {
          run(action.name, action.args);
        }
      })
      .child(div().font_semibold().mb(10).child("Cmd+B · prefix"))
      .child(div().mb(6).child("h / l  split right     j / k  split down"))
      .child(div().mb(6).child("x close pane · z zoom · b sidebar"))
      .child(div().text_color(t.muted).child("s settings · w picker · 1–9 tabs · Esc cancel"));
  }
}
