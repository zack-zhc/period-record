import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/period_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:test_1/pages/auth_wrapper.dart'; // 导入新的工具类

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => PeriodProvider())],
      child: MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: const AuthWrapper(),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('zh', 'CN'), Locale('en', 'US')],
      ),
    ),
  );
}
