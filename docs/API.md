# API 文档

Flutter Rapid Framework 提供了一套完整的 API 接口，帮助开发者快速构建 Flutter 应用。

## 核心模块

### 🌐 网络请求模块 (NetworkManager)

网络请求模块基于 Dio 封装，提供统一的网络请求接口。

#### 初始化

```dart
import 'package:flutter_rapid_framework/core/network/network_manager.dart';

// 网络管理器会在应用启动时自动初始化
```

#### 基本用法

**GET 请求**

```dart
// 简单 GET 请求
final response = await NetworkManager.get('/api/users');

// 带参数的 GET 请求
final response = await NetworkManager.get('/api/users', queryParameters: {
  'page': 1,
  'size': 20,
});
```

**POST 请求**

```dart
// POST 请求
final response = await NetworkManager.post('/api/login', data: {
  'username': 'admin',
  'password': '123456',
});

// 上传文件
final formData = FormData.fromMap({
  'file': await MultipartFile.fromFile(filePath, filename: 'upload.jpg'),
  'name': 'test',
});
final response = await NetworkManager.post('/api/upload', data: formData);
```

**PUT/DELETE 请求**

```dart
// PUT 请求
final response = await NetworkManager.put('/api/users/1', data: userData);

// DELETE 请求
final response = await NetworkManager.delete('/api/users/1');
```

#### 响应处理

```dart
try {
  final response = await NetworkManager.get('/api/data');
  
  // 检查响应状态
  if (response.statusCode == 200) {
    final data = response.data;
    // 处理成功响应
  }
} catch (e) {
  // 处理错误
  print('请求失败: $e');
}
```

### 💾 本地存储模块 (StorageManager)

本地存储模块统一了 SharedPreferences 和 Hive 的使用接口。

#### 基本用法

**Token 管理**

```dart
import 'package:flutter_rapid_framework/core/storage/storage_manager.dart';

// 保存 Token
await StorageManager.saveToken('your_access_token');

// 获取 Token
final token = await StorageManager.getToken();

// 删除 Token
await StorageManager.removeToken();

// 检查是否已登录
final isLoggedIn = await StorageManager.isLoggedIn();
```

**用户信息管理**

```dart
// 保存用户信息
await StorageManager.saveUserInfo({
  'id': 1,
  'username': 'admin',
  'nickname': '管理员',
  'email': 'admin@example.com',
});

// 获取用户信息
final userInfo = StorageManager.getUserInfo();

// 删除用户信息
await StorageManager.removeUserInfo();
```

**通用存储接口**

```dart
// 保存数据
await StorageManager.save('key', 'value');
await StorageManager.save('settings', {'theme': 'dark', 'language': 'zh'});

// 读取数据
final value = StorageManager.get('key');
final settings = StorageManager.get('settings');

// 删除数据
await StorageManager.remove('key');

// 清空所有数据
await StorageManager.clear();
```

### 🧭 路由管理模块 (AppNavigator)

路由管理模块基于 GoRouter 提供声明式路由导航。

#### 基本导航

```dart
import 'package:flutter_rapid_framework/core/router/app_router.dart';

// 跳转到登录页
AppNavigator.toLogin();

// 跳转到主页
AppNavigator.toHome();

// 退出登录（清除数据并回到登录页）
AppNavigator.logout();

// 返回上一页
AppNavigator.back();
```

#### 路由配置

项目中的路由在 `lib/core/router/app_router.dart` 中定义：

```dart
// 路由路径常量
class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const home = '/home';
}
```

### 📝 日志系统 (AppLogger)

统一的日志管理系统，支持不同级别的日志输出。

#### 基本用法

```dart
import 'package:flutter_rapid_framework/core/log/app_logger.dart';

// Debug 日志（仅在调试模式下输出）
AppLogger.debug('调试信息');

// Info 日志
AppLogger.info('普通信息');

// Warning 日志
AppLogger.warning('警告信息');

// Error 日志
AppLogger.error('错误信息', error: exception, stackTrace: stackTrace);

// Fatal 日志
AppLogger.fatal('严重错误', error: exception);
```

#### 日志配置

日志系统会在应用启动时自动初始化，配置如下：

- 调试模式：输出 Debug 级别及以上的日志
- 发布模式：仅输出 Info 级别及以上的日志
- 支持彩色输出、时间戳、方法调用栈等信息

### 🎨 主题系统 (AppTheme)

统一的主题管理，支持亮色和暗色主题。

#### 使用主题

```dart
import 'package:flutter_rapid_framework/common/themes/app_theme.dart';

// 在 MaterialApp 中应用主题
MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: ThemeMode.system, // 跟随系统主题
  // ...
)
```

#### 自定义主题色彩

```dart
// 主色调
AppTheme.primaryColor        // 主色
AppTheme.primaryColorDark    // 主色深色版本
AppTheme.primaryColorLight   // 主色浅色版本

// 辅助色
AppTheme.accentColor         // 强调色
AppTheme.backgroundColor     // 背景色
AppTheme.surfaceColor        // 表面色

// 文字颜色
AppTheme.textPrimary         // 主要文字色
AppTheme.textSecondary       // 次要文字色
AppTheme.textHint            // 提示文字色
```

