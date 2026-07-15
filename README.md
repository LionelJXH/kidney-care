# 🩺 肾康助手 — 慢性肾病健康管理元服务

> **项目类型**：HarmonyOS 元服务（Atomic Service）  
> **开发目标**：为慢性肾病（CKD）早期患者提供每日健康数据记录工具  
> **IDE 版本**：DevEco Studio 6.1.1  
> **SDK 版本**：HarmonyOS 5.0.0 Release (API 12)

---

## 一、已实现功能

### 1️⃣ 首页仪表盘（Index.ets）

**位置**：`entry/src/main/ets/pages/Index.ets`

**功能**：
- 显示 **今日血压记录次数** 和最近一次的血压值
- 显示最近一次的 **体重记录**
- 显示最近一次的 **化验记录**（血检/尿检）
- 四个快捷入口：**血压记录、体重记录、化验记录、历史记录**

**实现方式**：
```typescript
// 异步加载今日数据
async loadTodayData(): Promise<void> {
  const bpRecords = await getTodayBpRecords();   // 从 SQLite 查询今日血压
  this.todayBpCount = bpRecords.length;
  // ... 更新 @State 变量，自动触发 UI 刷新
}
```
- 数据通过 `Database.ets` 封装的 SQLite 操作获取
- 使用 `@State` 装饰器驱动 UI 响应式更新
- `onPageShow()` 生命周期确保每次回到首页时刷新数据

**界面效果**：

```
┌──────────────────────────────────────┐
│  🩺 肾康助手                          │
│                                      │
│  ┌─ 今日概览 ──────────────────────┐ │
│  │ 血压记录                    3 次 │ │
│  │ 最近 14:32    128/85 mmHg       │ │
│  └────────────────────────────────┘ │
│                                      │
│  ┌──────┐  ┌──────┐                 │
│  │ ❤️  │  │ ⚖️  │                 │
│  │ 血压  │  │ 体重  │                 │
│  │ 128/85│  │ 68.5  │                 │
│  └──────┘  └──────┘                 │
│                                      │
│  ┌─ 🧪 化验记录 ─────────────────┐ │
│  │ 最近: 2026年7月15日 血检       │ │
│  └────────────────────────────────┘ │
│                                      │
│  ┌─ 📊 查看历史记录 ────────────┐ │
│  │                         >     │ │
│  └────────────────────────────────┘ │
└──────────────────────────────────────┘
```

---

### 2️⃣ 血压记录（BloodPressurePage.ets）

**位置**：`entry/src/main/ets/pages/BloodPressurePage.ets`

**功能**：
- 录入 **收缩压（高压）**、**舒张压（低压）**、**脉搏（可选）**
- **时间自动生成**：记录当前系统时间，精确到分钟
- 实时判断血压是否偏高：收缩压 > 130 或舒张压 > 85 时显示 ⚠️ 提示
- 输入校验：范围检查（收缩压 50~260，舒张压 30~200）

**实现方式**：
```typescript
// 时间自动生成
aboutToAppear(): void {
  this.currentTime = formatTime(Date.now());  // 每次进入页面自动获取当前时间
}

// 保存时自动记录时间戳
await insertBpRecord({
  timestamp: Date.now(),  // 以毫秒时间戳保存，精确记录录入时刻
  systolic: sys,
  diastolic: dia,
  pulse: parseInt(this.pulse) || 0
});
```

**用户交互流程**：
```
进入页面 → 时间自动显示(14:32) → 填写收缩压/舒张压 →
                     ↓
             实时判断是否偏高 →
             正常(绿色) / 偏高(红色+⚠️) →
                     ↓
               点击"保存" → 数据写入 SQLite → 自动返回首页
```

---

### 3️⃣ 体重记录（WeightPage.ets）

**位置**：`entry/src/main/ets/pages/WeightPage.ets`

**功能**：
- 录入体重数值（kg）
- **时间自动生成**
- 输入校验：范围 20~300 kg
- 健康提示：为何肾病患者需要监测体重

**实现方式**：
与血压记录类似，使用 `insertWeightRecord()` 存入 SQLite。

---

### 4️⃣ 化验记录（LabTestPage → LabTestDetailPage）

**位置**：
- `entry/src/main/ets/pages/LabTestPage.ets`（选择血检/尿检）
- `entry/src/main/ets/pages/LabTestDetailPage.ets`（填写指标）

**功能**：
- 选择 **血检** 或 **尿检**
- 血检 10 项指标，尿检 8 项指标
- **数值型指标**：输入框填写具体数字（如肌酐 85 μmol/L）
- **定性指标**：选择阴/阳性（如尿蛋白：-、+、++、+++）
- 每项指标旁显示正常参考范围
- **日期可调**：支持修改为实际化验日期

**关键指标清单**：

