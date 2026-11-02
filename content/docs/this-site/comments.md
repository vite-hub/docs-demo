---
title: Leave a comment
description: Pin a comment to a part of a page, reply to it, and resolve it in the Console or from your agent.
navigation.order: 3
icon: i-lucide-message-square-plus
---

Signed-in users with a CMS role can comment on every page of this site. The comments are in D1, next to the users.

::steps{level="3"}
### Turn on comment mode

Open the pill and select **Comments**.

### Pin a comment

Press `C` and select a part of the page, such as a heading or a code block. Write the comment and send it. Other editors see the pin on the same element.

### Resolve it

Open the thread and select **Resolve**. The Comments section of the Console lists every thread, open and resolved.
::

::tip
An agent with the Console MCP server reads the open comments with `comments_list_threads` and answers them with `comments_reply`. Ask it: "Read the open comments on /docs/guides/ci and fix them."
::
