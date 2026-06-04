# product-review-expert

A bilingual Claude Code plugin for structured product reviews. It audits PRDs, page flows, interaction designs, and business rules to surface logic defects, UX risks, missing edge cases, and workflow gaps before release.

一个面向 Claude Code 的中英双语产品审查插件，用于审查 PRD、页面方案、业务流程和交互设计，识别逻辑缺陷、体验风险、异常分支遗漏与流程断点，并输出结构化审查报告。

This repository is packaged in the same style as SprintFoundry: the repository root is a Claude Code marketplace, and the complete plugin source lives under `plugins/product-review-expert`.

## What It Does

- Clarifies business goals, target users, scope, and constraints **before** reviewing (intake gate), and treats missing definitions as risks
- Reviews requirements, prototypes, and flows with a senior-PM lens using explicit methodology: user-journey mapping, state-machine modeling, role×permission matrix, and front/back-end gap checks
- Identifies logic defects, state-transition gaps, conflicting rules, permission inconsistencies, concurrency/idempotency risks, interaction friction, and launch-readiness gaps
- Grades every finding with a consistent formula — severity = impact × likelihood × reversibility — into P0/P1/P2
- Produces actionable findings: each issue carries an evidence anchor, quantified impact, concrete fix options, a verification method, and a grading rationale

## Included Components

### Skills

| Namespaced command | Purpose |
|------|------|
| `/product-review-expert:product-audit` | Full-spectrum entry: intake → methodology → logic, interaction, and launch-readiness review with senior dimensions (instrumentation, growth, compliance, dependencies) |
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

### Example 1: Full PRD audit

```text
/product-review-expert:product-audit
以下是一个退款审批系统需求，请重点检查流程闭环、状态流转、角色权限、异常场景和用户反馈是否完整：
[在这里粘贴 PRD 或流程说明]
```

### Example 2: Logic-only review

```text
/product-review-expert:logic-defect-review
请审查这个优惠券领取和核销流程，重点关注重复领取、过期状态、并发提交和角色权限边界：
[在这里粘贴流程描述]
```

### Example 3: Interaction-only review

```text
/product-review-expert:interaction-review
请审查这个移动端注册流程的交互设计，关注表单校验、错误提示、加载反馈和误操作风险：
[在这里粘贴页面方案]
```

## Output Format

The plugin is designed to return structured review results in this shape:

0. Review scope and assumptions (intake result)
1. Review conclusion + Go / No-Go
2. Key issues list ordered by `P0 / P1 / P2`
3. High-risk drop-off / financial-loss points
4. Missing information and open questions
5. Structural recommendations
6. Launch-readiness judgment

Each issue entry includes:

- Issue title
- Evidence anchor (quote the source, or flag "undefined in the doc")
- Quantified impact (which metric, how many users/orders, worst case)
- Concrete fix options
- Verification method (test case, A/B, or metric to watch)
- Priority + grading rationale (severity = impact × likelihood × reversibility)

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

### Senior dimensions (scoped to the case)

- Data and observability: instrumentation, funnel monitoring, alerting
- Growth and business metrics: expected impact on conversion, retention, GMV
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
└── README.md
```

## Links

- [GitHub repository](https://github.com/YuSec2021/product-review-expert)
- [Claude Code plugin marketplaces](https://code.claude.com/docs/en/plugin-marketplaces)
- [Claude Code plugins reference](https://code.claude.com/docs/en/plugins-reference)

## License

MIT