| 类别 | 指标 | 类型 | 正常范围 |
|------|------|------|----------|
| 血检 | 血肌酐 (Cr) | 数值 | 44~106 μmol/L |
| 血检 | 尿素氮 (BUN) | 数值 | 2.5~7.1 mmol/L |
| 血检 | eGFR | 数值 | ≥90 mL/min·1.73m² |
| 血检 | 尿酸 (UA) | 数值 | 150~440 μmol/L |
| 血检 | 血红蛋白 (Hb) | 数值 | 115~175 g/L |
| 血检 | 血钾 (K⁺) | 数值 | 3.5~5.5 mmol/L |
| 血检 | 血磷 (P) | 数值 | 0.85~1.45 mmol/L |
| 血检 | 血钙 (Ca²⁺) | 数值 | 2.1~2.6 mmol/L |
| 血检 | PTH | 数值 | 10~65 pg/mL |
| 血检 | 白蛋白 (ALB) | 数值 | 35~55 g/L |
| 尿检 | 尿蛋白 (Pro) | 定性选择 | -（阴性） |
| 尿检 | 尿潜血 (BLD) | 定性选择 | -（阴性） |
| 尿检 | 尿糖 (GLU) | 定性选择 | -（阴性） |
| 尿检 | 尿酮体 (KET) | 定性选择 | -（阴性） |
| 尿检 | ACR | 数值 | <30 mg/g |
| 尿检 | 尿 pH 值 | 数值 | 4.5~8.0 |
| 尿检 | 尿比重 (SG) | 数值 | 1.003~1.030 |
| 尿检 | 24h 尿蛋白定量 | 数值 | <150 mg/24h |

**实现方式**：
```typescript
// 常量定义（Constants.ets）
export const BLOOD_TEST_ITEMS: TestItem[] = [
  { key: 'creatinine', name: '血肌酐 (Cr)', unit: 'μmol/L', type: 'number', normalRange: '44~106', ... },
  // type: 'number' → TextInput 输入框
  // type: 'select' → Radio 选择
];

// 保存为 JSON
items: JSON.stringify(filledItems)  // 灵活性：不同化验组合可独立存储
```

> **注意**：当前 LabTestDetailPage 为简化版，仅显示日期选择 + 说明。完整的化验指标填写界面需后续完成（见 TODO 章节）。

---

### 5️⃣ 历史记录（HistoryPage.ets）

**位置**：`entry/src/main/ets/pages/HistoryPage.ets`

**功能**：
- 三个 Tab：**血压历史**、**体重历史**、**化验历史**
- 按时间倒序排列
- 血压记录显示收缩压/舒张压数值及时间
- 体重记录显示体重数值及时间
- 化验记录显示化验类型、日期和指标数

---

### 6️⃣ 数据持久化（Database.ets）

**位置**：`entry/src/main/ets/common/Database.ets`

**技术方案**：HarmonyOS `@ohos.data.relationalStore` (SQLite)

**数据库表结构**：

```sql
-- 血压记录表
CREATE TABLE blood_pressure (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  timestamp INTEGER NOT NULL,    -- 记录时间戳
  systolic INTEGER NOT NULL,      -- 收缩压
  diastolic INTEGER NOT NULL,     -- 舒张压
  pulse INTEGER DEFAULT 0,        -- 脉搏
  create_time INTEGER NOT NULL    -- 创建时间
);

-- 体重记录表
CREATE TABLE weight_record (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  timestamp INTEGER NOT NULL,    -- 记录时间戳
  weight REAL NOT NULL,           -- 体重(kg)
  create_time INTEGER NOT NULL
);

-- 化验记录表
CREATE TABLE lab_test (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  timestamp INTEGER NOT NULL,    -- 化验日期
  test_type TEXT NOT NULL,        -- 'blood' 或 'urine'
  items TEXT NOT NULL,            -- JSON 格式的化验项目
  create_time INTEGER NOT NULL
);
```

**导出的 API**：
- `insertBpRecord()`、`getBpRecords()`、`getTodayBpRecords()`、`getLatestBpRecord()`
- `insertWeightRecord()`、`getWeightRecords()`、`getLatestWeight()`
- `insertLabTest()`、`getLabTests()`、`getLatestLabTest()`

---

## 二、项目文件结构

```
kidney-care/                ← 项目根目录
├── AppScope/
│   └── app.json5            ← 应用全局配置（包名、版本号）
├── entry/
│   ├── src/main/
│   │   ├── module.json5     ← 模块配置（类型、权限、Ability 注册）
│   │   ├── ets/
│   │   │   ├── entryability/
│   │   │   │   └── EntryAbility.ts   ← 应用入口
│   │   │   ├── pages/
│   │   │   │   ├── Index.ets              ← 首页仪表盘
│   │   │   │   ├── BloodPressurePage.ets  ← 血压记录
│   │   │   │   ├── WeightPage.ets         ← 体重记录
│   │   │   │   ├── LabTestPage.ets        ← 化验选择
│   │   │   │   ├── LabTestDetailPage.ets  ← 化验指标填写
│   │   │   │   └── HistoryPage.ets        ← 历史记录
│   │   │   └── common/
│   │   │       ├── Constants.ets  ← 常量、类型定义、工具函数
│   │   │       └── Database.ets   ← SQLite 数据库封装
│   │   └── resources/
│   │       ├── base/
│   │       │   ├── element/
│   │       │   │   ├── string.json  ← 中文字符串资源
│   │       │   │   └── color.json   ← 颜色资源
│   │       │   ├── media/
│   │       │   │   └── app_icon.png ← 应用图标
│   │       │   └── profile/
│   │       │       └── main_pages.json ← 页面路由注册
│   │       ├── en_US/element/string.json
│   │       └── zh_CN/element/string.json
│   ├── build-profile.json5  ← 模块构建配置
│   ├── oh-package.json5     ← 模块包依赖
│   └── hvigorfile.ts        ← 模块构建脚本
├── build-profile.json5      ← 项目级构建配置
├── oh-package.json5         ← 项目级包配置
├── hvigorfile.ts            ← 项目级构建脚本
├── code-linter.json5        ← 代码检查规则
└── .gitignore
```

