# Skill Registry

**Delegator use only.** Any agent that launches sub-agents reads this registry to resolve compact rules, then injects them directly into sub-agent prompts. Sub-agents do NOT read this registry or individual SKILL.md files.

See `_shared/skill-resolver.md` for the full resolution protocol.

## User Skills

| Trigger | Skill | Path |
|---------|-------|------|
| Create new skill, add agent instructions, or document patterns for AI | skill-creator | C:\workspace\karate-taller\.opencode\skills\skill-creator\SKILL.md |
| "judgment day", "judgment-day", "review adversarial", "dual review", "doble review", "juzgar", "que lo juzguen" | judgment-day | C:\workspace\karate-taller\.opencode\skills\judgment-day\SKILL.md |
| Creating a GitHub issue, reporting a bug, or requesting a feature | issue-creation | C:\workspace\karate-taller\.opencode\skills\issue-creation\SKILL.md |
| "update skills", "skill registry", "actualizar skills", "update registry", or after installing/removing skills | skill-registry | C:\workspace\karate-taller\.opencode\skills\skill-registry\SKILL.md |
| Writing Go tests, using teatest, or adding test coverage | go-testing | C:\workspace\karate-taller\.opencode\skills\go-testing\SKILL.md |
| Creating a pull request, opening a PR, or preparing changes for review | branch-pr | C:\workspace\karate-taller\.opencode\skills\branch-pr\SKILL.md |

## Compact Rules

Pre-digested rules per skill. Delegators copy matching blocks into sub-agent prompts as `## Project Standards (auto-resolved)`.

### skill-creator
- Create new skills following the Agent Skills spec format
- Include frontmatter with name, description, license, metadata
- Write SKILL.md with Purpose, What to Do (steps), Rules sections
- Place in user's skill directory or project-level skills folder

### judgment-day
- Launch two independent blind judge sub-agents simultaneously to review the same target
- Synthesize their findings, apply fixes, and re-judge until both pass
- Escalate after 2 iterations if consensus not reached
- Use for critical code reviews, security audits, or architectural decisions

### issue-creation
- Follow the issue-first enforcement system
- Create issues before writing code (feature requests, bug reports)
- Include description, acceptance criteria, and labels
- Link PRs to issues

### skill-registry
- Scan user-level and project-level skill directories for SKILL.md files
- Skip sdd-*, _shared, and skill-registry directories
- Generate compact rules (5-15 lines) from each skill
- Write .atl/skill-registry.md in project root
- Save to engram if available

### go-testing
- Use teatest for Bubbletea TUI testing patterns
- Write table-driven tests for concurrent test cases
- Include setup/teardown functions for test isolation
- Use t.Fatalf for fatal errors, not t.Error for continue-on-failure

### branch-pr
- Create feature branch from main/master
- Make changes and commit with descriptive messages
- Push with -u flag for upstream tracking
- Create PR using gh pr create with proper title and body format
- Link to related issues

## Project Conventions

| File | Path | Notes |
|------|------|-------|
| AGENTS.md | C:\workspace\karate-taller\AGENTS.md | SDD Orchestrator configuration - defines workflow commands, artifact store mode (engram), and code style guides |

Read the convention files listed above for project-specific patterns and rules. All referenced paths have been extracted — no need to read index files to discover more.