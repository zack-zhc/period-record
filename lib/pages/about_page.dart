import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String _version = '未知版本';
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _version = packageInfo.version;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = '无法获取版本信息: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('关于应用')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error.isNotEmpty
              ? Center(child: Text(_error))
              : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const SizedBox(height: 20),
                  const Center(child: FlutterLogo(size: 100)),
                  const SizedBox(height: 30),
                  ListTile(
                    title: const Text('应用名称'),
                    subtitle: const Text('经期记录'),
                  ),
                  ListTile(title: const Text('版本'), subtitle: Text(_version)),
                  ListTile(
                    title: const Text('开发者'),
                    subtitle: const Text('Zack ZHC'),
                  ),
                  const SizedBox(height: 30),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      '© 2025 No Company. All rights reserved.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
    );
  }
}
