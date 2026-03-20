# 🎛️ CoDeck

**把你的项目变成一张人人都能看懂的地图。**

[English](README.md)

CoDeck 是一个 Claude Code skill，扫描你的代码库，生成一个交互式 HTML 仪表盘。不用读代码，也能清楚地看到项目里有什么、怎么运作、用户怎么用它。

<!-- TODO: Add screenshot of a real CoDeck dashboard here -->
<!-- ![CoDeck Dashboard](./assets/demo-screenshot.png) -->

---

## 你会用到它的几个时刻

**搞不清自己的项目了。** 你用 AI 搭了很久，改来改去，某一天突然不知道哪个文件是干嘛的了。打开 CoDeck，五分钟找回全局感。

**要向别人演示你在做什么。** 朋友问你这个项目是干嘛的，家人想知道你在搞什么，一个 `codeck.html` 发过去，不需要任何解释，他们自己就能点开看懂。

**准备 pitch 或汇报。** 投资人、合作方、导师，拉起 CoDeck 仪表盘，用户流程、系统架构、项目进度一目了然，比 PPT 更直接，也更真实。

**刚让 AI 改完一堆东西。** 用 `update codeck` 做一次快照对比，看清这次改动影响了哪些部分，心里有底再继续。

---

## 生成之后你会看到什么

在 Claude Code 里说一句：

```
generate codeck
```

项目根目录会出现一个 `codeck.html`，在浏览器里打开，有五个标签页：

🏆 **成长故事** — 提交时间线、代码量曲线、里程碑徽章。从零到现在，你做了多少。

⚙️ **运作机制** — 项目里那几个核心流程的可视化管线图。点击任意一步，看清数据是怎么流动的。

🗺️ **用户旅程** — 用户从进入到完成操作的完整路径图，每个分支都能展开。

🏗️ **项目架构** — 按 UI → 逻辑 → 数据分层展示。每个文件都可以点开，看一句话说清它是干嘛的。

📊 **项目健康** — 文件数、依赖项、TODO 数量、活跃度热力图。

---

## 几个实用细节

- **单文件，零依赖** — 生成的是一个独立 HTML 文件，发给任何人都能直接打开，不需要安装任何东西。
- **自动识别语言** — 根据你的 README、注释和提交记录判断用中文还是英文生成，拿不准的时候会问你。
- **跟项目保持同步** — 手动跑 `update codeck` 做增量更新，或者装一个 git hook，每次提交后自动提醒你。
- **复杂度自适应** — 小项目出简洁单页，大型 monorepo 会自动加侧边栏导航和搜索。

---

## 快速上手

```bash
# 装在项目里（推荐，跟着仓库走）
mkdir -p .claude/skills
git clone https://github.com/YOUR_USERNAME/codeck.git .claude/skills/codeck
```

然后在 Claude Code 里直接说 `generate codeck` 就行。

---

## License

MIT
