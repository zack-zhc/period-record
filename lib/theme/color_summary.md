# 应用颜色使用总结

## 概述
本文档总结了经期记录应用中使用的所有颜色，包括主题颜色、基础颜色和功能颜色。

## 颜色分类

### 1. 基础颜色
- **白色 (Colors.white)**: 用于图标、文本背景、按钮文字等
- **透明色 (Colors.transparent)**: 用于透明背景
- **黑色 (Colors.black)**: 用于某些特殊场景

### 2. 功能颜色
- **蓝色 (Colors.blue)**: 统计图表中的第一个数据系列
- **绿色 (Colors.green)**: 统计图表中的第二个数据系列  
- **橙色 (Colors.orange)**: 统计图表中的第三个数据系列

### 3. 主题颜色 (Material 3 ColorScheme)

#### 主要颜色
- **primary**: 应用主色调，用于重要按钮、图标、强调元素
- **secondary**: 次要颜色，用于辅助按钮、图标
- **tertiary**: 第三级颜色，用于其他UI元素
- **error**: 错误颜色，用于错误状态、警告

#### 容器颜色
- **primaryContainer**: 主要容器背景色
- **secondaryContainer**: 次要容器背景色
- **tertiaryContainer**: 第三级容器背景色
- **errorContainer**: 错误容器背景色

#### 表面颜色
- **surface**: 主要表面背景色
- **surfaceContainer**: 容器表面背景色
- **surfaceContainerHighest**: 最高层级容器表面色

#### 文本颜色
- **onSurface**: 表面上的主要文本颜色
- **onSurfaceVariant**: 表面上的次要文本颜色
- **onPrimary**: 主要颜色上的文本颜色
- **onSecondary**: 次要颜色上的文本颜色
- **onTertiary**: 第三级颜色上的文本颜色
- **onError**: 错误颜色上的文本颜色
- **onPrimaryContainer**: 主要容器上的文本颜色
- **onSecondaryContainer**: 次要容器上的文本颜色
- **onTertiaryContainer**: 第三级容器上的文本颜色
- **onErrorContainer**: 错误容器上的文本颜色

#### 轮廓颜色
- **outline**: 轮廓线颜色

## 颜色使用场景

### 1. 主页 (HomePage)
- **背景渐变**: surface → surface.withAlpha(0.8)
- **AppBar渐变**: 使用 appBarGradient（亮色：primary → secondary，暗色：primaryContainer → secondaryContainer）
- **AppBar图标背景**: 亮色主题使用 white.withAlpha(0.2)，暗色主题使用 onPrimaryContainer.withAlpha(0.2)
- **AppBar文字**: 亮色主题使用 white，暗色主题使用 onPrimaryContainer
- **Floating Action Button**: 使用 addButtonGradient（开始记录）或 endButtonGradient（结束记录）

### 2. 生理期状态组件 (PeriodStatusWidgets)
- **无记录状态**: 使用 noPeriodGradient（亮色：primary/secondary 0.1透明度，暗色：primaryContainer/secondaryContainer）
- **生理期今天开始**: 使用 periodStartedGradient（亮色：error渐变，暗色：浅红色渐变）
- **生理期进行中**: 使用 periodInProgressGradient（亮色：error渐变，暗色：浅粉色渐变）
- **生理期结束**: 使用 periodEndedGradient（亮色：primary/secondary渐变，暗色：浅绿色渐变）
- **默认状态**: 使用 defaultStatusGradient（亮色：primary/secondary 0.8透明度，暗色：浅紫色渐变）
- **天数显示**: 根据主题调整透明度和边框颜色
- **图标和文字**: 统一使用白色，确保在渐变背景上的可读性

### 3. 设置页面 (SettingsPage)
- **背景渐变**: surface → surfaceContainer
- **设置卡片**: 使用primary、secondary、tertiary作为图标颜色
- **底部装饰**: outline.withAlpha(0.3)

### 4. 统计页面 (StatsPage)
- **统计卡片**: primaryContainer → secondaryContainer 渐变背景
- **图表颜色**: blue、green、orange
- **卡片边框**: white.withAlpha(0.2)

