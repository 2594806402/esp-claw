# GitHub 项目二次开发 Git 操作指南

本指南总结了基于 GitHub 开源项目进行二次开发的最佳实践，帮助你在保持与原项目同步的同时，维护自己的代码仓库。

## 1. 核心概念：Fork + Upstream 模式

在二次开发中，我们会配置两个远程仓库：
- **origin**: 指向**你自己**在 GitHub 上 Fork 的仓库（你有推送权限）。
- **upstream**: 指向**原作者**的官方仓库（你只有拉取权限，用于同步更新）。

---

## 2. 初始配置步骤

如果你已经克隆了原项目，按照以下步骤重新配置远程仓库：

### 第一步：重命名原仓库为 upstream
```bash
git remote rename origin upstream
```

### 第二步：添加你自己的 Fork 仓库为 origin
```bash
# 请将 <YOUR_USERNAME> 替换为你的 GitHub 用户名
git remote add origin https://github.com/<YOUR_USERNAME>/esp-claw.git
```

### 第三步：验证配置
```bash
git remote -v
```
**理想输出：**
```text
origin    https://github.com/你的用户名/esp-claw.git (fetch)
origin    https://github.com/你的用户名/esp-claw.git (push)
upstream  https://github.com/espressif/esp-claw.git (fetch)
upstream  https://github.com/espressif/esp-claw.git (push)
```

---

## 3. 日常开发流程

### 场景 A：同步原作者的更新
当原项目（upstream）有了新功能或修复时，将其合并到你的本地仓库：

```bash
# 1. 切换到主分支
git checkout master

# 2. 拉取原作者的所有更新
git fetch upstream

# 3. 合并到本地 master
git merge upstream/master

# 4. (可选) 同步到你自己的 GitHub 仓库
git push origin master
```

### 场景 B：开发自己的新功能
**强烈建议**：不要直接在 `master` 分支修改，而是为每个功能创建独立分支。

```bash
# 1. 确保在最新的 master 上创建分支
git checkout master
git pull upstream master

git branch -a
# 查看所有分支，包括远程分支
# 2. 创建并切换到新分支 (例如：my-feature)
git checkout -b my-feature

git switch my-feature
# 3. 修改代码并提交
git add .
git commit -m "feat: 添加传感器支持"

# 4. 推送到你自己的 GitHub
git push origin my-feature

# 直接拉取和合并 upstream/master 到 my-feature 分支
git pull upstream master

# 5. 将原作者的改动“垫”在你的修改之下
git rebase upstream/master
```
### 场景 C：处理代码冲突
如果在执行 `git merge upstream/master` 时出现冲突：
1. 打开冲突文件，搜索 `<<<<<<<`, `=======`, `>>>>>>>` 标记。
2. 手动选择保留哪部分代码。
3. 保存文件。
4. 执行：
   ```bash
   git add <冲突文件名>
   git commit -m "fix: 解决与 upstream 的合并冲突"
   ```

---

## 4. 常用命令速查表

| 操作 | 命令 |
| :--- | :--- |
| 查看远程仓库 | `git remote -v` |
| 切换分支 | `git checkout <branch-name>` |
| 创建并切换分支 | `git checkout -b <branch-name>` |
| 查看状态 | `git status` |
| 提交修改 | `git commit -m "message"` |
| 推送到自己仓库 | `git push origin <branch-name>` |
| 从原厂同步 | `git fetch upstream` + `git merge upstream/master` |

---
*本指南由 Trae AI 生成，旨在协助开发者更高效地参与开源项目开发。*
