import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_rapid_framework/app.dart';
import 'package:flutter_rapid_framework/features/login/view_model/login_view_model.dart';
import 'package:flutter_rapid_framework/common/widgets/app_button.dart';

void main() {
  group('App Widget Tests', () {
    testWidgets('App should display correctly', (WidgetTester tester) async {
      // 创建 ProviderScope 和 ScreenUtilInit 包装的 App
      await tester.pumpWidget(
        ProviderScope(
          child: ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            builder: (context, child) => const App(),
          ),
        ),
      );

      // 验证应用能正常构建
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });

  group('LoginViewModel Tests', () {
    test('初始状态应该是未加载状态', () {
      final viewModel = LoginViewModel();
      expect(viewModel.state.isLoading, false);
      expect(viewModel.state.error, null);
    });

    testWidgets('登录成功应该清除加载状态', (WidgetTester tester) async {
      final viewModel = LoginViewModel();

      // 创建一个测试用的 Widget 来提供 BuildContext
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              // 模拟登录
              viewModel.login(
                context: context,
                username: 'admin',
                password: '123456',
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      // 等待异步操作完成
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // 验证状态
      expect(viewModel.state.isLoading, false);
      expect(viewModel.state.error, null);
    });

    testWidgets('登录失败应该设置错误信息', (WidgetTester tester) async {
      final viewModel = LoginViewModel();

      // 创建一个测试用的 Widget 来提供 BuildContext
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              // 模拟登录失败
              viewModel.login(
                context: context,
                username: 'wrong',
                password: 'wrong',
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      // 等待异步操作完成
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // 验证状态
      expect(viewModel.state.isLoading, false);
      expect(viewModel.state.error, isNotNull);
    });

    test('清除错误信息', () {
      final viewModel = LoginViewModel();

      // 手动设置错误状态
      viewModel.state = viewModel.state.copyWith(error: 'Test error');
      expect(viewModel.state.error, 'Test error');

      // 清除错误
      viewModel.clearError();
      expect(viewModel.state.error, null);
    });
  });

  group('AppButton Widget Tests', () {
    testWidgets('AppButton.primary 应该显示正确的样式', (WidgetTester tester) async {
      bool buttonPressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton.primary(
              text: '测试按钮',
              onPressed: () {
                buttonPressed = true;
              },
            ),
          ),
        ),
      );

      // 验证按钮文本
      expect(find.text('测试按钮'), findsOneWidget);
      
      // 验证按钮类型
      expect(find.byType(ElevatedButton), findsOneWidget);
      
      // 测试点击事件
      await tester.tap(find.byType(ElevatedButton));
      expect(buttonPressed, true);
    });

    testWidgets('AppButton.secondary 应该显示正确的样式', (WidgetTester tester) async {
      bool buttonPressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton.secondary(
              text: '次要按钮',
              onPressed: () {
                buttonPressed = true;
              },
            ),
          ),
        ),
      );

      // 验证按钮文本
      expect(find.text('次要按钮'), findsOneWidget);
      
      // 验证按钮类型
      expect(find.byType(OutlinedButton), findsOneWidget);
      
      // 测试点击事件
      await tester.tap(find.byType(OutlinedButton));
      expect(buttonPressed, true);
    });

    testWidgets('禁用状态的按钮不应该响应点击', (WidgetTester tester) async {
      bool buttonPressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton.primary(
              text: '禁用按钮',
              onPressed: null, // 禁用按钮
            ),
          ),
        ),
      );

      // 验证按钮存在
      expect(find.byType(ElevatedButton), findsOneWidget);
      
      // 尝试点击禁用的按钮
      await tester.tap(find.byType(ElevatedButton));
      expect(buttonPressed, false); // 应该没有响应
    });
  });

  group('Integration Tests', () {
    testWidgets('完整的应用流程测试', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            builder: (context, child) => const App(),
          ),
        ),
      );

      // 等待初始化完成
      await tester.pumpAndSettle();

      // 应用应该能正常启动
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}