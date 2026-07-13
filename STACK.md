# Stack (ujang)

- Agents: Grok + OpenCode
- JS: Bun (primary), Node via nvm (fallback)
- TypeScript: 7.x
- Go: official toolchain → ~/.local/go
- Secrets: Infisical → env (never commit keys)
- Multi-project: projects.yaml + devkit restore
- Research: Exa MCP (+ Firecrawl) via env

## Run agents with secrets

```bash
infisical login   # once on laptop
# or INFISICAL_TOKEN=... on VPS

infisical run --env=dev -- grok
infisical run --env=dev -- opencode
```

## Required Infisical keys (suggested)

```
EXA_API_KEY
FIRECRAWL_API_KEY
GH_TOKEN                 # private app clone (optional)
# plus any CONTEXT7 / FIGMA keys you use
```
