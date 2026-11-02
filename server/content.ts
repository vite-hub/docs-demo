import { docsCollection } from "@vite-hub/docs"
import cms from "vite-hub/cms"
import { defineContent } from "vite-hub/content"

// The Console edits the pages in content/. A save commits to the `vitehub/content` branch of the repository, and a
// publish commits to `main`, which deploys the site again.
export const content = defineContent({
  extends: [cms, { repo: "vite-hub/docs-demo", publish: "commit", access: "roles" }],
  collections: { docs: docsCollection() },
})
