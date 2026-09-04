import { parseArgs } from "node:util";
import sitemap from "@astrojs/sitemap";
import tailwindcss from "@tailwindcss/vite";
import { defineConfig, envField } from "astro/config";
import { loadEnv } from "vite";

const {
  values: { mode },
} = parseArgs({
  options: { mode: { type: "string", default: process.env.NODE_ENV } },
  strict: false,
});

const { SITE_URL } = loadEnv(mode, process.cwd(), "");

// https://astro.build/config
export default defineConfig({
  build: {
    format: "file",
  },
  env: {
    schema: {
      CLOUDFLARE_ANALYTICS_TOKEN: envField.string({
        context: "client",
        access: "public",
        optional: true,
      }),
      SITE_URL: envField.string({
        context: "client",
        access: "public",
        optional: true,
        url: true,
      }),
    },
  },
  integrations: [sitemap()],
  site: SITE_URL ?? "http://localhost:4321",
  vite: {
    plugins: [tailwindcss()],
  },
});
