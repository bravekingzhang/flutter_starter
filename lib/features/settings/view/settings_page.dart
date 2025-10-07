import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 设置页面
@RoutePage()
class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  double _fontSize = 16.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('系统设置'),
      ),
      body: ListView(
        children: [
          // 通用设置
          _buildSectionHeader('通用设置'),
          _buildSwitchTile(
            icon: Icons.notifications_outlined,
            title: '消息推送',
            subtitle: '接收系统消息通知',
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          _buildSwitchTile(
            icon: Icons.dark_mode_outlined,
            title: '深色模式',
            subtitle: '开启暗黑主题',
            value: _darkModeEnabled,
            onChanged: (value) {
              setState(() {
                _darkModeEnabled = value;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('深色模式功能开发中')),
              );
            },
          ),

          Divider(height: 1.h),

          // 显示设置
          _buildSectionHeader('显示设置'),
          ListTile(
            leading: Icon(
              Icons.font_download_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text('字体大小'),
            subtitle: Slider(
              value: _fontSize,
              min: 12.0,
              max: 20.0,
              divisions: 8,
              label: _fontSize.round().toString(),
              onChanged: (value) {
                setState(() {
                  _fontSize = value;
                });
              },
            ),
          ),

          Divider(height: 1.h),

          // 账户与安全
          _buildSectionHeader('账户与安全'),
          _buildNavigationTile(
            icon: Icons.lock_outlined,
            title: '修改密码',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('修改密码功能开发中')),
              );
            },
          ),
          _buildNavigationTile(
            icon: Icons.privacy_tip_outlined,
            title: '隐私设置',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('隐私设置功能开发中')),
              );
            },
          ),

          Divider(height: 1.h),

          // 其他设置
          _buildSectionHeader('其他'),
          _buildNavigationTile(
            icon: Icons.language_outlined,
            title: '语言设置',
            subtitle: '简体中文',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('语言设置功能开发中')),
              );
            },
          ),
          _buildNavigationTile(
            icon: Icons.info_outlined,
            title: '关于应用',
            subtitle: '版本 1.0.0',
            onTap: () {
              _showAboutDialog();
            },
          ),
          _buildNavigationTile(
            icon: Icons.delete_outline,
            title: '清除缓存',
            subtitle: '0 MB',
            onTap: () {
              _showClearCacheDialog();
            },
          ),
        ],
      ),
    );
  }

  /// 构建分组标题
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 8.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  /// 构建开关选项
  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  /// 构建导航选项
  Widget _buildNavigationTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  /// 显示关于对话框
  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('关于应用'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Flutter Rapid Framework'),
            SizedBox(height: 8.h),
            const Text('版本: 1.0.0'),
            SizedBox(height: 8.h),
            const Text('一个专为提升开发效率而设计的 Flutter 快速开发框架'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  /// 显示清除缓存对话框
  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清除缓存'),
        content: const Text('确定要清除所有缓存吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('缓存已清除')),
              );
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}
