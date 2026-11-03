# Lumen docs: a demo of @vite-hub/docs

A docs site for Lumen, a made-up image CLI, built with [`@vite-hub/docs`](https://vitehub.dev/docs/docs-site) and deployed as one Cloudflare Worker. It is an outside consumer of ViteHub: it installs the published preview packages, not the workspace.

Live: <https://vitehub-docs-demo.maximogarciamtnez.workers.dev>

## What it shows

- 24 Markdown pages in 4 sections with categories and icons, a tutorial with the code panel, guides, reference tables, a standalone page (`/about`), callouts, tabs, steps, code groups, and `::agent-only` blocks.
- A landing page (`app/pages/index.vue`) whose title, description, and body are `content/index.md`, with the latest release and posts from the CMS.
- Three CMS collections beside the docs: a blog (`/blog`, 5 posts), a changelog (`/changelog`, 7 releases), and authors (4). They exist only in the CMS, and the site reads the published documents on each request, so a publish is live within a minute. RSS at `/blog/rss.xml` and `/changelog/rss.xml`.
- Five isometric illustrations, each in a light and a dark file, in the media library of the Console and served at `/media/illustrations/`.
- Agent resources: `/raw/<page>.md`, `/llms.txt`, `/llms-full.txt`, `/sitemap.xml`, `/sitemap.md`, `/robots.txt`, and the docs MCP server at `/mcp`.
- The ViteHub Console at `/_vitehub` with app Auth (Better Auth on D1), the CMS (`docsCollection()`), Comments, and the Console MCP server at `/_vitehub/mcp` with OAuth.
- The tools pill on every page for a signed-in editor.

The docs assistant is off: it runs Codex, which needs Node.js, and this site runs on Workers.

## Files

| File | Use |
| --- | --- |
| `nuxt.config.ts` | `vite-hub/nuxt` with the `cloudflare` preset, and `@vite-hub/docs/nuxt` |
| `content/` | The docs pages |
| `app/pages/`, `app/components/` | The landing, blog, and changelog pages, and the `::illustration` and `::illustrated-cards` blocks |
| `blog/`, `changelog/`, `authors/` | The seed of the CMS collections. `scripts/seed-content.mjs` saves and publishes them through `vitehub content` |
| `illustrations/` | The generators and the SVG files of the illustrations. `scripts/upload-illustrations.mjs` uploads them to the media library |
| `.claude/skills/illustration-isometric-mono/` | The illustration skill from [skills.sh](https://skills.sh/mengto/skills/illustration-isometric-mono), copied by hand, see below |
| `server/auth.ts` | Better Auth in the `users` Database through `authDatabase("users")`: email and password, GitHub when its secrets exist, the admin plugin with the CMS roles, and `consoleMcpOAuth()` |
| `server/databases/users/`, `server/databases/content/` | Two D1 Database Definitions and their migrations. `users`: the Better Auth and OAuth tables. `content`: the CMS history and editor sessions, and the Comments tables |
| `server/content.ts` | The CMS with `access: 'roles'` and `database: 'content'`: `docsCollection()`, and the `blog`, `changelog`, and `authors` collections. Today on the Blob + Database store (R2 and D1). With a GitHub token it moves to the GitHub store of this repository with `publish: 'commit'`, see the comment in the file |
| `server/comments.ts`, `server/console-authorize.ts` | Comments in the `content` Database (`database: "content"`), and Console access with the CMS roles |
| `server/api/blog/`, `server/api/changelog/`, `server/routes/*/rss.xml.get.ts` | The published posts and releases, parsed with the docs parser, and the feeds |
| `.github/workflows/deploy.yml` | Builds, applies the D1 migrations, and deploys on each push to `main` |

## Run it

```sh
corepack pnpm install --frozen-lockfile
corepack pnpm run build
corepack pnpm exec wrangler d1 migrations apply vitehub-docs-demo-users --remote --config .output/server/wrangler.json
corepack pnpm exec wrangler d1 migrations apply vitehub-docs-demo-content --remote --config .output/server/wrangler.json
corepack pnpm exec wrangler deploy --config .output/server/wrangler.json
```

On a new deploy, seed the CMS and the media library with a signed-in admin's session cookie:

```sh
VITEHUB_CONSOLE_COOKIE="..." node scripts/upload-illustrations.mjs https://vitehub-docs-demo.maximogarciamtnez.workers.dev
VITEHUB_CONSOLE_COOKIE="..." node scripts/seed-content.mjs https://vitehub-docs-demo.maximogarciamtnez.workers.dev
```

Worker secrets: `VITEHUB_SECRET` (32 or more characters), `VITEHUB_CONTENT_KEY` (32 random bytes, for the Console preview), and `VITEHUB_ADMIN_EMAILS` (the emails that get the admin role on their first sign-up or GitHub sign-in). Not set yet: `GITHUB_CLIENT_ID` and `GITHUB_CLIENT_SECRET` (GitHub sign-in), and `VITEHUB_GITHUB_TOKEN` (a fine-grained token for this repository, with contents and pull requests read and write, for the GitHub store).

Resources: the Worker `vitehub-docs-demo`, the D1 databases `vitehub-docs-demo-users` (binding `DB_USERS`) and `vitehub-docs-demo-content` (binding `DB_CONTENT`), and the R2 buckets `vitehub-docs-demo` (binding `BLOB`, the CMS documents, not served) and `vitehub-docs-demo-media` (binding `BLOB_MEDIA`, the media library, served at `/media`). The D1 database `vitehub-docs-demo` is the old single database. The site no longer uses it; its rows were copied to the two new databases on 2026-11-03, and it stays for a rollback until someone deletes it. Repository secrets: `CLOUDFLARE_API_TOKEN` and `CLOUDFLARE_ACCOUNT_ID`.

## Packages

The ViteHub packages are the pkg.pr.new previews of vite-hub/vitehub `main` at commit `88e965a`, which has every fix that this demo found before (#3271, #3276, #3277, #3280, #3284) and the Auth tables of #3278. `pnpm-lock.yaml` has an `integrity` for each pkg.pr.new tarball: pnpm 10.34 refuses a tarball without one on the next install, and `pnpm patch-commit` drops them, so put them back after a patch change.

One patch, until [vite-hub/vitehub#3294](https://github.com/vite-hub/vitehub/pull/3294) lands:

- `patches/@vite-hub__blob@0.0.0-preview-88e965a.patch`: the generated Blob serve route (`.vitehub/blob/serve-route.ts`) uses H3 helpers, and ViteHub resolves `h3` in `.vitehub/` to H3 2, but Nuxt 4 calls the route with H3 1 events. Every `/media/*` request answered 400 "Invalid URL string.". The patch makes the route read and write the event without H3 helpers, like #3294. Remove the patch when the packages move to a `main` commit with #3294.

Workarounds in the app, with the finding behind each:

- `console.authorize` is an absolute path in `nuxt.config.ts`: with an `app/` folder, ViteHub resolves a relative path from `app/`, so `./server/console-authorize.ts` fails the build. Fixed by [vite-hub/vitehub#3292](https://github.com/vite-hub/vitehub/pull/3292); the absolute path keeps working after it.
- `routeRules` with `swr: 60` cache text, not a `Response`, so the RSS routes return a string and set the content type.
- `console.mcp.resource` in `nuxt.config.ts`: `publicUrl` does not reach the Nitro 2 server bundle of Nuxt 4, so without it the Console MCP answers `CONSOLE_MCP_ORIGIN_REQUIRED`.
- `nitro.cloudflare.wrangler.assets.run_worker_first` for the docs pages and `/api/_docs/*`: without it the static prerendered pages answer first, so the Console preview pane stays blank and `Accept: text/markdown` gets HTML.
- `agents`, `@vite-hub/schedule`, and `@vite-hub/shell` in `dependencies`: the Worker bundle imports them on paths that this app does not use (the docs MCP server on Workers, the Console Schedule route, the Workspace shell), and `wrangler deploy` fails when they are missing.
- `NODE_OPTIONS=--max-old-space-size=6144` in the build script: the Nitro bundle runs out of the default heap.

## Illustrations

The illustrations follow the skill [`illustration-isometric-mono`](https://skills.sh/mengto/skills/illustration-isometric-mono) of mengto/skills: true isometric dioramas on one slab, generated as SVG from a kit. `npx skills add mengto/skills --skill illustration-isometric-mono` cannot install it (the CLI fails to parse the `description` of its SKILL.md and skips it), so it is copied from commit `1de14e2` of the repository into `.claude/skills/`. The one deliberate change is the palette: a zinc ramp for light and another for dark, in `illustrations/iso.mjs`, instead of the skill's green, so they match the black, white, and zinc theme of the docs.

Rebuild one: `node illustrations/hero.gen.mjs illustrations/svg/hero-light.svg "Lumen" --theme light`. Check it with `node illustrations/lint.mjs <file> --prefix <prefix>` and `node illustrations/ramp-check.mjs <file>`.

## Review

Comment on the live pages with ViteHub Comments: sign in to the Console, open the page tools, and comment on a page. An Agent connected through MCP can read and answer the comments.
