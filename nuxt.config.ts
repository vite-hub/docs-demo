import { publicUrl } from "./site"

export default defineNuxtConfig({
  modules: [
    ["vite-hub/nuxt", {
      preset: "cloudflare",
      name: "vitehub-docs-demo",
      publicUrl,
      auth: true,
      // `publicUrl` does not reach the Nitro 2 server bundle of Nuxt 4, so the Console MCP needs its resource here.
      console: { auth: "app", authorize: "./server/console-authorize.ts", mcp: { resource: `${publicUrl}/_vitehub/mcp` } },
    }],
    "@vite-hub/docs/nuxt",
  ],
  docs: {
    site: {
      name: "Lumen",
      url: publicUrl,
      description: "Resize, compress, and convert images from the command line.",
      badge: { label: "demo", tooltip: "A made-up product. This site shows @vite-hub/docs on Cloudflare Workers." },
    },
    categories: ["Start", "Build", "Reference", "Demo"],
    railExclude: ["Reference"],
    start: { section: "getting-started", links: [{ label: "All docs", to: "/docs", icon: "i-lucide-layout-grid" }, { label: "About", to: "/about", icon: "i-lucide-info" }] },
    banner: "This is a demo of @vite-hub/docs. Sign in to edit the pages, comment on them, and connect your agent.",
    github: { repo: "vite-hub/docs-demo" },
    socials: [{ label: "ViteHub", to: "https://vitehub.dev", icon: "i-lucide-globe" }],
    mcp: { name: "lumen", guide: "/docs/this-site/connect-your-agent" },
  },
  compatibilityDate: "2026-11-01",
})
