import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 帮助中心页面
@RoutePage()
class HelpPage extends ConsumerStatefulWidget {
  const HelpPage({super.key});

  @override
  ConsumerState<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends ConsumerState<HelpPage> {
  final List<HelpCategory> _categories = [
    HelpCategory(
      title: '常见问题',
      icon: Icons.help_outline,
      items: [
        HelpItem(
          question: '如何修改个人信息？',
          answer: '进入个人中心页面，点击"编辑资料"即可修改您的个人信息。',
        ),
        HelpItem(
          question: '如何修改密码？',
          answer: '您可以在"设置"或"个人中心"页面找到"修改密码"选项，按照提示操作即可。',
        ),
        HelpItem(
          question: '忘记密码怎么办？',
          answer: '在登录页面点击"忘记密码"，通过绑定的邮箱或手机号找回密码。',
        ),
        HelpItem(
          question: '如何设置消息通知？',
          answer: '进入"设置"页面，找到"消息推送"选项，可以自定义您的通知偏好。',
        ),
      ],
    ),
    HelpCategory(
      title: '账户安全',
      icon: Icons.security,
      items: [
        HelpItem(
          question: '如何保护账户安全？',
          answer: '建议您：\n1. 设置复杂密码\n2. 定期修改密码\n3. 不要在公共设备上保存密码\n4. 及时查看登录记录',
        ),
        HelpItem(
          question: '发现异常登录怎么办？',
          answer: '如果发现账户异常登录，请立即修改密码，并联系客服进行账户安全检查。',
        ),
      ],
    ),
    HelpCategory(
      title: '功能说明',
      icon: Icons.lightbulb_outline,
      items: [
        HelpItem(
          question: '框架主要功能有哪些？',
          answer: 'Flutter Rapid Framework 提供了：\n1. 完整的用户认证流程\n2. 统一的网络请求处理\n3. 本地数据持久化\n4. 类型安全的路由管理\n5. 响应式设计适配',
        ),
        HelpItem(
          question: '如何使用路由导航？',
          answer: '本框架使用 AutoRoute 进行路由管理，提供类型安全的导航方式。详情请查看开发文档。',
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('帮助中心'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('搜索功能开发中')),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _categories.length + 1,
        itemBuilder: (context, index) {
          if (index == _categories.length) {
            return _buildContactSection();
          }
          return _buildCategorySection(_categories[index]);
        },
      ),
    );
  }

  /// 构建分类区域
  Widget _buildCategorySection(HelpCategory category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 8.h),
          child: Row(
            children: [
              Icon(
                category.icon,
                color: Theme.of(context).colorScheme.primary,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                category.title,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Card(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: category.items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Column(
                children: [
                  _buildHelpItem(item),
                  if (index < category.items.length - 1)
                    Divider(height: 1.h, indent: 16.w),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  /// 构建帮助项
  Widget _buildHelpItem(HelpItem item) {
    return ExpansionTile(
      tilePadding: EdgeInsets.symmetric(horizontal: 16.w),
      childrenPadding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
      title: Text(
        item.question,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            item.answer,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  /// 构建联系我们区域
  Widget _buildContactSection() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24.h),
          Text(
            '联系我们',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          Card(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  _buildContactItem(
                    Icons.email_outlined,
                    '邮箱',
                    'support@example.com',
                  ),
                  Divider(height: 24.h),
                  _buildContactItem(
                    Icons.phone_outlined,
                    '客服电话',
                    '400-123-4567',
                  ),
                  Divider(height: 24.h),
                  _buildContactItem(
                    Icons.schedule_outlined,
                    '服务时间',
                    '周一至周五 9:00-18:00',
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24.h),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('反馈功能开发中')),
                );
              },
              icon: const Icon(Icons.feedback_outlined),
              label: const Text('意见反馈'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
              ),
            ),
          ),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }

  /// 构建联系项
  Widget _buildContactItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 24.sp,
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 帮助分类
class HelpCategory {
  final String title;
  final IconData icon;
  final List<HelpItem> items;

  HelpCategory({
    required this.title,
    required this.icon,
    required this.items,
  });
}

/// 帮助项
class HelpItem {
  final String question;
  final String answer;

  HelpItem({
    required this.question,
    required this.answer,
  });
}
