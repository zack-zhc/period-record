import 'package:flutter/material.dart';
import 'package:period_record/models/period_status_logic.dart';
import 'package:period_record/theme/app_colors.dart';

/// 生理期结束组件（参照提供的设计图，使用透明背景风格）
class PeriodEndedWidget extends StatefulWidget {
  final String title;

  const PeriodEndedWidget({super.key, required this.title});

  @override
  State<PeriodEndedWidget> createState() => _PeriodEndedWidgetState();
}

class _PeriodEndedWidgetState extends State<PeriodEndedWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: -8.0,
      end: 8.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
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
    final supportMessage = PeriodStatusLogic.supportMessage(
      PeriodStatus.endedToday,
      0,
    );
    final tips = _recoveryTips();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Container(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCelebrationIcon(),
            const SizedBox(height: 16),
            Text(
              widget.title.isNotEmpty ? widget.title : '生理期结束啦！',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: colors.onPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '恭喜你完成了本次周期，好好犒劳自己，补充能量恢复活力吧！',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colors.onPrimary.withValues(alpha: 0.85),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            _buildSupportCard(context, supportMessage, colors, isDark),
            const SizedBox(height: 20),
            _buildTipsCard(context, tips, colors, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportCard(
    BuildContext context,
    String message,
    ThemeColors colors,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: isDark ? 0.08 : 0.12),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.18)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white.withValues(alpha: 0.2),
            ),
            child: const Icon(Icons.light_mode, color: AppColors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colors.onPrimary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipsCard(
    BuildContext context,
    List<_Tip> tips,
    ThemeColors colors,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: isDark ? 0.1 : 0.14),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb, color: AppColors.white),
              const SizedBox(width: 8),
              Text(
                '恢复小贴士',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: colors.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...tips.map((tip) => _buildTipRow(context, tip)).toList(),
        ],
      ),
    );
  }

  Widget _buildTipRow(BuildContext context, _Tip tip) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tip.emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              tip.text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.white,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCelebrationIcon() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: child,
        );
      },
      child: Align(
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: const Text('🎉', style: TextStyle(fontSize: 36)),
        ),
      ),
    );
  }

  List<Color> _cardGradient(ThemeColors colors, bool isDark) {
    final base = colors.periodEndedGradient;
    return base
        .map(
          (color) =>
              Color.lerp(color, AppColors.white, isDark ? 0.12 : 0.35) ?? color,
        )
        .toList();
  }

  List<_Tip> _recoveryTips() {
    return const [
      _Tip('🍎', '补充铁质和蛋白质，多吃红肉、豆类和绿叶蔬菜。'),
      _Tip('💧', '多喝水促进新陈代谢，帮助身体排出代谢废物。'),
      _Tip('🧘‍♀️', '适度运动恢复活力，尝试瑜伽、散步等轻度运动。'),
      _Tip('😴', '保证充足睡眠，让身体完全恢复。'),
    ];
  }
}

class _Tip {
  final String emoji;
  final String text;

  const _Tip(this.emoji, this.text);
}
