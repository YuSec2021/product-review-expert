# product-review-expert

[简体中文](README.zh-CN.md) | English

`product-review-expert` is a bilingual Claude Code plugin for structured product reviews. It audits PRDs, page flows, interaction designs, and business rules to surface logic defects, UX risks, missing edge cases, and workflow gaps before release.

This repository is packaged in the same style as SprintFoundry: the repository root is a Claude Code marketplace, and the complete plugin source lives under `plugins/product-review-expert`.

## What It Does

- Clarifies business goals, target users, scope, and constraints before reviewing, and treats missing definitions as risks
- Reviews requirements, prototypes, and flows with a senior-PM lens using user-journey mapping, state-machine modeling, role-permission matrices, and front/back-end gap checks
- Identifies logic defects, state-transition gaps, conflicting rules, permission inconsistencies, concurrency and idempotency risks, interaction friction, and launch-readiness gaps
- Grades every finding with a consistent formula: severity = impact x likelihood x reversibility
- Produces actionable findings with evidence anchors, quantified impact, concrete fix options, verification methods, and grading rationale

## Included Components

### Skills

| Namespaced command | Purpose |
| --- | --- |
| `/product-review-expert:product-audit` | Full-spectrum review entry: intake, methodology, logic, interaction, and launch-readiness review with senior dimensions such as instrumentation, growth, compliance, and dependencies |
| `/product-review-expert:logic-defect-review` | Logic deep-dive: state machines, closed loops, concurrency/idempotency, role-permission consistency, and rule conflicts |
| `/product-review-expert:interaction-review` | UX deep-dive: information architecture, action paths, feedback loops, form validation, and misoperation risk |

### Agent

- `product-review-expert:senior-product-reviewer`

The agent combines the three skills above for a more comprehensive review pass. It appears in `/agents` after the plugin is installed. You can also launch Claude Code with it:

```bash
claude --agent product-review-expert:senior-product-reviewer
```

## Installation

### From this marketplace repository

In Claude Code, add the marketplace and install the plugin:

```text
/plugin marketplace add YuSec2021/product-review-expert
/plugin install product-review-expert@product-review-expert
```

Then call the plugin with its namespaced skills:

```text
/product-review-expert:product-audit
/product-review-expert:logic-defect-review
/product-review-expert:interaction-review
```

### Local development

Load the plugin source directly:

```bash
claude --plugin-dir ./plugins/product-review-expert
```

After changing plugin files inside an active Claude Code session, run:

```text
/reload-plugins
```

## Usage Examples

### Full PRD audit

```text
/product-review-expert:product-audit
Review this refund approval system requirement. Focus on workflow closure, state transitions, roles and permissions, exception scenarios, and user feedback:
[Paste the PRD or flow description here]
```

### Logic-only review

```text
/product-review-expert:logic-defect-review
Review this coupon claim and redemption flow. Focus on duplicate claims, expiration states, concurrent submissions, and role-permission boundaries:
[Paste the flow description here]
```

### Interaction-only review

```text
/product-review-expert:interaction-review
Review this mobile registration flow. Focus on form validation, error messages, loading feedback, and misoperation risk:
[Paste the page plan here]
```

## Output Format

The plugin is designed to return structured review results in this shape:

0. Review scope and assumptions
1. Review conclusion plus Go / No-Go judgment
2. Key issues ordered by `P0 / P1 / P2`
3. High-risk drop-off or financial-loss points
4. Missing information and open questions
5. Structural recommendations
6. Launch-readiness judgment

Each issue entry includes:

- Issue title
- Evidence anchor, either a quote from the source or a clear "undefined in the document" marker
- Quantified impact, including affected metric, users/orders, or worst-case outcome
- Concrete fix options
- Verification method, such as a test case, A/B test, or metric to watch
- Priority and grading rationale

## Review Coverage

### Product logic

- Business goal clarity
- User-role completeness
- Closed-loop workflow integrity
- State-transition completeness
- Preconditions and postconditions
- Exception and edge-case coverage
- Rule consistency and priority conflicts
- Input and output constraints
- Role and permission consistency

### Interaction quality

- Information architecture and page hierarchy
- Action-path length and friction
- Feedback clarity
- Confirmation for risky actions
- Empty, loading, and error states
- Validation and correction guidance
- Copy clarity and ambiguity
- Recoverability such as undo, back, and draft saving

### Senior dimensions

- Data and observability: instrumentation, funnel monitoring, alerting
- Growth and business metrics: expected impact on conversion, retention, and GMV
- Compliance and financial risk: privacy, permission audit, reversibility, loss exposure
- Accessibility and internationalization
- Cross-team and system dependencies: interfaces, sequencing, external readiness
- Launch readiness: canary, rollback, degradation, capacity

## Security And Privacy

- This plugin does not call external APIs or upload user content to third-party services
- It does not require MCP servers, OAuth, API keys, or extra local dependencies
- The bundled Stop hook only runs a local script inside the plugin
- The script writes a timestamped log file under `${CLAUDE_PLUGIN_DATA}` for plugin diagnostics
- The hook does not edit repository files, send network requests, or collect analytics

If you do not want hook-based logging, remove the `hooks` entry from `plugins/product-review-expert/.claude-plugin/plugin.json`.

## Release

The complete plugin source is committed under `plugins/product-review-expert`.

Build a distributable plugin archive:

```bash
bash scripts/package_plugin.sh
```

Optionally bump the plugin version first:

```bash
bash scripts/package_plugin.sh --bump patch
bash scripts/package_plugin.sh --bump minor
bash scripts/package_plugin.sh --bump major
```

The script validates plugin structure, keeps `plugins/product-review-expert/.claude-plugin/plugin.json` and `.claude-plugin/marketplace.json` versions in sync, and writes `product-review-expert.plugin`. The archive is a local build artifact and is intentionally ignored by Git; publish it through release artifacts rather than committing it.

CI workflow `.github/workflows/validate-plugins.yml` validates the marketplace and plugin structure on changes to marketplace, plugin source, or packaging script.

## Repository Structure

```text
product-review-expert/
├── .claude-plugin/
│   └── marketplace.json
├── .github/
│   └── workflows/
│       └── validate-plugins.yml
├── plugins/
│   └── product-review-expert/
│       ├── .claude-plugin/
│       │   └── plugin.json
│       ├── agents/
│       ├── hooks/
│       ├── scripts/
│       └── skills/
├── scripts/
│   └── package_plugin.sh
├── CHANGELOG.md
├── LICENSE
├── README.md
└── README.zh-CN.md
```

## Links

- [GitHub repository](https://github.com/YuSec2021/product-review-expert)
- [Claude Code plugin marketplaces](https://code.claude.com/docs/en/plugin-marketplaces)
- [Claude Code plugins reference](https://code.claude.com/docs/en/plugins-reference)

## License

MIT
