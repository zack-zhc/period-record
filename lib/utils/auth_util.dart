import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';

class AuthUtil {
  static final LocalAuthentication _auth = LocalAuthentication();

  // 执行指纹验证
  static Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason: '请验证指纹以访问应用',
        authMessages: [
          AndroidAuthMessages(
            signInTitle: '解锁应用',
            biometricHint: '请使用指纹解锁',
            cancelButton: '取消',
            goToSettingsButton: '设置',
            goToSettingsDescription: '请在设置中启用指纹',
            biometricNotRecognized: '指纹未识别',
            biometricSuccess: '指纹验证成功',
            biometricRequiredTitle: '需要指纹验证',
          ),
        ],
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
          sensitiveTransaction: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }

  static Future<bool> checkBiometricsSupport() async {
    try {
      // 检查设备是否支持生物识别
      final isSupported = await _auth.isDeviceSupported();
      // 检查是否有已注册的生物识别信息
      final hasBiometrics =
          await _auth.canCheckBiometrics &&
          (await _auth.getAvailableBiometrics()).isNotEmpty;
      return isSupported && hasBiometrics;
    } catch (e) {
      return false;
    }
  }
}
