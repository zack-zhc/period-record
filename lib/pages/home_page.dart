// 首先创建一个新的主页组件
import 'package:flutter/material.dart';
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

        return Scaffold(
          appBar: const HomeAppBar(),
          body: AnimatedContainer(
            duration: const Duration(milliseconds: 450),
            curve: Curves.easeOutCubic,
            decoration: _buildBackgroundDecoration(context, statusInfo.status),
            child: Stack(
              children: [
                if (isNoPeriod)
                  ..._buildNoPeriodAmbientLayers(context)
                else if (isStartedToday)
                  ..._buildStartedTodayAmbientLayers(context)
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
              ? [
                colors.surfaceContainerWithAlpha(0.85),
                colors.surface.withValues(alpha: 0.95),
              ]
              : [
                colors.noPeriodGradient.first.withValues(alpha: 0.75),
                colors.surface,
              ];
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

    if (status == PeriodStatus.ended) {
      final blended = _blendGradient(
        colors.defaultStatusGradient,
        isDark,
        lightBlend: 0.2,
        darkBlend: 0.08,
      );
      return BoxDecoration(
        gradient: LinearGradient(
          colors: blended,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      );
    }

    return BoxDecoration(color: colors.surface);
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
    final colors = AppColors.of(context);
    return [
      Positioned.fill(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.white.withValues(alpha: 0.07),
                AppColors.transparent,
              ],
              stops: const [0.0, 0.6],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      _buildAmbientCircle(
        size: 320,
        top: -140,
        right: -60,
        colors: colors,
        opacity: 0.45,
        baseColor: colors.error,
      ),
      _buildAmbientCircle(
        size: 220,
        bottom: 10,
        left: -80,
        colors: colors,
        opacity: 0.35,
        baseColor: colors.error,
      ),
      Align(
        alignment: Alignment.bottomRight,
        child: Container(
          margin: const EdgeInsets.only(bottom: 96, right: 32),
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppColors.white.withValues(alpha: 0.15),
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
