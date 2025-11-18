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

  // ==================== 统计卡片专用颜色 ====================

  /// 统计卡片绿色背景
  static const Color statsGreen = Color(0xFF81C784);
  static const Color onStatsGreen = Color(0xFF1B5E20);
  // Dark mode variant
  static const Color statsGreenDark = Color(0xFF2E7D32);
  static const Color onStatsGreenDark = Color(0xFFFFFFFF);

  /// 统计卡片红色背景
  static const Color statsRed = Color(0xFFEF5350);
  static const Color onStatsRed = Color(0xFFFFFFFF);
  // Dark mode variant
  static const Color statsRedDark = Color(0xFFD32F2F);
  static const Color onStatsRedDark = Color(0xFFFFFFFF);

  /// 统计卡片黄色背景
  static const Color statsYellow = Color(0xFFFFB74D);
  static const Color onStatsYellow = Color(0xFF4E342E);
  // Dark mode variant
  static const Color statsYellowDark = Color(0xFFF9A825);
  static const Color onStatsYellowDark = Color(0xFF212121);

  /// 统计卡片蓝色背景
  static const Color statsBlue = Color(0xFF64B5F6);
  static const Color onStatsBlue = Color(0xFFFFFFFF);
  // Dark mode variant
  static const Color statsBlueDark = Color(0xFF1976D2);
  static const Color onStatsBlueDark = Color(0xFFFFFFFF);

  /// 获取基于当前主题的统计卡片颜色（亮/暗模式自动切换）
  static Color statsGreenFor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? statsGreenDark
          : statsGreen;
  static Color onStatsGreenFor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? onStatsGreenDark
          : onStatsGreen;

  static Color statsRedFor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? statsRedDark : statsRed;
  static Color onStatsRedFor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? onStatsRedDark
          : onStatsRed;

  static Color statsYellowFor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? statsYellowDark
          : statsYellow;
  static Color onStatsYellowFor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? onStatsYellowDark
          : onStatsYellow;

  static Color statsBlueFor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? statsBlueDark
          : statsBlue;
  static Color onStatsBlueFor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? onStatsBlueDark
          : onStatsBlue;

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
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFFE91E63),
      brightness: Brightness.light,
    );

    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      brightness: Brightness.light,
      extensions: <ThemeExtension<dynamic>>[
        StatsColors(
          statsGreen: AppColors.statsGreen,
          onStatsGreen: AppColors.onStatsGreen,
          statsRed: AppColors.statsRed,
          onStatsRed: AppColors.onStatsRed,
          statsYellow: AppColors.statsYellow,
          onStatsYellow: AppColors.onStatsYellow,
          statsBlue: AppColors.statsBlue,
          onStatsBlue: AppColors.onStatsBlue,
        ),
      ],
    );
  }

  /// 暗色主题
  static ThemeData get darkTheme {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFFE91E63),
      brightness: Brightness.dark,
    );

    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      brightness: Brightness.dark,
      extensions: <ThemeExtension<dynamic>>[
        StatsColors(
          statsGreen: AppColors.statsGreenDark,
          onStatsGreen: AppColors.onStatsGreenDark,
          statsRed: AppColors.statsRedDark,
          onStatsRed: AppColors.onStatsRedDark,
          statsYellow: AppColors.statsYellowDark,
          onStatsYellow: AppColors.onStatsYellowDark,
          statsBlue: AppColors.statsBlueDark,
          onStatsBlue: AppColors.onStatsBlueDark,
        ),
      ],
    );
  }
}

/// ThemeExtension 用于在 ThemeData 中扩展自定义颜色
@immutable
class StatsColors extends ThemeExtension<StatsColors> {
  final Color statsGreen;
  final Color onStatsGreen;

  final Color statsRed;
  final Color onStatsRed;

  final Color statsYellow;
  final Color onStatsYellow;

  final Color statsBlue;
  final Color onStatsBlue;

  const StatsColors({
    required this.statsGreen,
    required this.onStatsGreen,
    required this.statsRed,
    required this.onStatsRed,
    required this.statsYellow,
    required this.onStatsYellow,
    required this.statsBlue,
    required this.onStatsBlue,
  });

  @override
  StatsColors copyWith({
    Color? statsGreen,
    Color? onStatsGreen,
    Color? statsRed,
    Color? onStatsRed,
    Color? statsYellow,
    Color? onStatsYellow,
    Color? statsBlue,
    Color? onStatsBlue,
  }) {
    return StatsColors(
      statsGreen: statsGreen ?? this.statsGreen,
      onStatsGreen: onStatsGreen ?? this.onStatsGreen,
      statsRed: statsRed ?? this.statsRed,
      onStatsRed: onStatsRed ?? this.onStatsRed,
      statsYellow: statsYellow ?? this.statsYellow,
      onStatsYellow: onStatsYellow ?? this.onStatsYellow,
      statsBlue: statsBlue ?? this.statsBlue,
      onStatsBlue: onStatsBlue ?? this.onStatsBlue,
    );
  }

  @override
  StatsColors lerp(ThemeExtension<StatsColors>? other, double t) {
    if (other is! StatsColors) return this;
    return StatsColors(
      statsGreen: Color.lerp(statsGreen, other.statsGreen, t) ?? statsGreen,
      onStatsGreen:
          Color.lerp(onStatsGreen, other.onStatsGreen, t) ?? onStatsGreen,
      statsRed: Color.lerp(statsRed, other.statsRed, t) ?? statsRed,
      onStatsRed: Color.lerp(onStatsRed, other.onStatsRed, t) ?? onStatsRed,
      statsYellow: Color.lerp(statsYellow, other.statsYellow, t) ?? statsYellow,
      onStatsYellow:
          Color.lerp(onStatsYellow, other.onStatsYellow, t) ?? onStatsYellow,
      statsBlue: Color.lerp(statsBlue, other.statsBlue, t) ?? statsBlue,
      onStatsBlue: Color.lerp(onStatsBlue, other.onStatsBlue, t) ?? onStatsBlue,
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