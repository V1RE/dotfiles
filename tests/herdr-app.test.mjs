// node --experimental-vm-modules --test tests/herdr-app.test.mjs
import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import test from "node:test";
import vm from "node:vm";
import * as model from "../.chezmoitemplates/herdr-app/model.js";

async function load(name, api) {
  const context = vm.createContext();
  const module = new vm.SourceTextModule(await readFile(new URL(`../.chezmoitemplates/herdr-app/${name}.js`, import.meta.url), "utf8"), { context });
  await module.link(specifier => {
    const values = specifier === "./model.js" ? model
      : specifier === "gpui-kit" ? { View: class {}, div() {} }
      : specifier === "gpui-base" ? { Input: {}, InputState: {} } : { panes: () => [], ...api };
    return new vm.SyntheticModule(Object.keys(values), function () {
      for (const [key, value] of Object.entries(values)) this.setExport(key, value);
    }, { context });
  });
  await module.evaluate();
  return module.namespace;
}

const space = (id, folder, machine = null) => ({ id, folder, machine, name: id });

test("screen boundary rejects invalid core replies", () => {
  assert.equal(model.screenText({ text: "screen" }), "screen");
  for (const invalid of [null, [], {}, { text: 12 }]) assert.throws(() => model.screenText(invalid));
});

test("visible links: punctuation, balanced parentheses, duplicates, ANSI and safe schemes", () => {
  assert.deepEqual(model.extractLinks("[docs](https://example.org/docs). <https://example.org/docs>\nhttps://example.org/a_(b)). https://example.org/next,\nfile:///etc/passwd javascript:alert(1)"),
    ["https://example.org/docs", "https://example.org/a_(b)", "https://example.org/next"]);
  assert.deepEqual(model.extractLinks("\x1b[31mhttps://example.org/red\x1b[0m"), ["https://example.org/red"]);
  assert.deepEqual(model.extractLinks("\x1b]8;;https://hidden.example\x1b\\https://visible.example\x1b]8;;\x1b\\ https://next.example"), ["https://visible.example", "https://next.example"]);
});

test("Sesh merges native spaces and local zoxide paths without mixing remote paths", () => {
  const rows = model.sessionRows([space("local", "/work/local"), space("remote", "/work/remote", "vps")],
    ["/work/local/", "/work/new", "/work/new/", "/work/remote", "relative"]);
  assert.deepEqual(rows.map(row => [row.kind, row.path]), [
    ["space", "/work/local"], ["space", "/work/remote"], ["directory", "/work/new"], ["directory", "/work/remote"],
  ]);
  assert.equal(model.filterRows(rows, "WORK new").length, 1);
  assert.equal(model.filterRows(rows, "nothing").length, 0);
});

test("foreground process boundary and Vim variants", () => {
  for (const name of ["vi", "vim", "nvim", "view", "gvim", "vimdiff", "nvim.exe"]) {
    assert(model.isVim(model.foregroundName({ foreground: { name } })), name);
  }
  for (const value of [null, {}, { foreground: null }, { foreground: { name: 1 } }]) assert.equal(model.foregroundName(value), null);
  assert.equal(model.isVim("opencode"), false);
  assert.equal(model.foregroundName({ foreground: { name: "/usr/bin/zsh" } }), "zsh");
});

test("Sesh resolves live active-tab folders instead of stale space creation folders", () => {
  const spaces = [{ ...space("here", "/home"), tabs: [{ id: "active-tab", active: true }] }];
  const resolved = model.spacesWithFolders(spaces, [
    { tab: "active-tab", cwd: "/other-split", focused: false },
    { tab: "active-tab", cwd: "/live/project", focused: true },
  ]);
  assert.equal(resolved[0].folder, "/live/project");
  assert.equal(model.sessionRows(resolved, ["/live/project"]).length, 1);
  assert.equal(model.spacesWithFolders(spaces, [])[0].folder, "/home");
});

test("navigation sends to Vim, navigates other programs and preserves unknown foreground", async () => {
  const { navigate } = await load("navigation", {
    closeOverlay() {}, focused() {}, hc() {}, notify() {}, props() {}, run() {},
  });
  for (const [name, expected] of [["nvim", "keys"], ["zsh", "pane.go"], [null, "keys"]]) {
    const calls = [];
    const source = { terminal: "t-test", pane: "p-test" };
    await navigate("left", source, {
      focused: () => source,
      hc: async args => {
        calls.push(args);
        return { code: 0, stdout: JSON.stringify({ foreground: name === null ? null : { name } }), stderr: "" };
      },
      run: (name, args) => calls.push([name, args]), close: () => calls.push(["close"]),
    });
    assert.equal(calls.at(-1)[0], expected);
    if (expected === "keys") assert.deepEqual([...calls.at(-1)], ["keys", "t-test", "ctrl+h"]);
    else assert.equal(calls.at(-2)[0], "close");
  }
});

test("navigation cancels on changed focus, missing terminal and failed process lookup", async () => {
  const { navigate } = await load("navigation", {
    closeOverlay() {}, focused() {}, hc() {}, notify() {}, props() {}, run() {},
  });
  const source = { terminal: "t-test", pane: "p-test" };
  const calls = [];
  const api = {
    focused: () => ({ terminal: "t-other", pane: "p-other" }),
    hc: async args => { calls.push(args); return { code: 0, stdout: '{"foreground":{"name":"zsh"}}', stderr: "" }; },
    run: () => assert.fail("must not navigate changed focus"), close() {},
  };
  await navigate("right", source, api);
  await navigate("down", null, api);
  assert.equal(calls.length, 1);
  await assert.rejects(navigate("left", source, { ...api, hc: async () => ({ code: 1, stderr: "lookup failed" }) }), /lookup failed/);
});

test("Sesh reuses a newly opened space and rejects closed spaces", async () => {
  let current = [];
  const calls = [];
  const { default: Picker } = await load("picker", {
    closeOverlay: id => calls.push(["close", id]), exec() {}, focused() {}, hc() {}, props: () => ({ overlay: "test" }),
    run: (name, args) => calls.push([name, args]), spaces: () => current, theme() {},
  });
  const picker = new Picker();
  picker.rows = () => [{ kind: "directory", name: "new", path: "/work/new" }];
  picker.at = 0;
  const cx = { notify() {} };
  picker.choose(cx);
  assert.equal(calls.at(-1)[0], "space.new");
  current = [space("already-open", "/work/new")];
  picker.choose(cx);
  assert.equal(calls.at(-1)[0], "space.select");
  assert.equal(calls.at(-1)[1].id, "already-open");
  const count = calls.length;
  picker.rows = () => [{ kind: "space", id: "closed", name: "closed", path: "/work/closed", machine: null }];
  picker.choose(cx);
  assert.equal(calls.length, count);
  assert.match(picker.message, /closed/);
});

test("link activation and clipboard actions happen only on explicit selection", async () => {
  const calls = [];
  const { default: Picker } = await load("picker", {
    closeOverlay: id => calls.push(["close", id]), exec() {}, focused() {}, hc() {}, props: () => ({ overlay: "test" }),
    run() {}, spaces: () => [], theme() {},
  });
  const picker = new Picker();
  picker.rows = () => [{ kind: "link", name: "https://example.org", url: "https://example.org" }];
  picker.at = 0;
  const cx = { open_url: url => calls.push(["open", url]), write_to_clipboard: url => calls.push(["copy", url]) };
  assert.equal(calls.length, 0);
  picker.choose(cx, true);
  picker.choose(cx);
  assert.deepEqual(calls.map(call => call[0]), ["copy", "close", "open", "close"]);
});
