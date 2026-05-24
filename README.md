# 家庭学习追踪系统

全家多设备实时同步的学习数据追踪系统，支持电脑、iPad、手机同时访问。

## 🚀 快速部署（5分钟完成）

### 第一步：创建 Supabase 项目（免费）

1. 访问 [supabase.com](https://supabase.com) 注册账号
2. 点击 "New Project"
3. 填写项目名称（如 `family-study-tracker`）
4. 设置数据库密码（记下来）
5. 选择离你近的区域（新加坡/东京）
6. 点击 "Create new project"

### 第二步：配置数据库

1. 进入项目后，点击左侧 **SQL Editor**
2. 点击 **New query**，粘贴 `supabase-setup.sql` 的全部内容
3. 点击 **Run** 执行

### 第三步：获取项目信息

1. 点击左侧 **Settings** → **API**
2. 复制：
   - **Project URL**（如 `https://xxxxx.supabase.co`）
   - **anon public** 密钥

### 第四步：修改前端配置

用文本编辑器打开 `index.html`，找到顶部配置区：

```javascript
const SUPABASE_URL = 'YOUR_SUPABASE_URL';
const SUPABASE_KEY = 'YOUR_ANON_KEY';
```

替换为你的实际 URL 和密钥。

### 第五步：部署到 Vercel（免费，推荐）

1. 访问 [vercel.com](https://vercel.com) 注册（可用 GitHub 登录）
2. 点击 **Add New** → **Project**
3. 导入 GitHub 仓库或直接拖拽 `study-tracker-web` 文件夹
4. 点击 **Deploy**

**或直接上传到任意静态托管服务**：Netlify、GitHub Pages、Cloudflare Pages 等。

## 📱 使用方式

### 注册家庭账号
1. 打开部署后的网站
2. 点击"注册"，填写：
   - 家庭名称（如"张家"）
   - 孩子姓名（如"小明"）
   - 邮箱和密码
3. 注册后登录

### 录入数据
- 爸爸用电脑录入考试成绩
- 妈妈用 iPad 录入作业错题数
- 爷爷奶奶用手机查看趋势图表
- **所有设备数据实时同步**

## 🔧 技术架构

```
前端 (index.html)
  ├─ Supabase Auth (用户认证)
  ├─ Supabase Database (数据存储)
  └─ Chart.js (趋势图表)
```

**数据库表结构**：
- `study_records` - 学习记录（日期/分数/错题数）
- `user_profiles` - 用户资料（家庭/孩子名称）

## ⚙️ 本地测试

```bash
# 安装依赖（Python 3）
python -m http.server 8000

# 浏览器访问
http://localhost:8000
```

## 🔒 安全特性

1. **行级安全策略**：每个用户只能访问自己的数据
2. **邮箱验证**：注册需邮箱验证（可在 Supabase 控制台关闭）
3. **HTTPS 加密**：所有数据传输加密
4. **密码哈希**：密码不存储明文

## 📊 数据备份

Supabase 提供自动备份，也可手动导出：
1. 进入 Supabase Dashboard → Database
2. 点击 **Backups** 查看自动备份
3. 或点击 **Table Editor** → 选择表 → 点击 **Export**

## 🆘 常见问题

**Q: 注册后没收到验证邮件？**
A: 在 Supabase Dashboard → Authentication → Settings → 关闭 "Enable email confirmations"

**Q: 如何重置密码？**
A: 在登录页面点击"忘记密码"，或 Supabase Dashboard → Authentication → Users 中重置

**Q: 数据会丢失吗？**
A: Supabase 免费版有 500MB 存储，足够存储数万条记录

**Q: 可以多人同时录入吗？**
A: 可以，系统会自动合并同一天的数据

## 📞 支持

如有问题，请检查：
1. Supabase 项目是否正常运行
2. API 密钥是否正确
3. 浏览器控制台是否有错误（F12 → Console）

---

**部署完成后，全家即可通过同一个网址访问，数据完全同步！**