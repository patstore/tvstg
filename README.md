# PatStore Starter

An [Octane](https://octanejs.dev/) + [Vite](https://vite.dev/) website starter with file-based routing, navigation, theme switching, GSAP page transitions, Lenis smooth scrolling, and optional PatStore CMS integration.

## Create a project

This repository is a **GitHub template**. Create a new repo (and a local folder) from it:

```bash
gh repo create my-site --template patstore/patstore-starter --clone --private
cd my-site
```

Or click **Use this template** on GitHub, then clone the new repo into any folder.

The new `package.json` still has `"name": "patstore-starter"` — rename it to your app name.

### After cloning

`@patstore/*` packages come from GitHub Packages. Authenticate once in your user npm config (do not put a token in this repo’s `.npmrc`):

```bash
npm login --scope=@patstore --registry=https://npm.pkg.github.com
```

Use a GitHub PAT with `read:packages`. Then:

```bash
cp .env.example .env   # fill in your PatStore keys
npm install
npm run dev
```

Open the URL shown in the terminal (typically `http://localhost:5173`).

## Requirements

- **Node.js 22+** (required by Octane)

## Stack

| Package | Purpose |
| --- | --- |
| [octane](https://octanejs.dev/) | UI framework (TSRX components) |
| [vite](https://vite.dev/) | Dev server & bundler |
| [gsap](https://gsap.com/) | Page transition animations |
| [lenis](https://lenis.darkroom.engineering/) | Smooth scrolling |
| [@octanejs/lucide](https://octanejs.dev/docs/bindings) | Icons (Octane port of lucide-react) |
| [@octanejs/usehooks-ts](https://octanejs.dev/docs/bindings) | Utility hooks (Octane port of usehooks-ts) |
| [sass](https://sass-lang.com/) | SCSS styling |
| [graphql-request](https://github.com/graffle-js/graphql-request) | Runtime PatStore GraphQL client |

## Scripts

```bash
npm run dev             # Start dev server
npm run build           # Production build
npm run preview         # Preview production build
npm run typecheck       # Run tsrx-tsc (generates page routes first)
npm run generate:pages  # Regenerate src/pages/.generated/ from src/pages/
npm run lint            # ESLint
npm run doctor          # Octane configuration checks
```

## Project structure

```
src/
├── App.tsrx
├── main.ts
├── cms/                     # PatStore runtime data layer
│   └── content/             # Applies synced data-cms content to the DOM
├── components/              # Layout, header, CMS sections, SEO
├── context/                 # Theme, router, document language
├── pages/                   # File-based routes (author here)
│   └── .generated/          # Auto-generated PageRouter + matchRoute (gitignored)
└── styles/
data/                        # Generated build-time data + CMS manifest/content (gitignored, except access.ts/index.ts/types.ts)
```

The `octane-pages` (file-based routing) and `cms-content` (data-cms scanning/sync) Vite plugins, along with the PatStore SSG plugin, live in [`patstore-kit`](https://github.com/patstore/patstore-kit) as `@patstore/octane-pages-plugin`, `@patstore/cms-content-plugin`, `@patstore/core`, and `@patstore/vite-plugin`.

## File-based routing

Routes are defined by **files in `src/pages/`**, using [TanStack Start](https://tanstack.com/start/latest/docs/framework/react/guide/routing) naming. The `octane-pages` Vite plugin generates a router on dev/build — no manual route registry.

### Conventions

- All route **filenames and folders must be lowercase** (`.tsrx` only)
- **`index.tsrx`** → `/`
- **`about.tsrx`** → `/about`
- **`posts/$post_id.tsrx`** → `/posts/:post_id` (`params.post_id`)
- **`404.tsrx`** → not a URL; used as the not-found page
- Files/folders starting with `_` or `.` are ignored

### Optional language prefix — `(lang)/`

Pages inside `(lang)/` match **with and without** a locale prefix:

| File | URLs |
| --- | --- |
| `(lang)/artikel.tsrx` | `/artikel`, `/de/artikel`, `/en/artikel` |

On prefixed URLs, `matchRoute(path)?.params.lang` is set (e.g. `"de"`). For a **required** prefix only, use `$lang/artikel.tsrx` instead.

`RouterContext` syncs `document.documentElement.lang` from `params.lang` (default `en`, matching `index.html`).

### Adding a page

1. Create `src/pages/my-page.tsrx` with a exported page component
2. Dev server regenerates routes automatically (or run `npm run generate:pages`)
3. Navigate via `useRouter().navigate('/my-page')`

Example dynamic page:

```tsrx
import { matchRoute } from '../.generated/routes.ts';
import { useRouter } from '../../context/RouterContext.tsrx';

export function PostPage() @{
  const { path } = useRouter();
  const postId = matchRoute(path)?.params.post_id ?? '';

  <section class="page">
    <h1>{postId as string}</h1>
  </section>
}
```

File: `src/pages/posts/$post_id.tsrx`

### Current routes (examples)

| Path | File |
| --- | --- |
| `/` | `index.tsrx` |
| `/about` | `about.tsrx` |
| `/artikel`, `/de/artikel` | `(lang)/artikel.tsrx` |
| `/articles/:article_id` | `articles/$article_id.tsrx` |
| *(unknown)* | `404.tsrx` |

Do **not** edit `src/pages/.generated/` by hand.

## PatStore CMS data layer

Runtime fetching from PatStore (Parse/SASHIDO), with **SSG build-time fetch** via `@patstore/vite-plugin`:

Shared packages live in [`patstore-kit`](https://github.com/patstore/patstore-kit) (`@patstore/core`, `@patstore/vite-plugin`). Published via GitHub Packages — see [`patstore-kit/docs/PUBLISHING.md`](https://github.com/patstore/patstore-kit/blob/main/docs/PUBLISHING.md).

```
Build (dev/buildStart)                Runtime (fallback)
─────────────────────                 ──────────────────
PATSTORE_MASTER_KEY                   VITE_PATSTORE_CLIENT_KEY
        ↓                                     ↓
SSG fetch → data/build-time-data.json   GraphQL in browser
        ↓                                     ↓
fetchPatStoreCollection() ─── prefers static when generated
```

### SSG setup

1. Add `PATSTORE_MASTER_KEY` to `.env` (server-only, not bundled)
2. Run `npm run dev` or `npm run build` — plugin fetches CMS data into `data/` and downloads files into `asset/`
3. `fetchPatStoreCollection()` resolves instantly from static JSON when `_meta.generatedAt` is set
4. File fields are rewritten to local paths (`/asset/...`) — use `file.url` or `file_local` in components
5. **Incremental sync** on each dev/build: only new/changed records (by `updatedAt`) re-download assets; deleted CMS entries and orphaned files are removed

Disable SSG: `VITE_PATSTORE_SSG=false`  
Force runtime fetch: `VITE_PATSTORE_USE_STATIC=false`  
Skip asset download: `VITE_PATSTORE_DOWNLOAD_ASSETS=false`

### Runtime layer (fallback)

```
QuerySpec (component)
    ↓
Query Planner        — compiles Module metadata + spec → ExecutionPlan
    ↓
Execution Plan       — agnostic step list (not Promises)
    ↓
Resource Manager     — executes steps, resolves file URLs
    ↓
Cache-aware Resource — deduplicates in-flight fetches
    ↓
usePatStoreData()    — Octane use() in TSRX components
```

Data is **not stored globally** — each component calls `usePatStoreData`, `usePatStoreCollection`, or `usePatStoreObject` with its own `QuerySpec`. The cache only deduplicates identical requests.

### Environment variables

Copy `.env.example` to `.env`:

| Variable | Purpose |
| --- | --- |
| `VITE_PATSTORE_API_URL` | Parse REST base URL |
| `VITE_PATSTORE_GRAPHQL_API_URL` | GraphQL endpoint |
| `VITE_PATSTORE_APP_ID` | Application ID |
| `VITE_PATSTORE_CLIENT_KEY` | Browser-safe client key |
| `VITE_PATSTORE_REST_KEY` | Optional REST key (tooling) |
| `VITE_PATSTORE_FILE_URL` | File asset base URL |
| `VITE_PATSTORE_PROJECT_ID` | Project filter for Module queries |
| `PATSTORE_MASTER_KEY` | Server-only key for SSG fetch (not bundled) |

### Usage in TSRX

```tsrx
import { usePatStoreCollection } from '../cms/hooks/usePatStoreData.ts';

export function MySection() @{
  @try {
    const articles = usePatStoreCollection('Article', { limit: 10 });
    <ul>...</ul>
  } @pending {
    <p>Loading…</p>
  } @catch (_e) {
    <p>Failed to load.</p>
  }
}
```

See `src/components/CmsArticles.tsrx` for a working example on the Home page.

## CMS page content (`data-cms`)

`@patstore/cms-content-plugin` ([`patstore-kit/packages/cms-content-plugin`](https://github.com/patstore/patstore-kit/tree/main/packages/cms-content-plugin)) scans page markup for editable content, nested inside named sections, and syncs it with PatStore, so simple page copy (headings, ledes, CTAs) can be edited in the CMS without touching code.

```
1. Scan   src/pages/**/*.tsrx for data-cms-section / data-cms / data-cms-collection.
             A page's (lang)/$lang prefix variants collapse to one canonical,
             language-agnostic path (e.g. /$lang/artikel -> /artikel)
2. Langs   → fetch Project.settings.languages from PatStore (falls back to
             [DEFAULT_LANG] if absent) — the set of languages synced below
3. Manifest → data/cms-manifest.json (nested field schema + scanned defaults) —
             the same nested object is pushed to PatStore's page_content field,
             fully overwritten whenever code changes it (drives PatStore's editor UI)
4. Sync    → flatten manifest to { path, value } pairs (e.g. "page.hero.eyebrow"),
             for each canonical path x each language: find/create a Webpage
             record (project + path + lang), append any new paths to page_data
             — never overwrites values already edited in the CMS
5. Fetch   → merged content (page_data, CMS values over defaults) written to
             data/cms-content.json / cms-content-data.ts, nested by path then lang
6. Apply   → RouterContext resolves the route's lang and fills [data-cms]
             elements with that language's content on every route change
7. Build   → same pipeline runs on `vite build`
```

### Authoring editable content

Fields are only collected when nested inside a `data-cms-section` wrapper — content outside any section is ignored:

```tsrx
<section data-cms-section="page" data-cms-label="Seite">
	<header data-cms-section="hero" data-cms-label="Hero">
		<p data-cms="eyebrow" data-cms-label="Hero Eyebrow">Welcome</p>
		<h1 data-cms="title" data-cms-label="Hero Title">Home</h1>
		<a data-cms="cta" href="/contact">Contact us</a>
		<img data-cms="image" data-cms-label="Hero Image" src="/img/hero.jpg" />
	</header>
</section>
```

- `data-cms-section="key"` — names a nested group; sections can nest arbitrarily deep. `type` is derived from the wrapping tag (`section`, `header`, `footer`, `article`, `aside`, `nav`, `main` map 1:1, anything else falls back to `section`)
- `data-cms="key"` — a leaf field, relative to its nearest section; the element's tag decides the field type: `img` → `image` (from `src`), `a` → `link` (`{ text, href }`), everything else → `text` (from the element's text content)
- `data-cms-label="..."` — human-readable label (used for both sections and fields); falls back to a title-cased version of the key
- Only **static routes** are scanned (routes with a `$param` other than the `(lang)/$lang` prefix are skipped — per-record content belongs to PatStore collections, not page content)

This produces a nested manifest per page, e.g.:

```json
{
	"page": {
		"type": "section",
		"label": "Seite",
		"content": {
			"hero": {
				"type": "header",
				"label": "Hero",
				"content": {
					"eyebrow": { "type": "text", "label": "Hero Eyebrow", "default": "Welcome" },
					"title": { "type": "text", "label": "Hero Title", "default": "Home" }
				}
			}
		}
	}
}
```

### Collections

Wrap a repeated item template with `data-cms-collection="key"` inside a section; direct children with `data-cms="field"` describe one item's schema (scanned from the first rendered template):

```tsrx
<section data-cms-section="team" data-cms-label="Team">
	@for (member of teamMembers; key member.id) {
		<div data-cms-collection="members" data-cms-label="Team Members">
			<h3 data-cms="name">Jane Doe</h3>
			<p data-cms="role">Designer</p>
		</div>
	}
</section>
```

### PatStore schema

Content is stored on one `Webpage` record **per `path` per language**, keyed to the current `VITE_PATSTORE_PROJECT_ID` via a `project` Pointer field. Two fields work together — one describes the editable fields, the other holds their values:

| Field | Type | Purpose |
| --- | --- | --- |
| `project` | Pointer (`Project`) | Multi-tenant scoping, same as `Module` |
| `path` | String | Canonical, language-agnostic route path, e.g. `/`, `/about`, `/artikel` (never includes a `(lang)`/`$lang` prefix) |
| `lang` | String | Language this record's content belongs to, e.g. `en`, `de` — see [Language-aware sync](#language-aware-sync) below |
| `page_content` | Object | The nested manifest (`{ type, label, content/default }` per key) — drives which fields PatStore's editor renders. **Fully overwritten** from the current scan whenever it drifts from code (never hand-edit this one). Identical across languages for the same `path` |
| `page_data` | Array | `[{ "path": "page.hero.eyebrow", "value": "Welcome" }, ...]` — the editor's saved values, read back by the site. The full dot path from the manifest is the array entry's `path`, so no Mongo dot-key restriction ever applies (paths are string *values*, not object keys). Only **appended to** — new paths from code changes are added, values already edited in the CMS are never overwritten |

Configure via env (see `.env.example`): `VITE_CMS_CONTENT_SYNC`, `VITE_CMS_CONTENT_CLASS` (default `Webpage`), `VITE_CMS_CONTENT_FIELD` (default `page_data`), `VITE_CMS_CONTENT_SCHEMA_FIELD` (default `page_content`), `VITE_PATSTORE_PROJECT_CLASS` (default `Project`, set to `""` if `project` is a plain string field). Uses the same `PATSTORE_MASTER_KEY` / `VITE_PATSTORE_REST_KEY` as the SSG fetcher.

At runtime, `applyPageContent` rebuilds each element's full path by walking up through its ancestor `[data-cms-section]` wrappers, so the same relative key (e.g. `title`) can be reused in different sections without collisions.

Run `npm run generate:cms-content` to (re)write `data/cms-manifest.json` / `data/cms-content.json` / `data/cms-content-data.ts` from scanned defaults only (no network) — useful for a fresh clone before `npm run typecheck`. This offline path has no PatStore `Project` to read, so it only ever produces content for a single language, read from `DEFAULT_LANG` in `.env`.

#### Language-aware sync

Which languages get synced is **not** an env var — it's read from PatStore itself, once per sync run:

```
GET Project.settings.languages   e.g. ["en", "de"]
  → found & non-empty  → sync a Webpage record per path per language in the list
  → missing / empty    → sync a single Webpage record per path, lang = DEFAULT_LANG
```

To enable multiple languages, add a `languages` array to the `Project` record's `settings` object in PatStore (e.g. `{ "languages": ["en", "de"] }`) — no code or `.env` change needed. At runtime, the language for a given page load is resolved from the route itself (the `(lang)/` segment, falling back to `DEFAULT_LANG`), via the same `resolveDocumentLang` used for `<html lang>`.

**Migration note:** `Webpage` records created before this field existed have no `lang` value. Rather than duplicating them, the sync looks up `{project, path}` with no `lang` set whenever it can't find an exact `{project, path, lang}` match for the *default* language, and adopts that legacy record — backfilling `lang` onto it on the next update instead of creating a new row. This only ever happens once per record, the first time the pipeline runs after this change.

### Live preview mode (`PREVIEW_ENABLED`)

By default, `getContentForPath` reads the static `data/cms-content.json` snapshot — a copy of PatStore's content taken at the last dev-server start / build / `.tsrx` change. Edits made directly in the CMS after that point aren't picked up until the pipeline reruns.

Set `PREVIEW_ENABLED=true` (see `.env.example`) to additionally fetch content client-side, straight from PatStore, alongside the existing static path:

```
1. RouterContext still applies the static snapshot first (instant, no network — unchanged default behavior)
2. If PREVIEW_ENABLED — src/provider/content/live-content.ts queries PatStore's GraphQL API
   (browser-safe VITE_PATSTORE_CLIENT_KEY) for the current Webpage.page_data by path
3. The result overlays the static content via the same applyPageContent(), and is
   re-polled every 5s (RouterContext.tsrx) while the route stays mounted
```

`PREVIEW_ENABLED` has no `VITE_` prefix, so it isn't bundled automatically — it's exposed to client code via an explicit `define` in `vite.config.ts` (same pattern as `DEFAULT_LANG`), and typed in `src/types/shims.d.ts`. Live fetches silently no-op if PatStore isn't configured (`isPatStoreConfigured()`) or if no `Webpage` record exists yet for the path.

## Features

- **File-based routing** — TanStack Start-style pages in `src/pages/`, optional `(lang)/` prefix
- **Navigation** — sticky header with active route styling
- **Dark / light mode** — `ThemeContext` with `localStorage` persistence
- **Page transitions** — GSAP fade + slide on route change
- **Document language** — `<html lang>` updated from route locale
- **Smooth scroll** — Lenis initialized in `main.ts`

## Octane setup

This project was initialized with `octane init --mode spa`. Run `npm run doctor` to verify TypeScript, Vite, and dependency configuration.
