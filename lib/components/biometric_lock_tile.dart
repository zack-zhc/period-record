// 文件名改为 biometric_lock_tile.dart
import 'package:flutter/material.dart';
import 'package:period_record/theme/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:period_record/utils/auth_util.dart';

// 类名改为 BiometricLockTile
class BiometricLockTile extends StatefulWidget {
  final bool forceShow;
  const BiometricLockTile({super.key, this.forceShow = false});

  @override
  State<BiometricLockTile> createState() => _BiometricLockTileState();
}

class _BiometricLockTileState extends State<BiometricLockTile>
    with SingleTickerProviderStateMixin {
  bool? _biometricEnabled;
  late SharedPreferences _prefs;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  Future<void> _loadPreferences() async {
    if (!widget.forceShow && !await AuthUtil.checkBiometricsSupport()) {
      return;
    }
    _prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _biometricEnabled = _prefs.getBool('biometric_enabled') ?? true;
      });
    }
  }

  Future<void> _toggleBiometric(bool value) async {
    _animationController.forward().then((_) => _animationController.reverse());
    setState(() {
      _biometricEnabled = value;
    });
    await _prefs.setBool('biometric_enabled', value);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_biometricEnabled == null) {
      // 如果强制显示，则显示默认UI
      if (widget.forceShow) {
        return ScaleTransition(
          scale: _scaleAnimation,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.of(context).secondaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.fingerprint,
                color: AppColors.of(context).secondary,
                size: 20,
              ),
            ),
            title: const Text('使用生物识别解锁'),
            subtitle: const Text('保护您的数据安全'),
            trailing: Switch.adaptive(
              value: false,
              onChanged: null,
              activeColor: AppColors.of(context).secondary,
            ),
          ),
        );
      }
      return const SizedBox.shrink();
    }

    return ScaleTransition(
      scale: _scaleAnimation,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.of(context).secondaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.fingerprint,
            color: AppColors.of(context).secondary,
            size: 20,
          ),
        ),
        title: const Text('使用生物识别解锁'),
        subtitle: const Text('保护您的数据安全'),
        trailing: Switch.adaptive(
          value: _biometricEnabled!,
          onChanged: _toggleBiometric,
          activeColor: AppColors.of(context).secondary,
        ),
      ),
    );
  }
}
