# Lumen docs: a demo of @vite-hub/docs

A docs site for Lumen, a made-up image CLI, built with [`@vite-hub/docs`](https://vitehub.dev/docs/docs-site) and deployed as one Cloudflare Worker. It is an outside consumer of ViteHub: it installs the published preview packages, not the workspace.

Live: <https://vitehub-docs-demo.maximogarciamtnez.workers.dev>

## What it shows

- 24 Markdown pages in 4 sections with categories and icons, a tutorial with the code panel, guides, reference tables, a standalone page (`/about`), callouts, tabs, steps, code groups, and `::agent-only` blocks.
- Agent resources: `/raw/<page>.md`, `/llms.txt`, `/llms-full.txt`, `/sitemap.xml`, `/sitemap.md`, `/robots.txt`, and the docs MCP server at `/mcp`.
- The ViteHub Console at `/_vitehub` with app Auth (Better Auth on D1), the CMS (`docsCollection()`), Comments, and the Console MCP server at `/_vitehub/mcp` with OAuth.
- The tools pill on every page for a signed-in editor.

The docs assistant is off: it runs Codex, which needs Node.js, and this site runs on Workers.

## Files

| File | Use |
| --- | --- |
| `nuxt.config.ts` | `vite-hub/nuxt` with the `cloudflare` preset, and `@vite-hub/docs/nuxt` |
| `content/` | The pages |
| `server/auth.ts` | Better Auth on D1 through `authDatabase()`: email and password, GitHub when its secrets exist, the admin plugin with the CMS roles, and `consoleMcpOAuth()` |
| `server/databases/` | The D1 Database Definition and the migrations of every table that Auth, the CMS, and Comments add |
| `server/content.ts` | The CMS: `docsCollection()` with `access: 'roles'`. Today on the Blob + Database store (R2 and D1). With a GitHub token it moves to the GitHub store of this repository with `publish: 'commit'`, see the comment in the file |
| `server/comments.ts`, `server/console-authorize.ts` | Comments and Console access with the CMS roles |
| `.github/workflows/deploy.yml` | Builds, applies the D1 migrations, and deploys on each push to `main` |

## Run it

```sh
corepack pnpm install --frozen-lockfile
corepack pnpm run build
corepack pnpm exec wrangler d1 migrations apply vitehub-docs-demo --remote --config .output/server/wrangler.json
corepack pnpm exec wrangler deploy --config .output/server/wrangler.json
```

Worker secrets: `VITEHUB_SECRET` (32 or more characters), `VITEHUB_CONTENT_KEY` (32 random bytes, for the Console preview), and `VITEHUB_ADMIN_EMAILS` (the emails that get the admin role on their first sign-up or GitHub sign-in). Not set yet: `GITHUB_CLIENT_ID` and `GITHUB_CLIENT_SECRET` (GitHub sign-in), and `VITEHUB_GITHUB_TOKEN` (a fine-grained token for this repository, with contents and pull requests read and write, for the GitHub store).

Resources: the Worker `vitehub-docs-demo`, the D1 database `vitehub-docs-demo`, and the R2 bucket `vitehub-docs-demo`. Repository secrets: `CLOUDFLARE_API_TOKEN` and `CLOUDFLARE_ACCOUNT_ID`.

## Packages

The ViteHub packages are the pkg.pr.new previews of vite-hub/vitehub `main` at commit `88e965a`, which has every fix that this demo found (#3271, #3276, #3277, #3280, #3284) and the Auth tables of #3278. There are no patches. `pnpm-lock.yaml` has an `integrity` for each pkg.pr.new tarball: pnpm 10.34 refuses a tarball without one on the next install.

Workarounds in the app, with the finding behind each:

- `console.mcp.resource` in `nuxt.config.ts`: `publicUrl` does not reach the Nitro 2 server bundle of Nuxt 4, so without it the Console MCP answers `CONSOLE_MCP_ORIGIN_REQUIRED`.
- `nitro.cloudflare.wrangler.assets.run_worker_first` for the docs pages and `/api/_docs/*`: without it the static prerendered pages answer first, so the Console preview pane stays blank and `Accept: text/markdown` gets HTML.
- `agents`, `@vite-hub/schedule`, and `@vite-hub/shell` in `dependencies`: the Worker bundle imports them on paths that this app does not use (the docs MCP server on Workers, the Console Schedule route, the Workspace shell), and `wrangler deploy` fails when they are missing.
- `NODE_OPTIONS=--max-old-space-size=6144` in the build script: the Nitro bundle runs out of the default heap.

## Review

Comment on the live pages through Drop: <https://drop.vitehub.dev/d/ej2mgej5rcs4/vitehub-docs-demo>. The site loads Drop's review script, so the Comment button shows on every page.
