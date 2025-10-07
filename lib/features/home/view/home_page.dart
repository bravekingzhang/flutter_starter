import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/router/app_router.dart';
import '../../../core/storage/storage_manager.dart';

/// 主页
@RoutePage()
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
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
        title: const Text('首页'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _showLogoutDialog,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 用户信息卡片
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30.r,
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          child: Icon(
                            Icons.person,
                            size: 30.sp,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userInfo?['nickname'] ?? '未知用户',
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                userInfo?['email'] ?? '',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      '登录时间: ${_formatLoginTime()}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 24.h),
            
            // 功能模块
            Text(
              '功能模块',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            
            SizedBox(height: 16.h),
            
            // 功能网格
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
                childAspectRatio: 1.2,
                children: [
                  _buildFeatureCard(
                    icon: Icons.person_outline,
                    title: '个人中心',
                    subtitle: '查看个人信息',
                    onTap: () {
                      context.router.push(const ProfileRoute());
                    },
                  ),
                  _buildFeatureCard(
                    icon: Icons.settings_outlined,
                    title: '系统设置',
                    subtitle: '应用设置管理',
                    onTap: () {
                      context.router.push(const SettingsRoute());
                    },
                  ),
                  _buildFeatureCard(
                    icon: Icons.notifications_outlined,
                    title: '消息通知',
                    subtitle: '查看系统消息',
                    onTap: () {
                      context.router.push(const NotificationsRoute());
                    },
                  ),
                  _buildFeatureCard(
                    icon: Icons.help_outline,
                    title: '帮助中心',
                    subtitle: '使用帮助文档',
                    onTap: () {
                      context.router.push(const HelpRoute());
                    },
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24.h),
            
            // 框架信息
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Flutter Rapid Framework',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '🎯 高内聚，低耦合的模块化架构\n'
                      '⚡ 配置即约定，快速开发\n'
                      '🔧 插件化设计，易于扩展\n'
                      '🚀 专注业务，屏蔽底层实现',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// 构建功能卡片
  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32.sp,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(height: 12.h),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4.h),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// 格式化登录时间
  String _formatLoginTime() {
    final loginTimeStr = userInfo?['loginTime'];
    if (loginTimeStr == null) return '未知';
    
    try {
      final loginTime = DateTime.parse(loginTimeStr);
      final now = DateTime.now();
      final difference = now.difference(loginTime);
      
      if (difference.inMinutes < 1) {
        return '刚刚';
      } else if (difference.inHours < 1) {
        return '${difference.inMinutes}分钟前';
      } else if (difference.inDays < 1) {
        return '${difference.inHours}小时前';
      } else {
        return '${loginTime.month}月${loginTime.day}日 ${loginTime.hour.toString().padLeft(2, '0')}:${loginTime.minute.toString().padLeft(2, '0')}';
      }
    } catch (e) {
      return '未知';
    }
  }
  
  /// 显示退出登录对话框
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('退出登录'),
        content: const Text('确定要退出登录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              // 清除用户数据
              await StorageManager.clearToken();
              await StorageManager.clearUserInfo();
              // 跳转到登录页
              if (mounted) {
                context.router.replace(const LoginRoute());
              }
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}