### 5. 日历组件 (PeriodTableCalendar)
- **周末文字**: error
- **今天装饰**: primaryContainer
- **选中装饰**: primary
- **标记装饰**: primary
- **生理期范围**: primaryContainer.withAlpha(0.8)

### 6. 记录列表 (PeriodGridView)
- **进行中记录**: errorContainer 背景，error 图标
- **已完成记录**: primaryContainer 背景，primary 图标
- **未完成记录**: errorContainer 背景，error 图标

### 7. 快速操作卡片 (QuickActionsCard)
- **按钮背景**: primaryContainer.withAlpha(0.3)
- **按钮边框**: primaryContainer.withAlpha(0.5)
- **按钮图标和文字**: primary

### 8. 生物识别组件 (BiometricLockTile)
- **图标背景**: secondaryContainer
- **图标颜色**: secondary
- **开关激活色**: secondary

### 9. 数据备份组件 (DataBackupTile)
- **图标背景**: secondaryContainer
- **图标颜色**: onSecondaryContainer
- **成功提示**: primary 背景，onPrimary 文字
- **错误提示**: error 背景，onError 文字

## 透明度使用

### 常用透明度值
- **0.1 (10%)**: 用于浅色背景
- **0.2 (20%)**: 用于半透明背景
- **0.3 (30%)**: 用于中等透明度
- **0.5 (50%)**: 用于半透明边框
- **0.6 (60%)**: 用于次要文本
- **0.7 (70%)**: 用于描述文本
- **0.8 (80%)**: 用于渐变效果

### 透明度使用场景
- **背景透明度**: 用于创建层次感
- **边框透明度**: 用于柔和的分割线
- **文本透明度**: 用于次要信息
- **图标透明度**: 用于装饰性元素

## 渐变使用

### 主要渐变组合
1. **primary → secondary**: 用于主要UI元素
2. **error → error.withAlpha(0.8)**: 用于错误状态
3. **surface → surfaceContainer**: 用于页面背景
4. **primaryContainer → secondaryContainer**: 用于卡片背景
5. **appBarGradient**: AppBar专用渐变（自动适配亮色/暗色主题）

### 状态组件专用渐变
6. **noPeriodGradient**: 无记录状态渐变（自动适配主题）
7. **periodStartedGradient**: 生理期开始渐变（亮色：error渐变，暗色：浅红色渐变）
8. **periodInProgressGradient**: 生理期进行中渐变（亮色：error渐变，暗色：浅粉色渐变）
9. **periodEndedGradient**: 生理期结束渐变（亮色：primary/secondary渐变，暗色：浅绿色渐变）
10. **defaultStatusGradient**: 默认状态渐变（亮色：primary/secondary 0.8透明度，暗色：浅紫色渐变）

### Floating Action Button专用渐变
11. **addButtonGradient**: 开始记录按钮渐变（亮色：primary/secondary渐变，暗色：粉色渐变）
12. **endButtonGradient**: 结束记录按钮渐变（亮色：error渐变，暗色：绿色渐变）

## 主题适配

### 亮色主题
- 使用 Material 3 亮色主题
- 种子颜色: #E91E63 (粉色)

### 暗色主题  
- 使用 Material 3 暗色主题
- 种子颜色: #E91E63 (粉色)
- **优化配置**:
  - primaryContainer: #2D1B2E (深紫红色)
  - secondaryContainer: #1F1B2E (深蓝紫色)
  - onPrimaryContainer: #F8BBD9 (浅粉色文字)
  - onSecondaryContainer: #E1BEE7 (浅紫色文字)

## AppBar优化说明

### 问题
原来的AppBar在暗色主题下使用固定的白色文字和图标，与深色背景的对比度不够理想。

### 解决方案
1. **自适应渐变**: 使用 `appBarGradient` 根据主题自动选择渐变颜色
2. **智能文字颜色**: 亮色主题使用白色，暗色主题使用 `onPrimaryContainer`
3. **优化图标背景**: 使用半透明的容器文字颜色作为背景
4. **保持一致性**: 所有元素都遵循主题颜色规范

### 效果
- **亮色主题**: 粉色渐变背景 + 白色文字/图标
- **暗色主题**: 深色渐变背景 + 浅粉色文字/图标
- **对比度**: 两种主题下都有良好的可读性
- **美观性**: 保持应用的视觉一致性

