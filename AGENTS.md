# AGENTS.md

Guidance for coding agents working in this repository. `CLAUDE.md` is a
symlink to this file, so edit `AGENTS.md` only.

## What this is

Kieran Brown's personal portfolio at <https://kieranbrown.dev>. A static
site built with Astro 7 and Tailwind CSS 4, deployed to Cloudflare Pages.
The Pages project is managed with Terraform in `terraform/cloudflare-pages`
and applied by Digger from GitHub Actions. Pushes to `main` are built with
`--mode production` and deployed straight to <https://kieranbrown.dev>;
every other branch gets a preview deployment built with `--mode preview`.

## Toolchain

- Node 24 (`.node-version`) and pnpm 10 (`packageManager` in
  `package.json`). pnpm settings live in `pnpm-workspace.yaml`.
- Biome formats and lints JS/TS/CSS/JSON (`biome.json`). Astro files are
  checked by `astro check`. Biome only parses `.astro` frontmatter, so
  `noUnusedImports`/`noUnusedVariables` are off for those files.
- Git hooks are defined in `.pre-commit-config.yaml` and run with **prek**,
  a Rust reimplementation of pre-commit. Do not install or call
  `pre-commit` itself.

## Commands

| Task                 | Command                               |
| -------------------- | ------------------------------------- |
| Install dependencies | `pnpm install`                        |
| Dev server           | `pnpm run dev` (or `make up`)         |
| Lint and type-check  | `pnpm run check`                      |
| Production build     | `pnpm run build` (outputs to `dist/`) |
| Preview the build    | `pnpm run preview`                    |
| Run all git hooks    | `prek run --all-files`                |
| Install git hooks    | `prek install`                        |

`pnpm run dev` passes `--open`, which launches a browser. To boot the site
without that, run `pnpm exec astro dev`.

## Layout

- `src/pages/` holds the routes: `index`, `about`, `posts`, `posts/[slug]`,
  `404`, `robots.txt.ts` and `posts/rss.xml.ts`. `build.format` is `file`,
  so pages are emitted as `about.html` rather than `about/index.html`.
- `src/layouts/main.astro` is the HTML shell: dark mode bootstrap, header,
  footer, decorative background grid and the Cloudflare analytics beacon.
- `src/components/` contains Astro components styled with Tailwind
  utilities.
- `src/collections/` holds JSON data: `menu.json` (navigation) and
  `experiences.json` (work history shown on `/about`).
- `src/content/posts/` holds Markdown blog posts. The collection schema in
  `src/content.config.ts` requires `title`, `description` and `date`. The
  collection uses the `glob()` loader and skips `_`-prefixed drafts.
- `src/assets/` holds `css/main.css` (dark toggle animations),
  `js/main.js` (sticky header, dark mode toggle, mobile menu) and images.
- `public/` holds static files, including the Cloudflare Pages `_headers`.

## Conventions

- Styling is Tailwind utility classes inline in `.astro` files. Tailwind 4
  is wired up through the `@tailwindcss/vite` plugin in `astro.config.mjs`
  and configured CSS-first at the top of `src/assets/css/main.css` — there
  is no `tailwind.config.*`.
- Dark mode uses a `@custom-variant dark` rule in `src/assets/css/main.css`
  rather than a config option. The `dark` class is added to `<html>` from
  `localStorage.dark_mode` before first paint.
- The blog is currently empty. When the `posts` collection has no entries
  the Posts nav link, the RSS `<link>` and the homepage writing section are
  hidden, and `/posts` redirects to `/`. Adding a Markdown file under
  `src/content/posts/` re-enables all of them.
- `SITE_URL` and `CLOUDFLARE_ANALYTICS_TOKEN` come from `.env.preview` and
  `.env.production`, selected by Astro's `--mode`. Both are optional locally.
- Commit messages must follow Conventional Commits (enforced by commitlint).

## Checking your work

There is no test suite. Before finishing:

1. Run `pnpm run check`. Biome and `astro check` must both pass.
2. Run `pnpm run build`. It must succeed.
3. For layout changes, check a narrow viewport (about 375px wide).

For step 3, confirm `document.documentElement.scrollWidth` equals the
viewport width. Absolutely positioned decoration such as
`src/components/square-lines.astro` is the usual source of horizontal
overflow.
