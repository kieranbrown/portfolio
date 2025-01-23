import { parseArgs } from "node:util";
import sitemap from "@astrojs/sitemap";
import tailwind from "@astrojs/tailwind";
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
      SITE_URL: envField.string({
        context: "client",
        access: "public",
        optional: true,
        url: true,
      }),
    },
  },
  integrations: [sitemap(), tailwind()],
  site: SITE_URL ?? "http://localhost:4321",
});
