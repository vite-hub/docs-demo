---
title: Edit and publish a page
description: Change a docs page in the Console, check the draft in the preview pane, publish it, and see the change on the site after the deploy.
navigation.order: 2
icon: i-lucide-file-pen-line
---

Every page of this site is a document in the **Docs** collection of the Console. The collection is `docsCollection()` from `@vite-hub/docs`, so the Console checks the frontmatter with the same schema as the build.

::steps{level="3"}
### Open the page

Open the pill on the page that you want to change and select **Content**. Or open [`/_vitehub/content`](/_vitehub/content), select **Docs**, and open the page.

### Edit the draft

Change the text or a frontmatter field, such as `description`. The Console saves a draft one second after you stop typing. On this site a draft is a commit on the `vitehub/content` branch of the repository.

### Check the preview

Select **Preview the page**. The preview pane renders the draft through the docs UI, with the same layout and components as the published page.

### Publish

Select **Publish**. The CMS commits the page to `main`. A GitHub Actions workflow builds the site and deploys the Worker again, which takes about three minutes. Reload the page to see the change.
::

::note
Until the deploy ends, the site shows the published page of the last build. The Console shows the document as published at once.
::

## What you cannot change here

- Search, the sidebar, and the previous and next links come from the last build. A new page shows in them after the deploy.
- A new section needs a `.navigation.yml` file, which the Console does not edit. Ask a developer, or let your agent open a pull request.
