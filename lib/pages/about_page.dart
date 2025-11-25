import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:period_record/constants/app_constants.dart';

// 加载状态视图组件
class AboutLoadingView extends StatelessWidget {
  const AboutLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: CircularProgressIndicator(
        color: colorScheme.primary,
        strokeWidth: 4,
      ),
    );
  }
}

// 错误状态视图组件
class AboutErrorView extends StatelessWidget {
  const AboutErrorView({super.key, required this.errorMessage});

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: colorScheme.onErrorContainer,
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              errorMessage,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onErrorContainer,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

// 主要内容视图组件
class AboutContentView extends StatelessWidget {
  const AboutContentView({super.key, required this.version});

  final String version;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeroCard(context),
              const SizedBox(height: 36),
              _buildFooter(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeroCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final effectiveVersion = version.isNotEmpty ? version : '未知';

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.35),
            blurRadius: 32,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -20,
            right: -10,
            child: _HeroBubble(color: colorScheme.onPrimary.withOpacity(0.08)),
          ),
          Positioned(
            bottom: -30,
            left: -20,
            child: _HeroBubble(color: colorScheme.onPrimary.withOpacity(0.05)),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(
                      color: colorScheme.onPrimary.withOpacity(0.25),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    Icons.favorite_rounded,
                    size: 44,
                    color: colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  AppConstants.appName,
                  style: textTheme.displaySmall?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  AppConstants.appDescription,
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onPrimary.withOpacity(0.9),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: colorScheme.onPrimary.withOpacity(0.25),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.tag_rounded,
                        size: 18,
                        color: colorScheme.onPrimary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '版本 $effectiveVersion',
                        style: textTheme.labelLarge?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.4)),
        color: colorScheme.surfaceContainerLow,
      ),
      child: Text(
        '感谢选择 ${AppConstants.appName}。某个静静的夜晚，作者只想有个本地小工具，悄悄记录伴侣的点滴，于是便有了它。愿这份温柔也陪伴你，守护你与自己的节奏。',
        style: textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurfaceVariant,
          height: 1.4,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _HeroBubble extends StatelessWidget {
  const _HeroBubble({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(80),
      ),
    );
  }
}

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String? _version;
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _version = packageInfo.version;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = '加载应用信息失败';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: colorScheme.surfaceTint,
        // elevation: 0,
        scrolledUnderElevation: 2,
        centerTitle: false,
        title: Text('关于应用', style: textTheme.titleLarge),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: '返回',
          color: colorScheme.onSurface,
        ),
      ),
      backgroundColor: colorScheme.surface,
      body: _buildBody(),
    );
  }

  // 使用新创建的组件重构body
  Widget _buildBody() {
    if (_isLoading) {
      return const AboutLoadingView();
    } else if (_error.isNotEmpty) {
      return AboutErrorView(errorMessage: _error);
    } else {
      return AboutContentView(version: _version ?? '');
    }
  }
}
