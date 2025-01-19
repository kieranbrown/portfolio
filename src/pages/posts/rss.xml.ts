import rss from '@astrojs/rss';
import { getCollection } from 'astro:content';

const site = import.meta.env.SITE;

export async function GET() {
  const posts = await getCollection("posts");

  return rss({
    title: 'KB Blog',
    description: 'Yet another DevOps Engineer\'s blog',
    site: site,
    trailingSlash: false,
    xmlns: { atom: 'http://www.w3.org/2005/Atom' },
    customData: `<atom:link href="${site}/posts/feed.xml" rel="self" type="application/rss+xml"/>`,
    items: posts.toSorted((a, b) => b.data.date.getTime() - a.data.date.getTime()).map((post) => ({
      title: post.data.title,
      description: post.data.description,
      pubDate: post.data.date,
      link: `/posts/${post.slug}`,
    })),
  });
}
