# Lumen docs: a demo of @vite-hub/docs

A docs site for Lumen, a made-up image CLI, built with [`@vite-hub/docs`](https://vitehub.dev/docs/docs-site) and deployed as one Cloudflare Worker. It is an outside consumer of ViteHub: it installs the published preview packages, not the workspace.

Live: <https://vitehub-docs-demo.maximogarciamtnez.workers.dev>

## What it shows

- 24 Markdown pages in 4 sections with categories and icons, a tutorial with the code panel, guides, reference tables, a standalone page (`/about`), callouts, tabs, steps, code groups, and `::agent-only` blocks.
- Agent resources: `/raw/<page>.md`, `/llms.txt`, `/llms-full.txt`, `/sitemap.xml`, `/sitemap.md`, `/robots.txt`, and the docs MCP server at `/mcp`.
- The ViteHub Console at `/_vitehub` with app Auth (Better Auth on D1), the CMS (`docsCollection()` on the GitHub store of this repository), Comments, and the Console MCP server at `/_vitehub/mcp` with OAuth.
- The tools pill on every page for a signed-in editor.

The docs assistant is off: it runs Codex, which needs Node.js, and this site runs on Workers.

## Files

| File | Use |
| --- | --- |
| `nuxt.config.ts` | `vite-hub/nuxt` with the `cloudflare` preset, and `@vite-hub/docs/nuxt` |
| `content/` | The pages |
| `server/auth.ts` | Better Auth: email and password, GitHub, the admin plugin with the CMS roles, and `consoleMcpOAuth()` |
| `server/databases/` | The D1 Database: the Better Auth tables, and the migrations of every table |
| `server/content.ts` | The CMS: `docsCollection()` on the GitHub store, `publish: 'commit'`, `access: 'roles'` |
| `server/comments.ts`, `server/console-authorize.ts` | Comments and Console access with the CMS roles |
| `.github/workflows/deploy.yml` | Builds, applies the D1 migrations, and deploys on each push to `main` |

## Run it

```sh
corepack pnpm install --frozen-lockfile
corepack pnpm run build
corepack pnpm exec wrangler d1 migrations apply vitehub-docs-demo --remote --config .output/server/wrangler.json
corepack pnpm exec wrangler deploy --config .output/server/wrangler.json
```

Worker secrets: `VITEHUB_SECRET` (32 or more characters), `GITHUB_CLIENT_ID` and `GITHUB_CLIENT_SECRET` (GitHub sign-in), and `VITEHUB_GITHUB_TOKEN` (a fine-grained token for this repository, with contents and pull requests read and write). Repository secrets: `CLOUDFLARE_API_TOKEN` and `CLOUDFLARE_ACCOUNT_ID`.

## Patches

The preview packages come from vite-hub/vitehub#3237 at commit `0fe8108`. `patches/` holds the built `dist` of open pull requests that this demo needs. Drop each patch when its pull requests land, and update the preview commit.

| Patch | Pull requests |
| --- | --- |
| `vite-hub` | #3264 (Open in new tab on tool windows), #3265 (pill on prerendered pages and after sign-in), #3266 (Console URL state), #3267 (Console search and filters), #3277 (prerender skips the Console pages), #3280 (Console MCP OAuth discovery on Nitro 2) |
| `@vite-hub/auth` | #3265 (session marker for the pill) |
| `@vite-hub/comments` | #3265, #3267 |
| `@vite-hub/docs` | #3271 (MCP tools as JavaScript), #3276 (auto-imports in an installed package) |

Workarounds in the app, with the finding behind each:

- `console.mcp.resource` in `nuxt.config.ts`: `publicUrl` does not reach the Nitro 2 server bundle of Nuxt 4, so without it the Console MCP answers `CONSOLE_MCP_ORIGIN_REQUIRED`.
- `agents`, `@vite-hub/schedule`, and `@vite-hub/shell` in `dependencies`: the Worker bundle imports them on paths that this app does not use (the docs MCP server on Workers, the Console Schedule route, the Workspace shell), and `wrangler deploy` fails when they are missing.
- `NODE_OPTIONS=--max-old-space-size=6144` in the build script: the Nitro bundle runs out of the default heap.

`pnpm-lock.yaml` has an `integrity` for each pkg.pr.new tarball. pnpm 10.34 refuses a tarball without one on the second install.
