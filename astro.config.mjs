import { defineConfig, envField } from "astro/config";
import cloudflare from '@astrojs/cloudflare';
import tailwind from "@astrojs/tailwind";
import { parseArgs } from 'node:util';
import { loadEnv } from "vite";

const { values: { mode } } = parseArgs({
  allowPositionals: true,
  strict: false,
  options: {
    mode: { type: "string", default: process.env.NODE_ENV }
  },
});

const { SITE_URL } = loadEnv(mode, process.cwd(), '');

// https://astro.build/config
export default defineConfig({
  adapter: cloudflare(),
  env: {
    schema: {
      SITE_URL: envField.string({ context: "client", access: "public", optional: true }),
    }
  },
  integrations: [tailwind()],
  output: 'server',
  site: SITE_URL ?? 'http://localhost:4321',
});
