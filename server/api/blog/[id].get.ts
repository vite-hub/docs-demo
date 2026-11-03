import { getPost } from "../../utils/collections"

export default defineEventHandler(async (event) => {
  const post = await getPost(getRouterParam(event, "id") ?? "")
  if (!post) throw createError({ statusCode: 404, statusMessage: "Post not found" })
  return post
})
