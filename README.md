# product-review-expert

高级产品审查插件，专注发现产品逻辑缺陷、交互问题、流程断点与体验风险，输出结构化审查报告。

## 功能特性

### 技能模块

| 技能 | 说明 |
|------|------|
| `product-audit` | 综合审查产品需求文档、页面方案、业务流程和交互设计 |
| `logic-defect-review` | 专项审查产品逻辑缺陷，聚焦流程闭环、状态流转、异常分支 |
| `interaction-review` | 专项审查交互问题，检查信息架构、操作路径、反馈机制 |

### Agent

- **senior-product-reviewer**: 高级产品审查专家，综合调用三项技能进行全面审查

## 安装

```bash
# 克隆仓库
git clone https://github.com/YuSec2021/product-review-expert

# 进入目录
cd product-review-expert
```

## 使用方式

### 直接调用 Skill

```
/product-audit
/logic-defect-review
/interaction-review
```

### 使用 Agent 进行全面审查

```
/senior-product-reviewer
```

### 在代码中调用

```json
{
  "skills": ["product-audit", "logic-defect-review", "interaction-review"]
}
```

## 输出格式

审查报告严格按以下结构输出：

1. **审查结论** - 一句话总结整体质量水平
2. **关键问题清单** - 按 P0/P1/P2 优先级排列
   - P0：严重逻辑错误/流程断裂/高风险交互
   - P1：重要问题，影响核心体验或转化
   - P2：优化问题，不影响主流程但影响效率与体验
3. **补充建议** - 结构性优化建议
4. **最终判断** - 建议立即修改 / 建议优化后推进 / 可进入下一阶段

## 审查维度

### 产品逻辑审查
- 业务目标清晰性
- 用户角色完整性
- 流程闭环成立性
- 状态流转完整性
- 异常/边界条件遗漏
- 规则自洽性
- 权限角色一致性

### 交互审查
- 页面层级与信息架构
- 操作路径长度
- 操作反馈充分性
- 风险操作确认机制
- 空状态/加载态/错误态完整性
- 表单校验与纠错机制

## 项目结构

```
product-review-expert/
├── .claude-plugin/
│   └── plugin.json          # 插件配置
├── skills/
│   ├── product-audit/       # 综合审查技能
│   ├── logic-defect-review/ # 逻辑缺陷审查
│   └── interaction-review/  # 交互问题审查
├── agents/
│   └── senior-product-reviewer.md  # 高级审查 Agent
├── hooks/
│   └── hooks.json           # Hook 配置
└── scripts/
    └── normalize-output.sh  # 输出规范化脚本
```

## 相关链接

- [GitHub 仓库](https://github.com/YuSec2021/product-review-expert)
- [问题反馈](https://github.com/YuSec2021/product-review-expert)

## License

MIT
