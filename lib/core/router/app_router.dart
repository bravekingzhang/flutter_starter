import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/login/view/login_page.dart';
import '../../features/home/view/home_page.dart';
import '../../features/splash/view/splash_page.dart';
import '../storage/storage_manager.dart';

/// 路由提供者
final appRouterProvider = Provider<GoRouter>((ref) {
  return AppRouter.router;
});

/// 应用路由管理
class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  
  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      // 启动页
      GoRoute(
        path: splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      
      // 登录页
      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      
      // 主页
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
    ],
    
    // 路由重定向逻辑
    redirect: (context, state) async {
      final isLoggedIn = await StorageManager.isLoggedIn();
      final currentPath = state.uri.path;
      
      // 如果在启动页，根据登录状态跳转
      if (currentPath == splash) {
        return isLoggedIn ? home : login;
      }
      
      // 如果未登录且不在登录页，跳转到登录页
      if (!isLoggedIn && currentPath != login) {
        return login;
      }
      
      // 如果已登录且在登录页，跳转到主页
      if (isLoggedIn && currentPath == login) {
        return home;
      }
      
      return null; // 不需要重定向
    },
    
    // 错误页面
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('页面不存在: ${state.uri.path}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(home),
              child: const Text('返回首页'),
            ),
          ],
        ),
      ),
    ),
  );
}

/// 路由导航工具类
class AppNavigator {
  static GoRouter get _router => AppRouter.router;
  
  /// 跳转到指定路由
  static void push(String path, {Object? extra}) {
    _router.push(path, extra: extra);
  }
  
  /// 替换当前路由
  static void go(String path, {Object? extra}) {
    _router.go(path, extra: extra);
  }
  
  /// 返回上一页
  static void pop([Object? result]) {
    _router.pop(result);
  }
  
  /// 跳转到登录页
  static void toLogin() {
    _router.go(AppRouter.login);
  }
  
  /// 跳转到主页
  static void toHome() {
    _router.go(AppRouter.home);
  }
  
  /// 退出登录
  static Future<void> logout() async {
    await StorageManager.clearToken();
    await StorageManager.clearUserInfo();
    _router.go(AppRouter.login);
  }
}