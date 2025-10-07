import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/storage/storage_manager.dart';

/// 个人中心页面
@RoutePage()
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  Map<String, dynamic>? userInfo;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  /// 加载用户信息
  void _loadUserInfo() {
    userInfo = StorageManager.getUserInfo();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('个人中心'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 用户头像和基本信息
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
                  ],
                ),
              ),
              child: Column(
                children: [
                  // 头像
                  CircleAvatar(
                    radius: 50.r,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 50.sp,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // 昵称
                  Text(
                    userInfo?['nickname'] ?? '未知用户',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8.h),

                  // 邮箱
                  Text(
                    userInfo?['email'] ?? '',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // 个人信息列表
            _buildInfoSection('基本信息', [
              _buildInfoItem(Icons.person_outline, '用户名', userInfo?['username'] ?? ''),
              _buildInfoItem(Icons.badge_outlined, 'ID', userInfo?['id']?.toString() ?? ''),
              _buildInfoItem(Icons.email_outlined, '邮箱', userInfo?['email'] ?? ''),
            ]),

            SizedBox(height: 16.h),

            // 操作选项
            _buildInfoSection('账户管理', [
              _buildActionItem(Icons.edit_outlined, '编辑资料', () {
                // TODO: 跳转到编辑资料页面
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('编辑资料功能开发中')),
                );
              }),
              _buildActionItem(Icons.lock_outline, '修改密码', () {
                // TODO: 跳转到修改密码页面
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('修改密码功能开发中')),
                );
              }),
              _buildActionItem(Icons.privacy_tip_outlined, '隐私设置', () {
                // TODO: 跳转到隐私设置页面
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('隐私设置功能开发中')),
                );
              }),
            ]),
          ],
        ),
      ),
    );
  }

  /// 构建信息分组
  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ),
        Card(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(children: children),
        ),
      ],
    );
  }

  /// 构建信息项
  Widget _buildInfoItem(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(label),
      trailing: Text(
        value,
        style: TextStyle(
          fontSize: 14.sp,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  /// 构建操作项
  Widget _buildActionItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
