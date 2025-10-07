import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 消息通知页面
@RoutePage()
class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  // 模拟消息数据
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      title: '系统通知',
      content: '欢迎使用 Flutter Rapid Framework！',
      time: DateTime.now().subtract(const Duration(hours: 1)),
      isRead: false,
      type: NotificationType.system,
    ),
    NotificationItem(
      id: '2',
      title: '功能更新',
      content: '新增了个人中心和设置页面，快来体验吧！',
      time: DateTime.now().subtract(const Duration(hours: 3)),
      isRead: false,
      type: NotificationType.update,
    ),
    NotificationItem(
      id: '3',
      title: '安全提醒',
      content: '您的账户已登录，如非本人操作请及时修改密码',
      time: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      type: NotificationType.security,
    ),
    NotificationItem(
      id: '4',
      title: '系统维护',
      content: '系统将于今晚 23:00 进行维护，预计持续 2 小时',
      time: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
      type: NotificationType.system,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      appBar: AppBar(
        title: Text('消息通知 ${unreadCount > 0 ? '($unreadCount)' : ''}'),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text('全部已读'),
            ),
        ],
      ),
      body: _notifications.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              itemCount: _notifications.length,
              separatorBuilder: (context, index) => Divider(height: 1.h),
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return _buildNotificationItem(notification);
              },
            ),
    );
  }

  /// 构建空状态
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 64.sp,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            '暂无消息',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建消息项
  Widget _buildNotificationItem(NotificationItem notification) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 16.w),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        setState(() {
          _notifications.remove(notification);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('消息已删除')),
        );
      },
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        leading: CircleAvatar(
          backgroundColor: notification.isRead
              ? Colors.grey[300]
              : _getTypeColor(notification.type),
          child: Icon(
            _getTypeIcon(notification.type),
            color: notification.isRead ? Colors.grey[600] : Colors.white,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                notification.title,
                style: TextStyle(
                  fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                ),
              ),
            ),
            if (!notification.isRead)
              Container(
                width: 8.w,
                height: 8.h,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.h),
            Text(
              notification.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: notification.isRead ? Colors.grey[600] : Colors.grey[800],
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              _formatTime(notification.time),
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
        onTap: () {
          if (!notification.isRead) {
            setState(() {
              notification.isRead = true;
            });
          }
          _showNotificationDetail(notification);
        },
      ),
    );
  }

  /// 获取消息类型图标
  IconData _getTypeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.system:
        return Icons.notifications;
      case NotificationType.update:
        return Icons.system_update;
      case NotificationType.security:
        return Icons.security;
      case NotificationType.message:
        return Icons.message;
    }
  }

  /// 获取消息类型颜色
  Color _getTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.system:
        return Colors.blue;
      case NotificationType.update:
        return Colors.green;
      case NotificationType.security:
        return Colors.orange;
      case NotificationType.message:
        return Colors.purple;
    }
  }

  /// 格式化时间
  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}小时前';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else {
      return '${time.month}月${time.day}日';
    }
  }

  /// 全部标记为已读
  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification.isRead = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('已全部标记为已读')),
    );
  }

  /// 显示消息详情
  void _showNotificationDetail(NotificationItem notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(notification.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(notification.content),
              SizedBox(height: 16.h),
              Text(
                _formatTime(notification.time),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }
}

/// 消息类型
enum NotificationType {
  system,    // 系统通知
  update,    // 更新通知
  security,  // 安全提醒
  message,   // 消息
}

/// 消息项模型
class NotificationItem {
  final String id;
  final String title;
  final String content;
  final DateTime time;
  bool isRead;
  final NotificationType type;

  NotificationItem({
    required this.id,
    required this.title,
    required this.content,
    required this.time,
    required this.isRead,
    required this.type,
  });
}
