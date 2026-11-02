import { drizzleAdapter } from "better-auth/adapters/drizzle"
import { admin } from "better-auth/plugins"
import { defineAuth } from "vite-hub/auth"
import { cmsAccess } from "vite-hub/cms/access"
import { consoleMcpOAuth } from "vite-hub/console/auth"
import { useDatabase } from "vite-hub/database/drizzle"

import { publicUrl } from "../site"

// The first admin. This email gets the `admin` role when its user is created, with GitHub or with a password.
// Everyone else gets `user`, which has no CMS role, until an admin gives them one in the Console Auth section.
const firstAdmin = "maximogarciamtnez@gmail.com"

export default defineAuth(() => {
  const { db, schema } = useDatabase("default")
  const github = process.env.GITHUB_CLIENT_ID && process.env.GITHUB_CLIENT_SECRET
    ? { clientId: process.env.GITHUB_CLIENT_ID, clientSecret: process.env.GITHUB_CLIENT_SECRET }
    : undefined
  return {
    appName: "Lumen docs",
    database: drizzleAdapter(db, { provider: "sqlite", schema }),
    emailAndPassword: { enabled: true },
    socialProviders: github ? { github } : {},
    // A GitHub sign-in with the email of an existing user signs in to that user.
    account: { accountLinking: { trustedProviders: ["github"] } },
    plugins: [
      admin(cmsAccess),
      // The OAuth server that MCP clients sign in with, for the Console MCP at /_vitehub/mcp.
      ...consoleMcpOAuth({ resource: `${publicUrl}/_vitehub/mcp` }),
    ],
    databaseHooks: {
      user: {
        create: {
          before: async user => ({ data: user.email === firstAdmin ? { ...user, role: "admin" } : user }),
        },
      },
    },
  }
})
