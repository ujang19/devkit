# Agent-global skill: devkit

Not Grok-only. Installed for any agent that discovers Agent Skills.

## Discovery paths (global)

| Path | Used by |
|------|---------|
| `~/.agents/skills/devkit/SKILL.md` | Agent-compatible (OpenCode + others) |
| `~/.config/opencode/skills/devkit/SKILL.md` | OpenCode global |
| `~/.claude/skills/devkit/SKILL.md` | Claude-compatible tools |
| `~/AGENTS.md` | Short global rules pointer |

## Shipped with kit (project-scoped when working in linux-devkit)

| Path |
|------|
| `linux-devkit/.agents/skills/devkit/SKILL.md` |
| `linux-devkit/.opencode/skills/devkit/SKILL.md` |

## User prompts

- "tambah github.com/wazapin/api ke devkit"
- "restore semua project"
- "path wabase core"
- load skill `devkit`

## CLI remains source of truth

Agents should call `devkit`, not reimplement clone logic.
