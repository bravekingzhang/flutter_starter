import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'core/config/app_config.dart';
import 'core/log/app_logger.dart';
import 'core/network/network_manager.dart';
import 'core/storage/storage_manager.dart';

/// 框架启动入口
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 设置屏幕方向
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  
  // 初始化日志系统
  AppLogger.init();
  AppLogger.info('🚀 应用启动中...');
  
  try {
    // 初始化应用配置
    await AppConfig.init();
    AppLogger.info('✅ 应用配置初始化完成');
    
    // 初始化本地存储
    await Hive.initFlutter();
    await StorageManager.init();
    AppLogger.info('✅ 本地存储初始化完成');
    
    // 初始化网络管理器
    NetworkManager.init();
    AppLogger.info('✅ 网络管理器初始化完成');
    
    AppLogger.info('🎉 框架初始化完成，启动应用');
    
    runApp(
      ProviderScope(
        child: ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) => const App(),
        ),
      ),
    );
  } catch (e, stackTrace) {
    AppLogger.error('❌ 应用启动失败', error: e, stackTrace: stackTrace);
    rethrow;
  }
}