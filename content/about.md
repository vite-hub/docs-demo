---
title: About this demo
description: Why this site exists, what it runs on, and where its source is.
---

Lumen does not exist. This site exists to show [`@vite-hub/docs`](https://vitehub.dev/docs/docs-site) as a real app outside the ViteHub repository: it installs the published preview packages, it builds with Nuxt, and it runs as one Cloudflare Worker.

## What runs here

| Part | Where |
| --- | --- |
| Pages | Markdown files in `content/` of [vite-hub/docs-demo](https://github.com/vite-hub/docs-demo) |
| Site | A Nuxt 4 app with `@vite-hub/docs/nuxt` and `vite-hub/nuxt` |
| Host | Cloudflare Workers, with D1 for users, sessions, editor sessions, and comments |
| Editing | The ViteHub CMS with the GitHub store: a save commits to a branch, a publish commits to `main` |
| Deploys | A GitHub Actions workflow that builds and deploys on each push to `main` |

## Why a standalone page

This page is `content/about.md`. A file outside `content/docs/` is a plain article under the site header, without the sidebar and the section rail. Use it for pages such as About, Pricing, or Privacy.

## Contact

Open an issue in [vite-hub/docs-demo](https://github.com/vite-hub/docs-demo/issues), or leave a comment on any page when you are signed in.
