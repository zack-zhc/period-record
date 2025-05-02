import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_1/utils/auth_util.dart';
import 'package:test_1/pages/main_app.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  late SharedPreferences _prefs;
  bool? _biometricEnabled;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _biometricEnabled = _prefs.getBool('biometric_enabled') ?? true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_biometricEnabled == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // 如果生物识别未启用，直接进入主应用
    if (_biometricEnabled == false) {
      return const MainApp();
    }

    return FutureBuilder<bool>(
      future: AuthUtil.checkBiometricsSupport(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 如果设备不支持或未设置指纹，直接进入主应用
        if (snapshot.data == false) {
          return const MainApp();
        }

        // 设备支持指纹，进行认证
        return FutureBuilder<bool>(
          future: AuthUtil.authenticate(),
          builder: (context, authSnapshot) {
            if (authSnapshot.data == true) {
              return const MainApp();
            }
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('请点击进行验证'),
                    ElevatedButton(
                      onPressed:
                          () => Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const AuthWrapper(),
                            ),
                          ),
                      child: const Text('验证'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
