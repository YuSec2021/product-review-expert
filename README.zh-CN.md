# product-review-expert

简体中文 | [English](README.md)

`product-review-expert` 是一个面向 Claude Code 的中英双语产品审查插件，用于审查 PRD、页面方案、业务流程和交互设计，识别逻辑缺陷、体验风险、异常分支遗漏与流程断点，并输出结构化审查报告。

本仓库采用与 SprintFoundry 相同的发布形态：仓库根目录是 Claude Code marketplace，完整插件源码位于 `plugins/product-review-expert`。

## 它能做什么

- 审查前先澄清业务目标、目标用户、上线范围和约束，并把缺失定义视为风险
- 用高级产品经理视角审查需求、原型和流程，内置用户旅程拆解、状态机映射、角色权限矩阵和前后台断层检查
- 识别逻辑缺陷、状态流转遗漏、规则冲突、权限不一致、并发/幂等风险、交互摩擦和上线就绪度缺口
- 使用统一公式定级：严重度 = 影响面 x 发生概率 x 可逆性
- 输出可落地的问题条目：证据锚点、量化影响、具体修改建议、验证方式和定级理由

## 包含组件

### Skills

| 命名空间命令 | 用途 |
| --- | --- |
| `/product-review-expert:product-audit` | 全面体检入口：intake、方法论推演、逻辑审查、交互审查和上线就绪度审查，覆盖埋点、增长、合规、依赖等资深维度 |
| `/product-review-expert:logic-defect-review` | 逻辑专项深挖：状态机、流程闭环、并发/幂等、角色权限一致性和规则冲突 |
| `/product-review-expert:interaction-review` | 交互专项深挖：信息架构、操作路径、反馈闭环、表单校验和误操作风险 |

### Agent

- `product-review-expert:senior-product-reviewer`

该 agent 会组合三个 skill 完成更完整的一轮综合评审。安装插件后可在 `/agents` 中查看，也可以用以下方式启动 Claude Code：

```bash
claude --agent product-review-expert:senior-product-reviewer
```

## 安装

### 从本 marketplace 仓库安装

在 Claude Code 中添加 marketplace 并安装插件：

```text
/plugin marketplace add YuSec2021/product-review-expert
/plugin install product-review-expert@product-review-expert
```

安装后使用以下命名空间 skill：

```text
/product-review-expert:product-audit
/product-review-expert:logic-defect-review
/product-review-expert:interaction-review
```

### 本地开发

直接加载插件源码：

```bash
claude --plugin-dir ./plugins/product-review-expert
```

在 Claude Code 会话中修改插件文件后，运行：

```text
/reload-plugins
```

## 使用示例

### 完整 PRD 审查

```text
/product-review-expert:product-audit
以下是一个退款审批系统需求，请重点检查流程闭环、状态流转、角色权限、异常场景和用户反馈是否完整：
[在这里粘贴 PRD 或流程说明]
```

### 仅审查逻辑

```text
/product-review-expert:logic-defect-review
请审查这个优惠券领取和核销流程，重点关注重复领取、过期状态、并发提交和角色权限边界：
[在这里粘贴流程描述]
```

### 仅审查交互

```text
/product-review-expert:interaction-review
请审查这个移动端注册流程的交互设计，关注表单校验、错误提示、加载反馈和误操作风险：
[在这里粘贴页面方案]
```

## 输出格式

插件会按以下结构输出审查结果：

0. 审查范围与假设
1. 审查结论和 Go / No-Go 判断
2. 按 `P0 / P1 / P2` 排序的关键问题清单
3. 高风险流失点或资损点
4. 缺失信息与待确认项
5. 结构性优化建议
6. 上线就绪度判断

每个问题条目包含：

- 问题标题
- 证据锚点：引用原文，或明确标注“文档未定义”
- 量化影响：影响哪个指标、多少用户/订单、最坏情况是什么
- 具体修改建议
- 验证方式：测试用例、A/B 或上线后观察指标
- 优先级与定级理由

## 审查覆盖范围

### 产品逻辑

- 业务目标清晰度
- 用户角色完整性
- 流程闭环完整性
- 状态流转完整性
- 前置条件与后置条件
- 异常场景与边界场景
- 规则一致性与优先级冲突
- 输入与输出约束
- 角色与权限一致性

### 交互体验

- 信息架构与页面层级
- 操作路径长度与摩擦
- 反馈清晰度
- 风险操作确认机制
- 空态、加载态和错误态
- 校验与纠错指引
- 文案清晰度与歧义
- 可恢复性，例如撤销、返回、草稿保存

### 资深维度

- 数据与可观测性：埋点、漏斗监控、异常告警
- 增长与业务指标：对转化、留存、GMV 的预期影响
- 合规与资损：隐私、权限审计、可逆性、资损敞口
- 可访问性与国际化
- 跨团队与系统依赖：接口、时序、外部准备情况
- 上线就绪度：灰度、回滚、降级、容量预案

## 安全与隐私

- 插件不会调用外部 API，也不会把用户内容上传到第三方服务
- 插件不需要 MCP server、OAuth、API key 或额外本地依赖
- 内置 Stop hook 只会运行插件内的本地脚本
- 脚本会在 `${CLAUDE_PLUGIN_DATA}` 下写入带时间戳的诊断日志
- hook 不会编辑仓库文件，不会发送网络请求，也不会收集分析数据

如果不需要 hook 日志，可从 `plugins/product-review-expert/.claude-plugin/plugin.json` 中移除 `hooks` 字段。

## 发布

完整插件源码提交在 `plugins/product-review-expert` 下。

构建可分发的插件归档：

```bash
bash scripts/package_plugin.sh
```

也可以先 bump 插件版本：

```bash
bash scripts/package_plugin.sh --bump patch
bash scripts/package_plugin.sh --bump minor
bash scripts/package_plugin.sh --bump major
```

脚本会校验插件结构，同步 `plugins/product-review-expert/.claude-plugin/plugin.json` 与 `.claude-plugin/marketplace.json` 的版本，并写出 `product-review-expert.plugin`。该归档是本地构建产物，已被 Git 忽略；发布时应作为 release artifact 分发，不应提交到仓库。

CI 工作流 `.github/workflows/validate-plugins.yml` 会在 marketplace、插件源码或打包脚本变化时校验 marketplace 与 plugin 结构。

## 仓库结构

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

## 链接

- [GitHub repository](https://github.com/YuSec2021/product-review-expert)
- [Claude Code plugin marketplaces](https://code.claude.com/docs/en/plugin-marketplaces)
- [Claude Code plugins reference](https://code.claude.com/docs/en/plugins-reference)

## 许可证

MIT
