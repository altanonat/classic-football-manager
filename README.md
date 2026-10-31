# Classic Football Manager — web version (GitHub Pages)

The **same game** as the desktop app, running fully in the browser: the
exact Rust engine (`apps/core`, `apps/simulation`, `apps/competitions`,
`apps/rules`, `apps/transfers`, `apps/ai_manager`) compiled to WebAssembly,
driving the exact Svelte UI. No server, no account, works offline after the
first load. Saves persist in the browser (IndexedDB).

## Run it locally

```bash
./web/build.sh            # needs Rust stable + wasm32 target, wasm-pack, Node 20+
python3 -m http.server 8000 --directory web/dist
# open http://localhost:8000
```

`web/dist/` is build output (git-ignored); the committed sources are
`apps/web/` (WASM shell), `apps/webcore/` (command core shared with the
desktop shell) and `apps/desktop/src/` (UI, with the `__WEB__` transport
switch in `src/lib/api.ts`).

## Publish to GitHub Pages

1. Push this repo to GitHub.
2. The workflow in `.github/workflows/pages.yml` builds `web/dist` on
   every push to `main` and deploys it to Pages automatically.
3. In the repo: Settings → Pages → Source: **GitHub Actions**.
4. Your game is live at `https://<you>.github.io/<repo>/`.

No Pages settings are needed for the base path: the build uses relative
asset URLs, so project pages, user pages and custom domains all work.

## Notes / differences from desktop

- First load downloads ~5 MB of WebAssembly (all 64 leagues ride along),
  then starting a career builds the world in a few seconds.
- Saves live in IndexedDB (per browser/profile); desktop save files are
  SQLite and are **not** interchangeable with web saves.
- Same deterministic engine and rules; same UI, including the attribute
  search, live minute-by-minute matches and season transitions.
