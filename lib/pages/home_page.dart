// 首先创建一个新的主页组件
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:period_record/models/period_status_logic.dart';
import 'package:period_record/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:period_record/period_provider.dart';
import 'package:period_record/components/home_app_bar.dart';
import 'package:period_record/components/period_action_button.dart';
import 'package:period_record/components/period_status_content.dart';

/// 主页面
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PeriodProvider>(
      builder: (context, periodProvider, child) {
        final statusInfo = PeriodStatusLogic.calculateStatus(
          periodProvider.lastPeriod,
        );

        final isNoPeriod = statusInfo.status == PeriodStatus.noPeriod;
        final isStartedToday = statusInfo.status == PeriodStatus.startedToday;
        final isEndedToday = statusInfo.status == PeriodStatus.endedToday;
        final isEnded = statusInfo.status == PeriodStatus.ended;
        final isInProgress = statusInfo.status == PeriodStatus.inProgress;

        return Scaffold(
          extendBody: true,
          // extendBodyBehindAppBar: true,
          appBar: const HomeAppBar(),
          body: AnimatedContainer(
            width: double.infinity,
            height: double.infinity,
            duration: const Duration(milliseconds: 450),
            curve: Curves.easeOutCubic,
            decoration: _buildBackgroundDecoration(context, statusInfo.status),
            child: Stack(
              children: [
                if (isNoPeriod)
                  ..._buildNoPeriodAmbientLayers(context)
                else if (isStartedToday)
                  ..._buildStartedTodayAmbientLayers(context)
                else if (isInProgress)
                  ..._buildInProgressAmbientLayers(context)
                else if (isEndedToday)
                  ..._buildEndedTodayAmbientLayers(context)
                else if (isEnded)
                  ..._buildEndedAmbientLayers(context),
                Center(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    child: PeriodStatusContent(
                      lastPeriod: periodProvider.lastPeriod,
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: PeriodActionButton(
            periodProvider: periodProvider,
          ),
        );
      },
    );
  }

  BoxDecoration _buildBackgroundDecoration(
    BuildContext context,
    PeriodStatus status,
  ) {
    final colors = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (status == PeriodStatus.noPeriod) {
      final gradientColors =
          isDark
              ? [colors.surface, colors.surface]
              : [colors.surfaceContainer, colors.surfaceContainer];
      return BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      );
    }

    if (status == PeriodStatus.startedToday) {
      final blended = _blendGradient(
        colors.periodStartedGradient,
        isDark,
        lightBlend: 0.18,
        darkBlend: 0.08,
      );
      return BoxDecoration(
        gradient: LinearGradient(
          colors: blended,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      );
    }

    if (status == PeriodStatus.endedToday) {
      final blended = _blendGradient(
        colors.periodEndedGradient,
        isDark,
        lightBlend: 0.16,
        darkBlend: 0.08,
      );
      return BoxDecoration(
        gradient: LinearGradient(
          colors: blended,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      );
    }

    if (status == PeriodStatus.inProgress) {
      final blended = _blendGradient(
        colors.periodInProgressGradient,
        isDark,
        lightBlend: 0.22,
        darkBlend: 0.12,
      );
      return BoxDecoration(
        gradient: LinearGradient(
          colors: blended,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      );
    }

    if (status == PeriodStatus.ended) {
      // 使用 Tertiary 颜色作为基调，代表恢复与平衡
      // 直接使用较深的颜色，确保 DefaultPeriodStatusWidget 的白色文字清晰可见
      return BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.tertiary, colors.tertiary.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      );
    }

    return BoxDecoration(color: colors.surface);
  }

  List<Widget> _buildInProgressAmbientLayers(BuildContext context) {
    final colors = AppColors.of(context);
    final accent = colors.periodInProgressGradient.first;
    final secondary = colors.periodInProgressGradient.last;
    return [
      Positioned.fill(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.white.withValues(alpha: 0.04),
                AppColors.transparent,
              ],
              stops: const [0.0, 0.65],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      _buildAmbientCircle(
        size: 340,
        top: -160,
        right: -120,
        colors: colors,
        opacity: 0.45,
        baseColor: accent,
      ),
      _buildAmbientCircle(
        size: 240,
        bottom: -40,
        left: -70,
        colors: colors,
        opacity: 0.35,
        baseColor: secondary,
      ),
      Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(right: 24, top: 40, bottom: 120),
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: AppColors.white.withValues(alpha: 0.18),
              width: 1.2,
            ),
            gradient: LinearGradient(
              colors: [
                AppColors.white.withValues(alpha: 0.18),
                AppColors.transparent,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildNoPeriodAmbientLayers(BuildContext context) {
    final colors = AppColors.of(context);
    return [
      _buildAmbientCircle(
        size: 260,
        top: -80,
        right: -30,
        colors: colors,
        opacity: 0.35,
      ),
      _buildAmbientCircle(
        size: 180,
        bottom: 40,
        left: -20,
        colors: colors,
        opacity: 0.25,
      ),
      Align(
        alignment: Alignment.bottomRight,
        child: Container(
          margin: const EdgeInsets.only(bottom: 120, right: 24),
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.primaryWithAlpha(0.07),
            border: Border.all(color: colors.primaryWithAlpha(0.12)),
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildEndedAmbientLayers(BuildContext context) {
    final colors = AppColors.of(context);
    return [
      Positioned.fill(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.white.withValues(alpha: 0.08),
                AppColors.transparent,
              ],
              stops: const [0.0, 0.85],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      _buildAmbientCircle(
        size: 320,
        top: -110,
        right: -80,
        colors: colors,
        opacity: 0.25,
        baseColor: AppColors.white,
      ),
      _buildAmbientCircle(
        size: 220,
        bottom: -60,
        left: -60,
        colors: colors,
        opacity: 0.22,
        baseColor: colors.defaultStatusGradient.last,
      ),
      Align(
        alignment: Alignment.center,
        child: Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppColors.white.withValues(alpha: 0.12),
                AppColors.transparent,
              ],
            ),
            border: Border.all(
              color: AppColors.white.withValues(alpha: 0.12),
              width: 1.2,
            ),
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildEndedTodayAmbientLayers(BuildContext context) {
    final colors = AppColors.of(context);
    final accent = colors.periodEndedGradient.first;
    return [
      Positioned.fill(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.white.withValues(alpha: 0.05),
                AppColors.transparent,
              ],
              stops: const [0.0, 0.7],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      _buildAmbientCircle(
        size: 300,
        top: -120,
        left: -80,
        colors: colors,
        opacity: 0.35,
        baseColor: accent,
      ),
      _buildAmbientCircle(
        size: 220,
        bottom: -40,
        right: -60,
        colors: colors,
        opacity: 0.3,
        baseColor: colors.secondary,
      ),
      Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          margin: const EdgeInsets.only(bottom: 110, left: 18),
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppColors.white.withValues(alpha: 0.12),
                AppColors.transparent,
              ],
            ),
            border: Border.all(color: AppColors.white.withValues(alpha: 0.1)),
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildStartedTodayAmbientLayers(BuildContext context) {
    return [const StartedTodayAnimatedBackground()];
  }

  List<Color> _blendGradient(
    List<Color> colors,
    bool isDark, {
    required double lightBlend,
    required double darkBlend,
  }) {
    return colors
        .map(
          (color) =>
              Color.lerp(
                color,
                AppColors.white,
                isDark ? darkBlend : lightBlend,
              ) ??
              color,
        )
        .toList();
  }

  Widget _buildAmbientCircle({
    required double size,
    double? top,
    double? left,
    double? right,
    double? bottom,
    double opacity = 0.3,
    required ThemeColors colors,
    Color? baseColor,
  }) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              (baseColor ?? colors.primary).withValues(alpha: opacity),
              AppColors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}

/// 动态移动的背景组件（用于生理期第一天）
class StartedTodayAnimatedBackground extends StatefulWidget {
  const StartedTodayAnimatedBackground({super.key});

  @override
  State<StartedTodayAnimatedBackground> createState() =>
      _StartedTodayAnimatedBackgroundState();
}

class _StartedTodayAnimatedBackgroundState
    extends State<StartedTodayAnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 使用鲜艳的红色
    const warmBase = Color(0xFFFF5252);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        Alignment begin;

        // 顺时针移动：TopRight -> BottomRight -> BottomLeft -> TopLeft -> TopRight
        if (t < 0.25) {
          // TopRight -> BottomRight
          begin =
              Alignment.lerp(Alignment.topRight, Alignment.bottomRight, t * 4)!;
        } else if (t < 0.5) {
          // BottomRight -> BottomLeft
          begin =
              Alignment.lerp(
                Alignment.bottomRight,
                Alignment.bottomLeft,
                (t - 0.25) * 4,
              )!;
        } else if (t < 0.75) {
          // BottomLeft -> TopLeft
          begin =
              Alignment.lerp(
                Alignment.bottomLeft,
                Alignment.topLeft,
                (t - 0.5) * 4,
              )!;
        } else {
          // TopLeft -> TopRight
          begin =
              Alignment.lerp(
                Alignment.topLeft,
                Alignment.topRight,
                (t - 0.75) * 4,
              )!;
        }

        // end 始终在 begin 的对角方向
        final end = Alignment(-begin.x, -begin.y);

        return Stack(
          children: [
            // 动态渐变背景
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      warmBase.withValues(alpha: 0.5), // 红色部分
                      AppColors.white.withValues(alpha: 0.1), // 白色部分
                    ],
                    begin: begin,
                    end: end,
                  ),
                ),
              ),
            ),
            // 底部暗色渐变遮罩（保证文字可读性）
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 200,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.transparent,
                      AppColors.black.withValues(alpha: 0.3),
                    ],
                    stops: const [0.0, 1.0],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
