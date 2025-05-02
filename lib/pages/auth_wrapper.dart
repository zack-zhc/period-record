import 'package:flutter/material.dart';
import 'package:test_1/utils/auth_util.dart';
import 'package:test_1/pages/main_app.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
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
