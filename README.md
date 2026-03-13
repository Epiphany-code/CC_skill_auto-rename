# Claude Code Session Auto-Rename Skill

一个用于 Claude Code 的技能（Skill），自动分析对话上下文并生成有意义的会话标题，让你在 `/resume` 和状态栏中轻松识别各个会话。

## 功能特性

- 🤖 **自动分析上下文** - LLM 分析对话内容，自动判断任务类型
- 📝 **智能生成标题** - 格式化标题，包含项目名、类型和描述
- ⚡ **一键重命名** - 直接写入 session 文件，无需手动 `/rename`
- 🌐 **中英文支持** - 根据用户语言自动选择标题语言

## 标题格式

```
CC | {项目名} | [{类型}] {描述}
```

**示例：**
- `CC | RDAgent | [Debug] API连接超时`
- `CC | scholar_research | [Build] Session自动命名Skill`
- `CC | my-project | [Research] Skill功能调研`

## 任务类型

| 类型 | 适用场景 |
|------|---------|
| `[Build]` | 创建新功能、新组件、新模块 |
| `[Debug]` | 调试问题、修复 bug |
| `[Refactor]` | 重构代码、优化结构 |
| `[Test]` | 编写测试、测试相关 |
| `[Doc]` | 文档编写、注释添加 |
| `[Review]` | 代码审查、分析代码 |
| `[Config]` | 配置文件、环境设置 |
| `[Research]` | 调研、学习、探索 |
| `[Chat]` | 问答、讨论、咨询 |

## 安装

### 方法一：手动安装

```bash
# 创建 skill 目录
mkdir -p ~/.claude/skills/auto-rename/scripts

# 复制文件
cp SKILL.md ~/.claude/skills/auto-rename/
cp scripts/rename_session.sh ~/.claude/skills/auto-rename/scripts/

# 添加执行权限
chmod +x ~/.claude/skills/auto-rename/scripts/rename_session.sh
```

### 方法二：克隆仓库

```bash
git clone https://github.com/your-username/CC_session_rename.git
cd CC_session_rename
./install.sh
```

## 使用方法

在 Claude Code 会话中输入：

```
/auto-rename
```

LLM 会自动：
1. 分析当前对话上下文
2. 提取项目名称（从工作目录）
3. 判断任务类型
4. 生成格式化标题
5. 写入 session 文件

## 工作原理

```
/auto-rename
    ↓
1. 分析上下文 → 判断任务类型和描述
2. 提取项目名 → 从 cwd 获取最后一个目录名
3. 生成标题 → CC | {项目} | [{类型}] {描述}
4. 执行脚本 → 写入 custom-title 记录到 session 文件
    ↓
状态栏和 /resume 立即显示新标题
```

## 文件结构

```
CC_session_rename/
├── README.md                 # 项目说明
├── SKILL.md                  # Claude Code Skill 定义文件
├── scripts/
│   └── rename_session.sh     # 重命名脚本
└── install.sh                # 安装脚本（可选）
```

## 技术细节

### Session 文件结构

Claude Code 的 session 文件存储在：
```
~/.claude/projects/<project-name>/<session-id>.jsonl
```

每个文件是 JSONL 格式，`/rename` 命令会添加一条 `custom-title` 记录：

```json
{"type":"custom-title","customTitle":"CC | project | [Build] 描述","sessionId":"xxx","timestamp":"...","uuid":"..."}
```

### 与状态栏联动

当 `custom-title` 记录存在时，Claude Code 后端会将其作为 `session_name` 传递给状态栏脚本，实现：

- **状态栏显示**：`[~/项目] model | CC | project | [Build] 描述 | @时间`
- **`/resume` 列表**：显示自定义标题而非 UUID

## 自定义

### 修改标题格式

编辑 `SKILL.md` 中的 "Title Format" 部分，调整标题生成规则。

### 添加新任务类型

在 `SKILL.md` 的 "Task Types" 表格中添加新类型。

## 许可证

MIT License

## 相关项目

- [CC_stateline](https://github.com/your-username/CC_stateline) - Claude Code 状态栏美化
