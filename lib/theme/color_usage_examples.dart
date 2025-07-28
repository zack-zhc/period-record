import 'package:flutter/material.dart';
import 'package:period_record/theme/app_colors.dart';

/// 颜色使用示例
/// 展示如何在应用中使用新的颜色系统
class ColorUsageExamples {
  /// 示例1: 基础颜色使用
  static Widget basicColorExample(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.of(context).surface,
      child: Column(
        children: [
          // 使用基础颜色
          Container(
            padding: const EdgeInsets.all(8),
            color: AppColors.white,
            child: const Text('白色背景'),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            color: AppColors.transparent,
            child: const Text('透明背景'),
          ),
        ],
      ),
    );
  }

  /// 示例2: 主题颜色使用
  static Widget themeColorExample(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      color: colors.surface,
      child: Column(
        children: [
          // 主要颜色
          Container(
            padding: const EdgeInsets.all(12),
            color: colors.primary,
            child: Text('主要颜色', style: TextStyle(color: colors.onPrimary)),
          ),
          const SizedBox(height: 8),

          // 次要颜色
          Container(
            padding: const EdgeInsets.all(12),
            color: colors.secondary,
            child: Text('次要颜色', style: TextStyle(color: colors.onSecondary)),
          ),
          const SizedBox(height: 8),

          // 错误颜色
          Container(
            padding: const EdgeInsets.all(12),
            color: colors.error,
            child: Text('错误颜色', style: TextStyle(color: colors.onError)),
          ),
        ],
      ),
    );
  }

  /// 示例3: 容器颜色使用
  static Widget containerColorExample(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      color: colors.surface,
      child: Column(
        children: [
          // 主要容器
          Container(
            padding: const EdgeInsets.all(12),
            color: colors.primaryContainer,
            child: Text(
              '主要容器',
              style: TextStyle(color: colors.onPrimaryContainer),
            ),
          ),
          const SizedBox(height: 8),

          // 次要容器
          Container(
            padding: const EdgeInsets.all(12),
            color: colors.secondaryContainer,
            child: Text(
              '次要容器',
              style: TextStyle(color: colors.onSecondaryContainer),
            ),
          ),
          const SizedBox(height: 8),

          // 错误容器
          Container(
            padding: const EdgeInsets.all(12),
            color: colors.errorContainer,
            child: Text(
              '错误容器',
              style: TextStyle(color: colors.onErrorContainer),
            ),
          ),
        ],
      ),
    );
  }

  /// 示例4: 透明度使用
  static Widget transparencyExample(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      color: colors.surface,
      child: Column(
        children: [
          // 不同透明度的主要颜色
          Container(
            padding: const EdgeInsets.all(12),
            color: colors.primaryWithAlpha(ThemeColors.alpha10),
            child: Text('10% 透明度'),
          ),
          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.all(12),
            color: colors.primaryWithAlpha(ThemeColors.alpha30),
            child: Text('30% 透明度'),
          ),
          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.all(12),
            color: colors.primaryWithAlpha(ThemeColors.alpha50),
            child: Text('50% 透明度'),
          ),
          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.all(12),
            color: colors.primaryWithAlpha(ThemeColors.alpha80),
            child: Text('80% 透明度'),
          ),
        ],
      ),
    );
  }

  /// 示例5: 渐变使用
  static Widget gradientExample(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      color: colors.surface,
      child: Column(
        children: [
          // 主要渐变
          Container(
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: colors.primaryGradient),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                '主要渐变',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // 错误渐变
          Container(
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: colors.errorGradient),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                '错误渐变',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // 表面渐变
          Container(
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: colors.surfaceGradient),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '表面渐变',
                style: TextStyle(
                  color: colors.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 示例6: 文本颜色使用
  static Widget textColorExample(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      color: colors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '主要文本颜色',
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          Text(
            '次要文本颜色',
            style: TextStyle(color: colors.onSurfaceVariant, fontSize: 16),
          ),
          const SizedBox(height: 8),

          Text(
            '60% 透明度的文本',
            style: TextStyle(
              color: colors.onSurfaceWithAlpha(ThemeColors.alpha60),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),

          Text(
            '70% 透明度的文本',
            style: TextStyle(
              color: colors.onSurfaceWithAlpha(ThemeColors.alpha70),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  /// 示例7: 功能颜色使用
  static Widget functionalColorExample(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.of(context).surface,
      child: Column(
        children: [
          // 统计图表颜色
          Row(
            children: [
              Container(width: 20, height: 20, color: AppColors.blue),
              const SizedBox(width: 8),
              const Text('蓝色 - 第一个数据系列'),
            ],
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              Container(width: 20, height: 20, color: AppColors.green),
              const SizedBox(width: 8),
              const Text('绿色 - 第二个数据系列'),
            ],
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              Container(width: 20, height: 20, color: AppColors.orange),
              const SizedBox(width: 8),
              const Text('橙色 - 第三个数据系列'),
            ],
          ),
        ],
      ),
    );
  }

  /// 示例8: 卡片样式
  static Widget cardStyleExample(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors.backgroundGradient),
      ),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: colors.cardBackgroundGradient),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colors.primaryWithAlpha(ThemeColors.alpha20),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.star, color: colors.primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '卡片标题',
                    style: TextStyle(
                      color: colors.onSurface,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                '这是一个使用新颜色系统的卡片示例，展示了如何正确使用主题颜色。',
                style: TextStyle(color: colors.onSurfaceVariant, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
