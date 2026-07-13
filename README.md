# devkit

Installer + multi-project workspace for disposable Linux VPs.

- **Tools:** Bun, TypeScript 7, Go, PM2, Infisical, gh, modern CLI
- **Projects:** `~/projects/apps/<org>/<repo>` via `projects.yaml`
- **Agents:** global skills pack (`npx skills`) + skill `devkit`
- **Secrets:** Infisical (not in this repo)

## New VM (one shot)

```bash
# optional for private app repos:
export GH_TOKEN=github_pat_xxx
export INFISICAL_TOKEN=xxx

curl -fsSL https://raw.githubusercontent.com/ujang19/devkit/main/bootstrap-vps.sh | bash
```

Or:

```bash
git clone https://github.com/ujang19/devkit.git ~/linux-devkit
bash ~/linux-devkit/install.sh --profile default -y
source ~/.bashrc
devkit restore
bash ~/linux-devkit/scripts/install-skills.sh
```

## Layout

```text
~/projects/apps/
  wabase/core
  wazapin/platform
  wazapin/web
  usebetterpay/betterpay
~/linux-devkit/          # this repo (or ~/devkit)
```

## Commands

```bash
devkit doctor
devkit list
devkit path wabase-core
devkit restore
devkit add org-repo https://github.com/org/repo.git --path apps/org/repo --stack bun
```

## Profiles

| Profile | Contents |
|---------|----------|
| minimal | core CLI + bun/go basics |
| default | + PM2 path, agents tools, skills pack hook |
| full | + docker/flutter/herdr optional flags |

## Skills

```bash
bash scripts/install-skills.sh
# or see skills-manifest.txt
```

## Cloudflare / Neon

- DB: Neon `DATABASE_URL` via Infisical
- Workers: `CLOUDFLARE_API_TOKEN` via Infisical (not OAuth on VPS)
