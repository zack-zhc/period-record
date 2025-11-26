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

        return Scaffold(
          appBar: const HomeAppBar(),
          body: AnimatedContainer(
            duration: const Duration(milliseconds: 450),
            curve: Curves.easeOutCubic,
            decoration: _buildBackgroundDecoration(context, statusInfo.status),
            child: Stack(
              children: [
                if (isNoPeriod) ..._buildNoPeriodAmbientLayers(context),
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

  Widget _buildAmbientCircle({
    required double size,
    double? top,
    double? left,
    double? right,
    double? bottom,
    double opacity = 0.3,
    required ThemeColors colors,
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
            colors: [colors.primaryWithAlpha(opacity), AppColors.transparent],
          ),
        ),
      ),
    );
  }
}
