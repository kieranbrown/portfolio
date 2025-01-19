import rss from '@astrojs/rss';
import { getCollection } from 'astro:content';

export async function GET() {
  const posts = await getCollection("posts");

  return rss({
    title: 'KB Blog',
    description: 'Yet another DevOps Engineer\'s blog',
    site: import.meta.env.SITE,
    trailingSlash: false,
    items: posts.toSorted((a, b) => b.data.date.getTime() - a.data.date.getTime()).map((post) => ({
      title: post.data.title,
      description: post.data.description,
      pubDate: post.data.date,
      link: `/posts/${post.slug}`,
    })),
  });
}
