---
name: auto-rename
description: Automatically generates a smart session title based on conversation context and renames the session. Call this skill when you want to rename the current session with an auto-generated descriptive title, or at the start of a new session when the user provides their first meaningful prompt.
min_claude_code_version: "1.0.0"
version: "1.0.0"
---

# Auto Rename Session

## Overview

Automatically analyzes the conversation context and generates a smart session title in the format: `CC | 项目名 | [类型]描述`. This makes it easy to identify sessions in `/resume` and the status bar.

## When to Use

**Trigger this skill:**
- At the start of a new session (when user provides first meaningful prompt)
- When user asks to rename/summarize the current session
- When the task direction changes significantly

**Do NOT trigger:**
- Multiple times in the same session (once is enough)
- For simple follow-up questions
- When user has already provided a custom name via `/rename`

## Title Format

```
CC | {项目名} | [{类型}] {描述}
```

### Components:

1. **CC** - Fixed prefix (Claude Code)
2. **项目名** - Last directory name from current working directory
3. **类型** - Task type from the list below
4. **描述** - Concise task description (max 20 chars in Chinese, 30 chars in English)

### Task Types:

| 类型 | 英文 | 适用场景 |
|------|------|---------|
| Build | Build | 创建新功能、新组件、新模块 |
| Debug | Debug | 调试问题、修复 bug |
| Refactor | Refactor | 重构代码、优化结构 |
| Test | Test | 编写测试、测试相关 |
| Doc | Doc | 文档编写、注释添加 |
| Review | Review | 代码审查、分析代码 |
| Config | Config | 配置文件、环境设置 |
| Research | Research | 调研、学习、探索 |
| Chat | Chat | 问答、讨论、咨询 |

## How to Generate Title

### Step 1: Extract Project Name
Get the last directory name from the current working directory (`cwd`):
- `/Users/username/Desktop/Projects/RDAgent` → `RDAgent`
- `/Users/username/Desktop/Projects/my-project` → `my-project`

### Step 2: Determine Task Type
Analyze the user's prompt to determine the primary task type.

### Step 3: Generate Description
Create a concise description (NOT a full sentence):
- Good: "JWT认证实现", "API连接问题", "论文阅读分析"
- Bad: "用户想要实现JWT认证功能", "I am working on..."

## Examples

### Example 1: Debug Task
User: "帮我调试一下API连接总是超时的问题"
- Project: `RDAgent` (from cwd)
- Type: `[Debug]`
- Description: `API连接超时`
- **Generated Title**: `CC | RDAgent | [Debug] API连接超时`

### Example 2: Build Task
User: "创建一个新的用户认证模块"
- Project: `my-project`
- Type: `[Build]`
- Description: `用户认证模块`
- **Generated Title**: `CC | my-project | [Build] 用户认证模块`

### Example 3: Research Task
User: "你能做什么？关于skill"
- Project: `my-project`
- Type: `[Research]`
- Description: `Skill功能调研`
- **Generated Title**: `CC | my-project | [Research] Skill功能调研`

## Implementation

When this skill is triggered, follow these steps:

### Step 1: Analyze and Generate Title
Follow the guidelines above to generate a title in format: `CC | {项目名} | [{类型}] {描述}`

### Step 2: Execute Rename Script
Execute the rename script with the current session ID and generated title:

```bash
bash ~/.claude/skills/auto-rename/scripts/rename_session.sh "<session_id>" "<generated_title>"
```

The current session ID can be found in the system context or from the session file.

**Example:**
```bash
bash ~/.claude/skills/auto-rename/scripts/rename_session.sh "b725e9b5-711b-472f-a84e-ad39849d2b5a" "CC | my-project | [Build] Session自动命名Skill"
```

### Step 3: Confirm
After successful execution, briefly inform the user: "已自动重命名会话为: {title}"

## Notes

- Keep descriptions SHORT - the title should fit in the status bar
- Use Chinese for Chinese prompts, English for English prompts
- If uncertain about task type, use `[Chat]` as default
- Do NOT include date/time in the title (it's shown separately in status bar)
- The script handles JSON escaping and existing title removal automatically
