import 'package:flutter/material.dart';
import 'package:period_record/theme/app_colors.dart';
export 'period_in_progress_widget.dart';
export 'period_started_today_widget.dart';
export 'period_ended_widget.dart';
export 'default_period_status_widget.dart';
export 'days_display_widget.dart';

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
}

/// 无记录状态组件 - 乔布斯式优雅设计
class NoPeriodWidget extends StatefulWidget {
  const NoPeriodWidget({super.key});

  @override
  State<NoPeriodWidget> createState() => _NoPeriodWidgetState();
}

class _NoPeriodWidgetState extends State<NoPeriodWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _iconPulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeInOutCubic),
      ),
    );

    _slideAnimation = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutQuart),
      ),
    );

    _iconPulseAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.1), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 1.1, end: 1.0), weight: 1),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;
    final isSmallScreen = MediaQuery.of(context).size.width < 360;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: Container(
                margin: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.sm,
                  AppSpacing.md,
                  AppSpacing.lg,
                ),
                decoration: BoxDecoration(
                  color: isDark ? colors.surfaceContainer : colors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.xl),
                  border: Border.all(
                    color: colors.outline.withValues(alpha: 0.06),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colors.onSurface.withValues(
                        alpha: isDark ? 0.08 : 0.03,
                      ),
                      blurRadius: 12,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(
                    isSmallScreen ? AppSpacing.lg : AppSpacing.xl,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Transform.scale(
                        scale: _iconPulseAnimation.value,
                        child: _ExpressiveIcon(
                          colors: colors,
                          isSmallScreen: isSmallScreen,
                        ),
                      ),
                      SizedBox(
                        height: isSmallScreen ? AppSpacing.lg : AppSpacing.xl,
                      ),
                      Text(
                        '用心记录，温柔以待',
                        style: textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w300,
                          color: colors.onSurface,
                          letterSpacing: -0.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppSpacing.md),
                      Text(
                        '每一次记录都是对自己的温柔关怀\n让身体的变化成为了解自己的窗口',
                        style: textTheme.bodyLarge?.copyWith(
                          color: colors.onSurfaceVariant,
                          height: 1.6,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: isSmallScreen ? AppSpacing.lg : AppSpacing.xl,
                      ),
                      _FeatureGrid(context: context, colors: colors),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ExpressiveIcon extends StatelessWidget {
  final ThemeColors colors;
  final bool isSmallScreen;

  const _ExpressiveIcon({required this.colors, required this.isSmallScreen});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isSmallScreen ? 72 : 88,
      height: isSmallScreen ? 72 : 88,
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(isSmallScreen ? 20 : 24),
      ),
      child: Icon(
        Icons.self_improvement_rounded,
        size: isSmallScreen ? 32 : 40,
        color: colors.onPrimaryContainer,
      ),
    );
  }
}

class _FeatureGrid extends StatefulWidget {
  final BuildContext context;
  final ThemeColors colors;

  const _FeatureGrid({required this.context, required this.colors});

  @override
  State<_FeatureGrid> createState() => _FeatureGridState();
}

class _FeatureGridState extends State<_FeatureGrid>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _itemAnimations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _itemAnimations = List.generate(3, (index) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            0.3 + (index * 0.15),
            0.8 + (index * 0.1),
            curve: Curves.easeOutCubic,
          ),
        ),
      );
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final features = [
      _FeatureItem(icon: Icons.calendar_today_rounded, label: '细心观察'),
      _FeatureItem(icon: Icons.insights_rounded, label: '深度理解'),
      _FeatureItem(icon: Icons.spa_rounded, label: '温柔关怀'),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
          features.asMap().entries.map((entry) {
            final index = entry.key;
            final feature = entry.value;

            return AnimatedBuilder(
              animation: _itemAnimations[index],
              builder: (context, child) {
                return Opacity(
                  opacity: _itemAnimations[index].value,
                  child: Transform.translate(
                    offset: Offset(0, (1 - _itemAnimations[index].value) * 10),
                    child: Row(
                      children: [
                        _buildFeatureItem(feature),
                        if (index < features.length - 1) _buildDivider(),
                      ],
                    ),
                  ),
                );
              },
            );
          }).toList(),
    );
  }

  Widget _buildFeatureItem(_FeatureItem feature) {
    return Column(
      children: [
        Icon(feature.icon, size: 16, color: widget.colors.primary),
        const SizedBox(height: AppSpacing.sm),
        Text(
          feature.label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: widget.colors.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      width: 4,
      height: 4,
      decoration: BoxDecoration(
        color: widget.colors.outline.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _FeatureItem {
  final IconData icon;
  final String label;

  const _FeatureItem({required this.icon, required this.label});
}

// `PeriodStartedTodayWidget` 已抽离到
// `lib/components/period_started_today_widget.dart`
