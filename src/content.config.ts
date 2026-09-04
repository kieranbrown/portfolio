import { defineCollection } from "astro:content";
import { glob } from "astro/loaders";
import { z } from "astro/zod";

const postsCollection = defineCollection({
  // Matches the legacy content collection globs: `_`-prefixed files stay drafts.
  loader: glob({
    pattern: ["**/*.md", "!**/_*/**/*.md", "!**/_*.md"],
    base: "./src/content/posts",
  }),
  schema: z.object({
    title: z.string(),
    description: z.string(),
    date: z.date(),
  }),
});

export const collections = {
  posts: postsCollection,
};
