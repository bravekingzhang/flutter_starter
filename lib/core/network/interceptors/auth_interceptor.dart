import 'package:dio/dio.dart';

import '../../storage/storage_manager.dart';
import '../../log/app_logger.dart';

/// 认证拦截器
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // 获取存储的 token
    final token = await StorageManager.getToken();
    
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
      AppLogger.debug('添加认证头: Bearer ${token.substring(0, 10)}...');
    }
    
    super.onRequest(options, handler);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 处理 401 未授权错误
    if (err.response?.statusCode == 401) {
      AppLogger.warning('收到 401 未授权响应，清除本地 token');
      await StorageManager.clearToken();
      // 这里可以添加跳转到登录页的逻辑
    }
    
    super.onError(err, handler);
  }
}