# 应用主题系统

## 概述

这个主题系统为经期记录应用提供了统一的颜色管理方案，基于 Material 3 设计规范，支持亮色和暗色主题切换。

## 文件结构

```
lib/theme/
├── app_colors.dart          # 主要颜色定义和主题类
├── color_summary.md         # 颜色使用总结文档
├── color_usage_examples.dart # 颜色使用示例
└── README.md               # 本文件
```

## 核心类

### AppColors
应用颜色的主要入口类，提供：
- 基础颜色常量（白色、透明色、黑色等）
- 功能颜色（蓝色、绿色、橙色等）
- 主题颜色访问方法

### ThemeColors
主题颜色扩展类，提供：
- Material 3 ColorScheme 的所有颜色访问
- 透明度变体方法
- 预定义渐变组合
- 常用透明度常量

### AppTheme
应用主题数据类，提供：
- 亮色主题配置
- 暗色主题配置
- 基于粉色种子颜色的主题生成

## 使用方法

### 1. 基础颜色使用

```dart
import 'package:test_1/theme/app_colors.dart';

// 使用基础颜色
color: AppColors.white
color: AppColors.transparent
color: AppColors.black
```

### 2. 主题颜色使用

```dart
import 'package:test_1/theme/app_colors.dart';

// 获取主题颜色
final colors = AppColors.of(context);

// 使用主要颜色
color: colors.primary
color: colors.secondary
color: colors.error

// 使用容器颜色
color: colors.primaryContainer
color: colors.secondaryContainer
color: colors.errorContainer

// 使用表面颜色
color: colors.surface
color: colors.surfaceContainer
```

### 3. 透明度使用

```dart
// 使用透明度变体
color: colors.primaryWithAlpha(0.1)
color: colors.primaryWithAlpha(0.2)
color: colors.primaryWithAlpha(0.3)

// 使用预定义透明度值
color: colors.primaryWithAlpha(ThemeColors.alpha10)
color: colors.primaryWithAlpha(ThemeColors.alpha20)
color: colors.primaryWithAlpha(ThemeColors.alpha30)
```

### 4. 渐变使用

```dart
// 使用预定义渐变
colors: colors.primaryGradient
colors: colors.errorGradient
colors: colors.surfaceGradient
colors: colors.backgroundGradient
```

### 5. 文本颜色使用

```dart
// 主要文本颜色
color: colors.onSurface

// 次要文本颜色
color: colors.onSurfaceVariant

// 带透明度的文本颜色
color: colors.onSurfaceWithAlpha(0.6)
color: colors.onSurfaceWithAlpha(0.7)
```

## 迁移指南

### 从旧代码迁移

1. **替换硬编码颜色**：
   ```dart
   // 旧代码
   color: Colors.red
   
   // 新代码
   color: AppColors.of(context).error
   ```

2. **替换透明度**：
   ```dart
   // 旧代码
   color: Colors.red.withValues(alpha: 0.1)
   
   // 新代码
   color: AppColors.of(context).errorWithAlpha(0.1)
   ```

3. **替换渐变**：
   ```dart
   // 旧代码
   colors: [Colors.red, Colors.blue]
   
   // 新代码
   colors: AppColors.of(context).primaryGradient
   ```

4. **替换主题颜色**：
   ```dart
   // 旧代码
   color: Theme.of(context).colorScheme.primary
   
   // 新代码
   color: AppColors.of(context).primary
   ```

## 最佳实践

### 1. 优先使用主题颜色
- 避免硬编码颜色值
- 使用 `AppColors.of(context)` 获取主题颜色
- 确保支持亮色/暗色主题切换

### 2. 使用透明度变体
- 使用 `withAlpha()` 方法创建透明度变体
- 使用预定义的透明度常量
- 保持透明度使用的一致性

### 3. 使用预定义渐变
- 使用 `primaryGradient`、`errorGradient` 等预定义渐变
- 避免手动创建渐变数组
- 确保渐变效果的一致性

### 4. 文本颜色规范
- 主要文本使用 `onSurface`
- 次要文本使用 `onSurfaceVariant`
- 描述文本使用带透明度的 `onSurface`

### 5. 容器颜色规范
- 主要容器使用 `primaryContainer`
- 次要容器使用 `secondaryContainer`
- 错误容器使用 `errorContainer`

## 主题配置

### 种子颜色
应用使用粉色 (#E91E63) 作为种子颜色，这会自动生成一套协调的颜色方案。

### 自定义主题
如需自定义主题，可以修改 `AppTheme` 类中的 `lightTheme` 和 `darkTheme` 方法：

```dart
static ThemeData get lightTheme {
  return ThemeData.light(useMaterial3: true).copyWith(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFYOUR_COLOR), // 修改种子颜色
      brightness: Brightness.light,
    ),
  );
}
```

## 示例代码

查看 `color_usage_examples.dart` 文件获取完整的使用示例，包括：
- 基础颜色使用
- 主题颜色使用
- 容器颜色使用
- 透明度使用
- 渐变使用
- 文本颜色使用
- 功能颜色使用
- 卡片样式

## 注意事项

1. **性能考虑**：`AppColors.of(context)` 每次调用都会创建新的 `ThemeColors` 实例，在频繁调用的地方建议缓存结果。

2. **空安全**：所有颜色方法都返回非空值，无需额外的空值检查。

3. **主题切换**：颜色会自动响应主题切换，无需手动处理。

4. **向后兼容**：新的颜色系统与现有的 `Theme.of(context).colorScheme` 完全兼容。

## 贡献指南

如需添加新的颜色或修改现有颜色：

1. 在 `AppColors` 类中添加新的颜色常量
2. 在 `ThemeColors` 类中添加相应的访问方法
3. 更新 `color_summary.md` 文档
4. 在 `color_usage_examples.dart` 中添加使用示例
5. 更新本 README 文件 