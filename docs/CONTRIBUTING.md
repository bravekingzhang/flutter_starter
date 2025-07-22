# 贡献指南

感谢您对 Flutter Rapid Framework 的关注！我们欢迎任何形式的贡献，包括但不限于错误报告、功能建议、代码贡献和文档改进。

## 🤝 如何贡献

### 1. 环境准备

在开始贡献之前，请确保您的开发环境满足以下要求：

**Flutter 环境**
- Flutter SDK >= 3.10.0
- Dart SDK >= 3.0.0

**开发工具**
- VS Code 或 Android Studio
- Git

**环境检查**
```bash
flutter doctor
```

### 2. 获取项目

```bash
# Fork 项目到您的 GitHub 账户
# 克隆您 Fork 的项目
git clone https://github.com/your-username/flutter_rapid_framework.git

# 进入项目目录
cd flutter_rapid_framework

# 安装依赖
flutter pub get

# 运行项目
flutter run
```

### 3. 分支策略

我们使用 Git Flow 分支模型：

- `main` - 主分支，包含稳定的发布版本
- `develop` - 开发分支，包含最新的开发功能
- `feature/*` - 功能分支，用于开发新功能
- `bugfix/*` - 修复分支，用于修复 bug
- `hotfix/*` - 热修复分支，用于紧急修复

**创建功能分支**
```bash
# 从 develop 分支创建功能分支
git checkout develop
git pull origin develop
git checkout -b feature/your-feature-name
```

**创建修复分支**
```bash
# 从 develop 分支创建修复分支
git checkout develop
git pull origin develop
git checkout -b bugfix/issue-description
```

## 📝 代码规范

### 1. 代码格式化

使用官方的 Dart 格式化工具：

```bash
# 格式化所有代码
dart format .

# 格式化特定文件
dart format lib/main.dart
```

### 2. 代码分析

在提交代码前，请运行静态分析：

```bash
# 运行代码分析
flutter analyze

# 检查是否有格式问题
dart format --set-exit-if-changed .
```

### 3. 命名规范

**文件和目录命名**
- 使用小写字母和下划线：`user_profile.dart`
- 目录名使用单数形式：`widget` 而不是 `widgets`

**类命名**
- 使用大驼峰命名：`UserProfilePage`
- Widget 类以 Page、View、Dialog 等后缀结尾
- ViewModel 类以 ViewModel 结尾
- Service 类以 Service 或 Manager 结尾

**变量和方法命名**
- 使用小驼峰命名：`userName`、`getUserInfo()`
- 私有成员以下划线开头：`_privateMethod()`
- 常量使用大写字母和下划线：`API_BASE_URL`

**Provider 命名**
- Provider 变量以 Provider 结尾：`userProfileProvider`

### 4. 文档注释

为公共 API 提供详细的文档注释：

```dart
/// 用户个人资料页面
/// 
/// 显示用户的基本信息，包括头像、姓名、邮箱等。
/// 用户可以在此页面编辑个人信息。
class UserProfilePage extends ConsumerStatefulWidget {
  /// 创建用户个人资料页面
  /// 
  /// [userId] 用户ID，如果为 null 则显示当前登录用户的信息
  const UserProfilePage({
    super.key,
    this.userId,
  });

  /// 用户ID
  final String? userId;

  @override
  ConsumerState<UserProfilePage> createState() => _UserProfilePageState();
}

/// 获取用户信息
/// 
/// [userId] 用户ID
/// 
/// 返回 [UserInfo] 对象，如果用户不存在则抛出 [UserNotFoundException]
/// 
/// 示例：
/// ```dart
/// try {
///   final userInfo = await getUserInfo('123');
///   print('用户名: ${userInfo.name}');
/// } catch (e) {
///   print('获取用户信息失败: $e');
/// }
/// ```
Future<UserInfo> getUserInfo(String userId) async {
  // 实现
}
```

### 5. 项目结构规范

遵循以下项目结构：

```
lib/
├── app.dart                    # 应用根组件
├── main.dart                   # 应用入口
├── bootstrap.dart              # 启动配置
│
├── core/                       # 核心模块
│   ├── config/                 # 配置管理
│   ├── network/                # 网络请求
│   ├── storage/                # 本地存储
│   ├── router/                 # 路由管理
│   └── log/                    # 日志系统
│
├── common/                     # 通用模块
│   ├── widgets/                # 通用组件
│   ├── utils/                  # 工具类
│   └── themes/                 # 主题配置
│
├── features/                   # 业务模块
│   ├── auth/                   # 认证模块
│   │   ├── data/              # 数据层
│   │   ├── domain/            # 业务层
│   │   └── presentation/      # 表现层
│   │       ├── pages/         # 页面
│   │       ├── widgets/       # 组件
│   │       └── providers/     # 状态管理
│   └── profile/               # 个人资料模块
│       └── ...
│
└── l10n/                      # 国际化
```

## 🧪 测试要求

### 1. 单元测试

为核心逻辑编写单元测试：

```dart
// test/features/auth/login_view_model_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_rapid_framework/features/auth/login_view_model.dart';

