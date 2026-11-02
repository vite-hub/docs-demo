import { defineDatabase } from "vite-hub/database"

import { user, session, account, verification, jwks, oauthClient, oauthResource, oauthClientResource, oauthRefreshToken, oauthAccessToken, oauthConsent, oauthClientAssertion } from "./auth-schema"

// One D1 database for the Better Auth tables, the CMS editor sessions, and the Comments tables. The CMS and Comments add
// their own tables to this Database.
export default defineDatabase({
  cloudflare: {
    binding: "DB",
    databaseId: "abc471a2-b5d2-4aa2-af55-27af8ef21345",
    databaseName: "vitehub-docs-demo",
  },
  schema: { user, session, account, verification, jwks, oauthClient, oauthResource, oauthClientResource, oauthRefreshToken, oauthAccessToken, oauthConsent, oauthClientAssertion },
})