## 状态组件优化说明

### 问题
原来的状态组件在暗色主题下存在以下问题：
1. **无记录状态**: 使用0.1透明度的primary/secondary，在暗色模式下太淡
2. **生理期进行中**: 使用error颜色，在暗色模式下太刺眼
3. **生理期结束**: 使用primary/secondary渐变，在暗色模式下不够突出
4. **默认状态**: 使用0.8透明度的primary/secondary，在暗色模式下太暗

### 解决方案
1. **专用渐变系统**: 为每种状态创建专用的渐变组合
2. **主题适配颜色**: 根据亮色/暗色主题选择不同的颜色方案
3. **优化对比度**: 确保所有文字和图标在背景上有良好的可读性
4. **统一设计语言**: 保持与整体主题的一致性

### 暗色主题颜色方案
- **无记录状态**: 使用 `primaryContainer` 到 `secondaryContainer` 的渐变
- **生理期今天开始**: 使用浅红色渐变 (#E57373 → #EF5350)
- **生理期进行中**: 使用浅粉色渐变 (#F06292 → #EC407A)
- **生理期结束**: 使用浅绿色渐变 (#81C784 → #66BB6A)
- **默认状态**: 使用浅紫色渐变 (#9575CD → #7E57C2)

### 效果
- **视觉层次**: 每种状态都有独特的颜色标识
- **可读性**: 白色文字和图标在所有渐变背景上都清晰可见
- **美观性**: 柔和的颜色搭配，不会在暗色模式下过于刺眼
- **一致性**: 保持与AppBar和其他组件的设计风格一致

## Floating Action Button优化说明

### 问题
原来的Floating Action Button在暗色主题下存在以下问题：
1. **开始记录按钮**: 使用primary到secondary渐变，在暗色模式下不够突出
2. **结束记录按钮**: 使用error渐变，在暗色模式下太刺眼
3. **阴影颜色**: 直接使用primary或error颜色，在暗色模式下可能不合适

### 解决方案
1. **专用渐变系统**: 为开始记录和结束记录按钮创建专用的渐变组合
2. **主题适配颜色**: 根据亮色/暗色主题选择不同的颜色方案
3. **优化阴影效果**: 调整阴影颜色和透明度，确保在暗色模式下有合适的视觉效果
4. **统一设计语言**: 保持与整体主题的一致性

### 暗色主题颜色方案
- **开始记录按钮**: 使用粉色渐变 (#E91E63 → #C2185B)
- **结束记录按钮**: 使用绿色渐变 (#4CAF50 → #388E3C)
- **阴影颜色**: 使用对应颜色的0.4透明度
- **文字和图标**: 统一使用白色，确保可读性

### 效果
- **视觉突出**: 开始记录按钮使用粉色，符合应用主题
- **状态区分**: 结束记录按钮使用绿色，与"完成"概念相符
- **可读性**: 白色文字和图标在所有渐变背景上都清晰可见
- **美观性**: 柔和的颜色搭配，不会在暗色模式下过于刺眼
- **一致性**: 保持与AppBar和状态组件的设计风格一致

## 最佳实践

1. **优先使用主题颜色**: 避免硬编码颜色值
2. **使用透明度变体**: 通过 withAlpha() 方法创建透明度变体
3. **保持一致性**: 相同功能的元素使用相同的颜色
4. **考虑可访问性**: 确保颜色对比度符合标准
5. **支持主题切换**: 所有颜色都应该支持亮色/暗色主题
6. **使用专用渐变**: 对于特殊场景（如AppBar）使用专用的渐变组合

## 迁移指南

要将现有代码迁移到新的颜色系统：

1. 将 `Colors.white` 替换为 `AppColors.white`
2. 将 `Theme.of(context).colorScheme.primary` 替换为 `AppColors.of(context).primary`
3. 将 `color.withValues(alpha: 0.1)` 替换为 `AppColors.of(context).primaryWithAlpha(0.1)`
4. 将渐变数组替换为预定义的渐变组合
5. 对于AppBar，使用 `colors.appBarGradient` 替代手动定义的渐变

这样可以确保颜色的一致性和可维护性。 