### 🧩 通用组件 (AppButton)

提供常用的 UI 组件，保持设计一致性。

#### AppButton 使用

```dart
import 'package:flutter_rapid_framework/common/widgets/app_button.dart';

// 主要按钮
AppButton.primary(
  text: '登录',
  onPressed: () => _handleLogin(),
)

// 次要按钮
AppButton.secondary(
  text: '取消',
  onPressed: () => Navigator.pop(context),
)

// 禁用按钮
AppButton.primary(
  text: '提交',
  onPressed: null, // 传入 null 即为禁用状态
)

// 加载状态按钮
AppButton.primary(
  text: '登录中...',
  loading: true,
  onPressed: () {}, // 加载时点击无效
)
```

## 状态管理

### Riverpod Provider

项目使用 Riverpod 进行状态管理。

#### ViewModel 模式

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 定义状态类
class LoginState {
  final bool isLoading;
  final String? error;
  
  const LoginState({
    this.isLoading = false,
    this.error,
  });
  
  LoginState copyWith({bool? isLoading, String? error}) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// 定义 ViewModel
class LoginViewModel extends StateNotifier<LoginState> {
  LoginViewModel() : super(const LoginState());
  
  Future<void> login(String username, String password) async {
    // 业务逻辑
  }
}

// 创建 Provider
final loginViewModelProvider = StateNotifierProvider<LoginViewModel, LoginState>((ref) {
  return LoginViewModel();
});
```

#### 在 Widget 中使用

```dart
class LoginPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginViewModelProvider);
    final loginViewModel = ref.read(loginViewModelProvider.notifier);
    
    return Scaffold(
      body: Column(
        children: [
          if (loginState.isLoading)
            const CircularProgressIndicator(),
          
          ElevatedButton(
            onPressed: () => loginViewModel.login(username, password),
            child: Text('登录'),
          ),
        ],
      ),
    );
  }
}
```

## 工具类

### 响应式设计

项目集成了 `flutter_screenutil` 用于响应式设计：

```dart
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 宽度适配
Container(width: 100.w)

// 高度适配
Container(height: 100.h)

// 字体大小适配
Text('Hello', style: TextStyle(fontSize: 16.sp))

// 边距适配
EdgeInsets.all(16.w)
EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h)

// 圆角适配
BorderRadius.circular(8.r)
```

### Toast 提示

```dart
import 'package:fluttertoast/fluttertoast.dart';

// 显示 Toast
Fluttertoast.showToast(
  msg: "这是一个提示消息",
  toastLength: Toast.LENGTH_SHORT,
  gravity: ToastGravity.BOTTOM,
);
```

## 错误处理

### 网络错误处理

网络请求的错误会通过拦截器统一处理：

```dart
try {
  final response = await NetworkManager.get('/api/data');
  // 处理成功响应
} on DioException catch (e) {
  // DioException 会被自动捕获并处理
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
      // 连接超时
      break;
    case DioExceptionType.receiveTimeout:
      // 接收超时
      break;
    case DioExceptionType.badResponse:
      // 服务器响应错误
      break;
    default:
      // 其他错误
  }
} catch (e) {
  // 其他异常
}
```

### 全局错误处理

在 `bootstrap.dart` 中设置了全局错误处理：

```dart
FlutterError.onError = (FlutterErrorDetails details) {
  AppLogger.error('Flutter Error', error: details.exception, stackTrace: details.stack);
};

PlatformDispatcher.instance.onError = (error, stack) {
  AppLogger.error('Platform Error', error: error, stackTrace: stack);
  return true;
};
```

## 国际化

### 多语言支持

项目支持多语言，配置在 `lib/l10n/app_localizations.dart`：

```dart
// 在 Widget 中使用
Text(AppLocalizations.of(context)!.login)

// 支持的语言
const supportedLocales = [
  Locale('zh', 'CN'), // 中文
  Locale('en', 'US'), // 英文
];
```

## 最佳实践

### 1. 项目结构

- `lib/core/` - 核心功能模块
- `lib/common/` - 通用组件和工具
- `lib/features/` - 业务功能模块
- `lib/l10n/` - 国际化资源

### 2. 命名规范

- 文件名：使用小写字母和下划线 `user_profile.dart`
- 类名：使用大驼峰命名 `UserProfile`
- 变量名：使用小驼峰命名 `userName`
- 常量名：使用大写字母和下划线 `API_BASE_URL`

### 3. 代码组织

- 每个页面包含 `view/` 和 `view_model/` 文件夹
- ViewModel 负责业务逻辑，View 负责 UI 展示
- 公共组件放在 `common/widgets/` 目录下

### 4. 状态管理

- 使用 Riverpod 进行状态管理
- 遵循单向数据流原则
- 将业务逻辑抽取到 ViewModel 中

### 5. 网络请求

- 统一使用 NetworkManager 进行网络请求
- 在 ViewModel 中处理网络请求和错误
- 使用适当的加载状态指示器

这就是 Flutter Rapid Framework 的完整 API 文档。通过这些接口，您可以快速构建功能完整的 Flutter 应用。