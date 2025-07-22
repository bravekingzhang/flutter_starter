import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/router/app_router.dart';
import '../../../core/storage/storage_manager.dart';

/// 启动页
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  /// 初始化应用
  Future<void> _initApp() async {
    // 延迟 2 秒显示启动页
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;
    
    // 检查登录状态并跳转
    final isLoggedIn = await StorageManager.isLoggedIn();
    if (isLoggedIn) {
      AppNavigator.toHome();
    } else {
      AppNavigator.toLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Container(
              width: 120.w,
              height: 120.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Icon(
                Icons.flash_on,
                size: 60.sp,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            
            SizedBox(height: 32.h),
            
            // 应用名称
            Text(
              'Flutter Rapid',
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            
            SizedBox(height: 8.h),
            
            // 副标题
            Text(
              '快速开发框架',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
            
            SizedBox(height: 64.h),
            
            // 加载指示器
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}