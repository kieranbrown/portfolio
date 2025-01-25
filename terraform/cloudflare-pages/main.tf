data "cloudflare_zone" "this" {
  name = "kieranbrown.dev"
}

resource "cloudflare_web_analytics_site" "this" {
  account_id   = data.cloudflare_zone.this.account_id
  host         = data.cloudflare_zone.this.name
  auto_install = false
}

resource "cloudflare_pages_project" "this" {
  account_id = data.cloudflare_zone.this.account_id

  name = "portfolio"

  production_branch = "rc"

  build_config {
    build_caching       = true
    build_command       = "pnpm run build --mode $([ \"$CF_PAGES_BRANCH\" = main ] && echo staging || ([ \"$CF_PAGES_BRANCH\" = rc ] && echo production || echo preview))"
    destination_dir     = "dist"
    web_analytics_tag   = cloudflare_web_analytics_site.this.site_tag
    web_analytics_token = cloudflare_web_analytics_site.this.site_token
  }

  source {
    type = "github"

    config {
      owner                      = "kieranbrown"
      repo_name                  = "portfolio"
      production_branch          = "rc"
      preview_deployment_setting = "custom"
      preview_branch_excludes    = ["release-please--branches--main"]
    }
  }
}

resource "cloudflare_record" "this" {
  for_each = {
    "@"       = cloudflare_pages_project.this.subdomain
    "www"     = cloudflare_pages_project.this.subdomain
    "staging" = "main.${cloudflare_pages_project.this.subdomain}"
  }

  zone_id = data.cloudflare_zone.this.id

  name    = each.key
  type    = "CNAME"
  content = each.value
  proxied = true
}

resource "cloudflare_pages_domain" "this" {
  for_each = cloudflare_record.this

  account_id   = cloudflare_pages_project.this.account_id
  project_name = cloudflare_pages_project.this.id
  domain       = each.value.hostname
}

resource "cloudflare_ruleset" "this" {
  zone_id = data.cloudflare_zone.this.zone_id

  name  = "portfolio"
  kind  = "zone"
  phase = "http_request_dynamic_redirect"

  rules {
    description = "Redirect www to apex"

    action     = "redirect"
    expression = "http.host eq \"www.${data.cloudflare_zone.this.name}\""

    action_parameters {
      from_value {
        status_code = 301

        preserve_query_string = true

        target_url {
          expression = "concat(\"https://${data.cloudflare_zone.this.name}\", http.request.uri.path)"
        }
      }
    }
  }
}
