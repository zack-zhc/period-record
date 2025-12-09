import 'package:flutter/material.dart';
import 'package:period_record/models/period_status_logic.dart';
import 'package:period_record/theme/app_colors.dart';

/// 生理期结束组件
/// 采用 Material 3 Expressive 设计风格
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
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: -5.0, end: 5.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final supportMessage = PeriodStatusLogic.supportMessage(
      PeriodStatus.endedToday,
      0,
    );
    final tips = _recoveryTips();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context),
          const SizedBox(height: 32),
          _buildSupportCard(context, supportMessage, isDark),
          const SizedBox(height: 32),
          _buildTipsSection(context, tips),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        _buildCelebrationIcon(),
        const SizedBox(height: 24),
        Text(
          widget.title.isNotEmpty ? widget.title : '生理期结束啦！',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.white,
            letterSpacing: -0.5,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '恭喜你完成了本次周期，好好犒劳自己，补充能量恢复活力吧！',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.white.withValues(alpha: 0.9),
            height: 1.5,
          ),
        ),
      ],
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
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.2),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.white.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: const Center(child: Text('🎉', style: TextStyle(fontSize: 32))),
      ),
    );
  }

  Widget _buildSupportCard(BuildContext context, String message, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: isDark ? 0.1 : 0.15),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.light_mode_rounded,
            color: AppColors.white,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.white,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipsSection(BuildContext context, List<_Tip> tips) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 16),
          child: Text(
            '恢复小贴士',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.white.withValues(alpha: 0.9),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ),
        ),
        ...tips.map((tip) => _buildTipTile(context, tip)),
      ],
    );
  }

  Widget _buildTipTile(BuildContext context, _Tip tip) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Text(tip.emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              tip.text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.white,
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
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
