import { docsCollection } from "@vite-hub/docs"
import cms from "vite-hub/cms"
import { defineContent } from "vite-hub/content"

// The Console edits the pages in content/.
//
// Today the CMS keeps drafts and published documents in R2 and D1 (the Blob + Database store), because the GitHub token
// for vite-hub/docs-demo does not exist yet. The site still renders the Markdown files of the repository; the preview
// pane renders the drafts.
//
// With the token, change the options to `{ repo: "vite-hub/docs-demo", publish: "commit", access: "roles" }`: a save then
// commits to the `vitehub/content` branch, and a publish commits to `main`, which deploys the site again.
export const content = defineContent({
  extends: [cms, { access: "roles" }],
  collections: { docs: docsCollection() },
})
