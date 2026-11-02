---
title: Lumen
description: Resize, compress, and convert images from the command line. One binary, one config file, the same result on every machine.
---

Lumen is a made-up command-line tool for images. It resizes, compresses, and converts a folder of images in one command, and it reads its settings from one file that you commit with your project.

```bash [Terminal]
pnpm add -g lumen-cli
lumen compress ./public --quality 75
```

This site is a demo of [`@vite-hub/docs`](https://vitehub.dev/docs/docs-site). Every page is a Markdown file in [vite-hub/docs-demo](https://github.com/vite-hub/docs-demo). Signed-in editors change the pages in the ViteHub Console, leave comments on them, and let their coding agent edit them through MCP. Read [Edit this site](/docs/this-site) to try it.

::product-features
  :::product-feature-item{title="Start in five minutes" icon="i-lucide-rocket" to="/docs/getting-started"}
  Install the binary and compress your first folder.
  :::

  :::product-feature-item{title="Guides" icon="i-lucide-book-open" to="/docs/guides"}
  Resize, compress, convert, and check images in CI.
  :::

  :::product-feature-item{title="Reference" icon="i-lucide-list-tree" to="/docs/reference"}
  Every command, flag, config field, and exit code.
  :::

  :::product-feature-item{title="Edit this site" icon="i-lucide-pencil-ruler" to="/docs/this-site"}
  The Console, the tools pill, comments, and MCP on this demo.
  :::
::
