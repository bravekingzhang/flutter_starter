import 'package:flutter/foundation.dart';

/// 应用配置管理
class AppConfig {
  static late AppConfig _instance;
  static AppConfig get instance => _instance;
  
  // 环境配置
  final String environment;
  final String baseUrl;
  final bool enableLog;
  final bool enableCrashReport;
  final int connectTimeout;
  final int receiveTimeout;
  
  AppConfig._({
    required this.environment,
    required this.baseUrl,
    required this.enableLog,
    required this.enableCrashReport,
    required this.connectTimeout,
    required this.receiveTimeout,
  });
  
  /// 初始化配置
  static Future<void> init() async {
    _instance = AppConfig._(
      environment: kDebugMode ? 'dev' : 'prod',
      baseUrl: kDebugMode 
        ? 'https://dev-api.roboshineapp.com/'
        : 'https://api.roboshineapp.com/',
      enableLog: kDebugMode,
      enableCrashReport: !kDebugMode,
      connectTimeout: 15000,
      receiveTimeout: 15000,
    );
  }
  
  /// 是否为开发环境
  bool get isDev => environment == 'dev';
  
  /// 是否为生产环境
  bool get isProd => environment == 'prod';
}