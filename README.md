# product-review-expert

A bilingual Claude Code plugin for structured product reviews. It audits PRDs, page flows, interaction designs, and business rules to surface logic defects, UX risks, missing edge cases, and workflow gaps before release.

一个面向 Claude Code 的中英双语产品审查插件，用于审查 PRD、页面方案、业务流程和交互设计，识别逻辑缺陷、体验风险、异常分支遗漏与流程断点，并输出结构化审查报告。

## What It Does

- Reviews product requirements, prototypes, and flow descriptions with a product-quality lens
- Identifies logic defects, state-transition gaps, conflicting rules, and permission inconsistencies
- Flags interaction problems such as weak feedback, long action paths, and missing empty or error states
- Produces structured output with conclusions, prioritized findings, and actionable fixes

## Included Components

### Skills

| Namespaced command | Purpose |
|------|------|
| `/product-review-expert:product-audit` | Full-spectrum review for PRDs, page plans, business processes, and interaction design |
| `/product-review-expert:logic-defect-review` | Logic-focused review for flows, state transitions, exception handling, and rule conflicts |
| `/product-review-expert:interaction-review` | UX-focused review for information architecture, action paths, feedback, and form behavior |

### Agent

- `/product-review-expert:senior-product-reviewer`

This agent combines the three skills above for a more comprehensive review pass.

## Installation

### From GitHub

```bash
git clone https://github.com/YuSec2021/product-review-expert.git
cd product-review-expert
claude --plugin-dir .
```

### From a Marketplace

Install `product-review-expert` from the Claude Code plugin discovery flow, then call the plugin with its namespaced commands:

```text
/product-review-expert:product-audit
/product-review-expert:logic-defect-review
/product-review-expert:interaction-review
/product-review-expert:senior-product-reviewer
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

1. Review conclusion
2. Key issues list ordered by `P0 / P1 / P2`
3. Supplemental recommendations
4. Final go or no-go judgment

Typical issue entries include:

- Issue title
- Description
- Scope of impact
- Risk explanation
- Suggested fix
- Priority

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

## Security And Privacy

- This plugin does not call external APIs or upload user content to third-party services
- It does not require MCP servers, OAuth, API keys, or extra local dependencies
- The bundled Stop hook only runs a local script inside the plugin
- The script writes a timestamped log file under `${CLAUDE_PLUGIN_DATA}` for plugin diagnostics
- The hook does not edit repository files, send network requests, or collect analytics

## Runtime Notes

- The plugin includes 3 skills, 1 agent, and 1 local hook
- The Stop hook currently acts as a lightweight normalization and logging entrypoint
- If you do not want hook-based logging, you can disable the hook by removing the `hooks` entry from `.claude-plugin/plugin.json`

## Repository Structure

```text
product-review-expert/
├── .claude-plugin/
│   └── plugin.json
├── agents/
│   └── senior-product-reviewer.md
├── hooks/
│   └── hooks.json
├── scripts/
│   └── normalize-output.sh
├── skills/
│   ├── product-audit/
│   ├── logic-defect-review/
│   └── interaction-review/
├── CHANGELOG.md
└── LICENSE
```

## Submission Readiness Notes

This repository includes the materials typically expected before marketplace submission:

- `.claude-plugin/plugin.json` manifest
- Public source repository
- README with installation and usage instructions
- Semver versioning and changelog
- License
- Clear disclosure of local hook behavior

## Links

- [GitHub repository](https://github.com/YuSec2021/product-review-expert)
- [Claude Code plugins docs](https://code.claude.com/docs/en/plugins)
- [Claude Code plugins reference](https://code.claude.com/docs/en/plugins-reference)

## License

MIT