void main() {
  group('LoginViewModel', () {
    test('初始状态应该是未加载状态', () {
      final viewModel = LoginViewModel();
      expect(viewModel.state.isLoading, false);
      expect(viewModel.state.error, null);
    });

    test('登录成功应该更新状态', () async {
      final viewModel = LoginViewModel();
      await viewModel.login('admin', '123456');
      
      expect(viewModel.state.isLoading, false);
      expect(viewModel.state.error, null);
    });
  });
}
```

### 2. Widget 测试

为 UI 组件编写 Widget 测试：

```dart
// test/common/widgets/app_button_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_rapid_framework/common/widgets/app_button.dart';

void main() {
  group('AppButton', () {
    testWidgets('应该显示正确的文本', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton.primary(
              text: '测试按钮',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('测试按钮'), findsOneWidget);
    });
  });
}
```

### 3. 运行测试

```bash
# 运行所有测试
flutter test

# 运行特定测试文件
flutter test test/features/auth/login_view_model_test.dart

# 生成测试覆盖率报告
flutter test --coverage
```

### 4. 测试覆盖率

我们要求：
- 核心业务逻辑测试覆盖率 >= 80%
- 通用组件测试覆盖率 >= 70%
- 工具类测试覆盖率 >= 90%

## 📋 提交规范

### 1. 提交消息格式

使用 [Conventional Commits](https://www.conventionalcommits.org/) 规范：

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

**Type 类型**
- `feat`: 新功能
- `fix`: 修复 bug
- `docs`: 文档更新
- `style`: 代码格式修改
- `refactor`: 代码重构
- `test`: 测试相关
- `chore`: 构建过程或辅助工具的变动

**示例**
```bash
feat(auth): 添加登录功能

实现了用户登录功能，包括：
- 登录表单验证
- 网络请求处理
- 错误状态管理

Closes #123
```

### 2. 提交流程

```bash
# 1. 添加修改的文件
git add .

# 2. 提交代码
git commit -m "feat(auth): 添加登录功能"

# 3. 推送到远程分支
git push origin feature/login-functionality

# 4. 创建 Pull Request
```

## 🔄 Pull Request 流程

### 1. 创建 Pull Request

1. 在 GitHub 上创建 Pull Request
2. 选择正确的目标分支（通常是 `develop`）
3. 填写 PR 模板中的信息
4. 添加相关的标签和审查者

### 2. PR 模板

```markdown
## 变更描述
简要描述这个 PR 的变更内容

## 变更类型
- [ ] 新功能
- [ ] Bug 修复
- [ ] 文档更新
- [ ] 重构
- [ ] 性能优化
- [ ] 其他

## 测试
- [ ] 已添加单元测试
- [ ] 已添加 Widget 测试
- [ ] 已运行现有测试套件
- [ ] 已手动测试

## 检查清单
- [ ] 代码遵循项目的代码规范
- [ ] 已运行 `flutter analyze` 无警告
- [ ] 已运行 `dart format` 格式化代码
- [ ] 已更新相关文档
- [ ] 已添加或更新测试用例

## 相关 Issue
Closes #(issue number)

## 截图
如果是 UI 相关的变更，请提供截图

## 补充说明
其他需要说明的内容
```

### 3. 代码审查

所有 PR 都需要经过代码审查：

1. 至少需要一名维护者的审查
2. 所有 CI 检查必须通过
3. 解决所有审查意见
4. 保持提交历史整洁

## 🐛 Bug 报告

使用 GitHub Issues 报告 bug，请包含以下信息：

### Bug 报告模板

```markdown
## Bug 描述
简要描述发现的问题

## 复现步骤
1. 打开应用
2. 点击登录
3. 输入错误密码
4. 点击提交

## 期望行为
应该显示错误提示信息

## 实际行为
应用崩溃

## 环境信息
- Flutter 版本: 3.10.0
- Dart 版本: 3.0.0
- 设备: iPhone 14 (iOS 16.0)
- 框架版本: 1.0.0

## 附加信息
- 错误日志
- 截图
- 其他相关信息
```

## 💡 功能建议

使用 GitHub Issues 提交功能建议：

### 功能建议模板

```markdown
## 功能描述
简要描述建议的功能

## 解决的问题
这个功能解决了什么问题或改进了什么体验

## 详细描述
详细描述功能的实现方式和用户交互

## 替代方案
是否考虑过其他替代方案

## 附加信息
- 相关截图或原型
- 参考链接
- 其他说明
```

## 📚 文档贡献

### 1. 文档类型

- API 文档：`docs/API.md`
- 用户指南：`docs/USER_GUIDE.md`
- 开发指南：`docs/DEVELOPMENT.md`
- 更新日志：`CHANGELOG.md`

### 2. 文档编写规范

- 使用 Markdown 格式
- 包含代码示例
- 提供清晰的截图
- 保持文档与代码同步更新

## 🎉 感谢贡献者

我们感谢所有为项目做出贡献的开发者！您的贡献将会被记录在项目的贡献者列表中。

### 成为维护者

对于长期贡献且表现优秀的开发者，我们会邀请成为项目维护者，获得：

- 项目写权限
- 参与重要决策
- 指导新贡献者

## 📞 联系我们

如果您在贡献过程中遇到任何问题，请通过以下方式联系我们：

- GitHub Issues: 技术问题和建议
- GitHub Discussions: 一般讨论和交流
- Email: [项目邮箱]

## 📄 许可证

通过贡献代码，您同意您的贡献将在与项目相同的 [MIT License](LICENSE) 下发布。

---

再次感谢您的贡献！让我们一起构建更好的 Flutter 开发框架。