---

## 三、技术架构

### 数据流

```
用户操作 → @State 变量更新
                ↓
        调用 Database.ets API
                ↓
        SQLite (relationalStore)
                ↓
        数据持久化到本地
                ↓
        页面间跳转 (router.pushUrl)
```

### 状态管理

- 所有页面使用 `@State` 装饰器管理局部状态
- 数据变化时 UI 自动刷新（响应式）
- 页面切换通过 `router.pushUrl()` 导航

### 颜色主题

| 用途 | 颜色值 | CSS 变量 |
|------|--------|----------|
| 主色调（蓝色） | #4A90D9 | COLOR_PRIMARY |
| 警告（红色） | #E8573A | COLOR_WARNING |
| 正常（绿色） | #4CAF50 | COLOR_NORMAL |
| 主文字 | #1A1A2E | COLOR_TEXT_PRIMARY |
| 次要文字 | #8E8EA0 | COLOR_TEXT_SECONDARY |
| 提示文字 | #B0B0C0 | COLOR_TEXT_HINT |
| 卡片背景 | #FFFFFF | COLOR_CARD |
| 页面背景 | #F7F8FC | COLOR_PAGE |

---

## 四、运行方式

### 环境要求
- DevEco Studio 6.1.1+
- HarmonyOS SDK 5.0.0(12) (API 12)
- Windows 10/11（需开启 Hyper-V 运行模拟器）

### 启动步骤
1. 打开 DevEco Studio → **File → Open** → 选择 `kidney-care` 目录
2. 等待 IDE 同步完成（首次需下载 SDK，约 5~10 分钟）
3. 工具栏选择 **Pura 90 模拟器**（或设备列表中的其他模拟器）
4. 点击 ▶️ **Run** 按钮
5. 应用自动编译并安装到模拟器

### 常见编译问题
| 问题 | 解决方案 |
|------|----------|
| 项目路径含中文 | 改为纯英文路径 |
| Hyper-V 未开启 | 控制面板 → 启用或关闭 Windows 功能 → 勾选 Hyper-V |
| SDK 版本不匹配 | 检查 build-profile.json5 中的 compatibleSdkVersion |

---

## 五、TODO（待完善功能）

- [ ] **LabTestDetailPage 完整实现**：当前为占位页面，缺少化验指标的动态表单生成（RadioGroup + TextInput）
- [ ] **血压趋势图表**：使用 `@ohos.graphic.drawing` 或 Canvas 绘制折线图
- [ ] **体重趋势图表**
- [ ] **提醒功能**：每日定时提醒记录血压/体重
- [ ] **数据导出**：导出为 CSV/PDF 供医生查看
- [ ] **云同步**：将数据备份到云端
- [ ] **暗色模式**
- [ ] **用药记录**：添加药物服用记录功能
- [ ] **更详细的化验指标**：根据 CKD 分期动态调整指标列表

---

## 六、实现方法详解

### 6.1 如何新增一个记录页面

1. 在 `entry/src/main/ets/pages/` 下新建 `.ets` 文件
2. 在 `entry/src/main/resources/base/profile/main_pages.json` 中注册页面
3. 在 `Database.ets` 中添加对应的数据库表和 CRUD 方法
4. 在 `Constants.ets` 中添加需要的类型定义

### 6.2 数据库调用模式

```typescript
// 1. 获取数据库实例（自动创建表）
const store = await getRdbStore();

// 2. 插入数据
const rowId = await store.insert('table_name', { key: value });

// 3. 查询数据
const result = await store.querySql('SELECT * FROM table WHERE condition');
while (result.goToNextRow()) {
  // 读取字段
  const val = result.getLong(result.getColumnIndex('column_name'));
}
result.close();
```

### 6.3 页面路由

```typescript
// 跳转到目标页面（带参数）
router.pushUrl({
  url: 'pages/TargetPage',
  params: { key: 'value' }
});

// 在目标页面接收参数
const params = router.getParams() as { [key: string]: string };

// 返回上一页
router.back();
```

---

*最后更新：2026年7月15日*
