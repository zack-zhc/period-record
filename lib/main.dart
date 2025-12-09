import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:period_record/period_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:period_record/pages/auth_wrapper.dart';
import 'package:period_record/theme_provider.dart';
import 'package:period_record/font_provider.dart';
import 'package:period_record/theme/app_colors.dart';
import 'package:period_record/constants/app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PeriodProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => FontProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final fontProvider = Provider.of<FontProvider>(context);

    return MaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        return MediaQuery(
          data: mediaQuery.copyWith(textScaleFactor: fontProvider.fontScale),
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const AuthWrapper(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('zh', 'CN'), Locale('en', 'US')],
    );
  }
}
