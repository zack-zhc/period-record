import 'package:flutter/material.dart';

/// 主题颜色扩展类
/// 提供主题相关的颜色访问方法
class ThemeColors {
  final ColorScheme colorScheme;

  ThemeColors(this.colorScheme);

  // 主要颜色
  Color get primary => colorScheme.primary;
  Color get secondary => colorScheme.secondary;
  Color get tertiary => colorScheme.tertiary;
  Color get error => colorScheme.error;

  // 容器颜色
  Color get primaryContainer => colorScheme.primaryContainer;
  Color get secondaryContainer => colorScheme.secondaryContainer;
  Color get tertiaryContainer => colorScheme.tertiaryContainer;
  Color get errorContainer => colorScheme.errorContainer;

  // 表面颜色
  Color get surface => colorScheme.surface;
  Color get surfaceContainer => colorScheme.surfaceContainer;
  Color get surfaceContainerHighest => colorScheme.surfaceContainerHighest;

  // 文本颜色
  Color get onSurface => colorScheme.onSurface;
  Color get onSurfaceVariant => colorScheme.onSurfaceVariant;
  Color get onPrimary => colorScheme.onPrimary;
  Color get onSecondary => colorScheme.onSecondary;
  Color get onTertiary => colorScheme.onTertiary;
  Color get onError => colorScheme.onError;
  Color get onPrimaryContainer => colorScheme.onPrimaryContainer;
  Color get onSecondaryContainer => colorScheme.onSecondaryContainer;
  Color get onTertiaryContainer => colorScheme.onTertiaryContainer;
  Color get onErrorContainer => colorScheme.onErrorContainer;

  // 轮廓颜色
  Color get outline => colorScheme.outline;

  // ==================== 透明度变体 ====================

  /// 主要颜色的透明度变体
  Color primaryWithAlpha(double alpha) => primary.withValues(alpha: alpha);
  Color secondaryWithAlpha(double alpha) => secondary.withValues(alpha: alpha);
  Color tertiaryWithAlpha(double alpha) => tertiary.withValues(alpha: alpha);
  Color errorWithAlpha(double alpha) => error.withValues(alpha: alpha);

  /// 表面颜色的透明度变体
  Color surfaceWithAlpha(double alpha) => surface.withValues(alpha: alpha);
  Color surfaceContainerWithAlpha(double alpha) =>
      surfaceContainer.withValues(alpha: alpha);

  /// 文本颜色的透明度变体
  Color onSurfaceWithAlpha(double alpha) => onSurface.withValues(alpha: alpha);
  Color onSurfaceVariantWithAlpha(double alpha) =>
      onSurfaceVariant.withValues(alpha: alpha);

  /// 轮廓颜色的透明度变体
  Color outlineWithAlpha(double alpha) => outline.withValues(alpha: alpha);

  // ==================== 常用透明度值 ====================

  /// 常用透明度值
  static const double alpha10 = 0.1;
  static const double alpha20 = 0.2;
  static const double alpha30 = 0.3;
  static const double alpha50 = 0.5;
  static const double alpha60 = 0.6;
  static const double alpha70 = 0.7;
  static const double alpha80 = 0.8;

  // ==================== 预定义颜色组合 ====================

  /// 渐变颜色组合
  List<Color> get primaryGradient => [primary, secondary];
  List<Color> get errorGradient => [error, errorWithAlpha(alpha80)];
  List<Color> get surfaceGradient => [surface, surfaceContainer];
  List<Color> get primaryContainerGradient => [
    primaryContainer,
    secondaryContainer,
  ];

  /// AppBar专用渐变
  List<Color> get appBarGradient {
    final isDark = colorScheme.brightness == Brightness.dark;
    if (isDark) {
      return [primaryContainer, secondaryContainer];
    } else {
      return primaryGradient;
    }
  }

  /// 状态组件专用渐变
  List<Color> get noPeriodGradient {
    final isDark = colorScheme.brightness == Brightness.dark;
    if (isDark) {
      return [primaryContainer, secondaryContainer];
    } else {
      return [primaryWithAlpha(0.1), secondaryWithAlpha(0.1)];
    }
  }

  List<Color> get periodStartedGradient {
    final isDark = colorScheme.brightness == Brightness.dark;
    if (isDark) {
      return [
        const Color(0xFFE57373), // 浅红色
        const Color(0xFFEF5350), // 红色
      ];
    } else {
      return [error, errorWithAlpha(alpha80)];
    }
  }

  List<Color> get periodInProgressGradient {
    final isDark = colorScheme.brightness == Brightness.dark;
    if (isDark) {
      return [
        const Color(0xFFF06292), // 浅粉色
        const Color(0xFFEC407A), // 粉色
      ];
    } else {
      return [error, errorWithAlpha(0.7)];
    }
  }

