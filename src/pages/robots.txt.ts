import type { APIRoute } from "astro";

const getRobotsTxt = (sitemapURL: URL) =>
  `
User-agent: *
${import.meta.env.MODE === "production" ? "Allow" : "Disallow"}: /

Sitemap: ${sitemapURL.href}
`.trimStart();

export const GET: APIRoute = ({ site }) => {
  const sitemapURL = new URL("sitemap-index.xml", site);
  return new Response(getRobotsTxt(sitemapURL));
};
