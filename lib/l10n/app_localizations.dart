import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// 应用国际化配置
class AppLocalizations {
  static const List<LocalizationsDelegate> localizationsDelegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = [
    Locale('zh', 'CN'), // 中文
    Locale('en', 'US'), // 英文
  ];
}