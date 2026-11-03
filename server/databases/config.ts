import { defineDatabase } from "vite-hub/database"

// One D1 database. Auth (`authDatabase()`), the CMS, and Comments add their own tables to it.
export default defineDatabase({
  cloudflare: {
    binding: "DB",
    databaseId: "abc471a2-b5d2-4aa2-af55-27af8ef21345",
    databaseName: "vitehub-docs-demo",
  },
  schema: {},
})