  List<Color> get periodEndedGradient {
    final isDark = colorScheme.brightness == Brightness.dark;
    if (isDark) {
      return [
        const Color(0xFF81C784), // 浅绿色
        const Color(0xFF66BB6A), // 绿色
      ];
    } else {
      return [primary, secondary];
    }
  }

  List<Color> get defaultStatusGradient {
    final isDark = colorScheme.brightness == Brightness.dark;
    if (isDark) {
      return [
        const Color(0xFF9575CD), // 浅紫色
        const Color(0xFF7E57C2), // 紫色
      ];
    } else {
      return [primaryWithAlpha(0.8), secondaryWithAlpha(0.8)];
    }
  }

  /// Floating Action Button专用渐变
  List<Color> get addButtonGradient {
    final isDark = colorScheme.brightness == Brightness.dark;
    if (isDark) {
      return [
        const Color(0xFFE91E63), // 粉色
        const Color(0xFFC2185B), // 深粉色
      ];
    } else {
      return [primary, secondary];
    }
  }

  List<Color> get endButtonGradient {
    final isDark = colorScheme.brightness == Brightness.dark;
    if (isDark) {
      return [
        const Color(0xFF4CAF50), // 绿色
        const Color(0xFF388E3C), // 深绿色
      ];
    } else {
      return [error, errorWithAlpha(alpha80)];
    }
  }

  /// 背景渐变
  List<Color> get backgroundGradient => [surface, surfaceWithAlpha(alpha80)];

  /// 卡片背景渐变
  List<Color> get cardBackgroundGradient => [surface, surfaceContainer];
}

/// 应用颜色主题类
/// 总结应用中使用的所有颜色，便于统一管理和维护
class AppColors {
  // 私有构造函数，防止实例化
  AppColors._();

  // ==================== 基础颜色 ====================

  /// 白色
  static const Color white = Colors.white;

  /// 透明色
  static const Color transparent = Colors.transparent;

  /// 黑色
  static const Color black = Colors.black;

  // ==================== 功能颜色 ====================

  /// 蓝色 - 用于统计图表
  static const Color blue = Colors.blue;

  /// 绿色 - 用于统计图表
  static const Color green = Colors.green;

  /// 橙色 - 用于统计图表
  static const Color orange = Colors.orange;

  /// 从BuildContext获取主题颜色
  static ThemeColors of(BuildContext context) {
    return ThemeColors(Theme.of(context).colorScheme);
  }
}

/// 应用主题数据类
/// 定义应用的主题配置
class AppTheme {
  // 私有构造函数，防止实例化
  AppTheme._();

  /// 亮色主题
  static ThemeData get lightTheme {
    return ThemeData.light(useMaterial3: true).copyWith(
      // 可以在这里自定义亮色主题的颜色
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFE91E63), // 粉色作为种子颜色
        brightness: Brightness.light,
      ),
    );
  }

  /// 暗色主题
  static ThemeData get darkTheme {
    return ThemeData.dark(useMaterial3: true).copyWith(
      // 自定义暗色主题的颜色方案
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFE91E63), // 粉色作为种子颜色
        brightness: Brightness.dark,
      ).copyWith(
        // 优化暗色主题的容器颜色，使其更适合AppBar
        primaryContainer: const Color(0xFF2D1B2E), // 深紫红色
        secondaryContainer: const Color(0xFF1F1B2E), // 深蓝紫色
        onPrimaryContainer: const Color(0xFFF8BBD9), // 浅粉色文字
        onSecondaryContainer: const Color(0xFFE1BEE7), // 浅紫色文字
      ),
    );
  }
}

/// 颜色使用指南
/// 
/// 在应用中使用颜色的最佳实践：
/// 
/// 1. 使用主题颜色而不是硬编码颜色：
///    ```dart
///    // ✅ 推荐
///    color: AppColors.of(context).primary
///    
///    // ❌ 不推荐
///    color: Colors.red
///    ```
/// 
/// 2. 使用透明度变体：
///    ```dart
///    // ✅ 推荐
///    color: AppColors.of(context).primaryWithAlpha(0.1)
///    
///    // ❌ 不推荐
///    color: Colors.red.withValues(alpha: 0.1)
///    ```
/// 
/// 3. 使用预定义渐变：
///    ```dart
///    // ✅ 推荐
///    colors: AppColors.of(context).primaryGradient
///    ```
/// 
/// 4. 使用常用透明度值：
///    ```dart
///    // ✅ 推荐
///    color: AppColors.of(context).primaryWithAlpha(ThemeColors.alpha20)
///    ```
/// 
/// 5. 文本颜色使用主题颜色：
///    ```dart
///    // ✅ 推荐
///    color: AppColors.of(context).onSurface
///    color: AppColors.of(context).onSurfaceVariant
///    ```
/// 
/// 6. 容器和表面颜色：
///    ```dart
///    // ✅ 推荐
///    color: AppColors.of(context).primaryContainer
///    color: AppColors.of(context).surface
///    ```