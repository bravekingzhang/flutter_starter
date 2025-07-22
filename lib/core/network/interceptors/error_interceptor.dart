import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../log/app_logger.dart';

/// 错误处理拦截器
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String errorMessage = _getErrorMessage(err);
    
    AppLogger.error(
      '网络请求错误: ${err.requestOptions.path}',
      error: errorMessage,
      stackTrace: err.stackTrace,
    );
    
    // 显示错误提示
    _showErrorToast(errorMessage);
    
    super.onError(err, handler);
  }
  
  /// 获取错误信息
  String _getErrorMessage(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
        return '连接超时，请检查网络';
      case DioExceptionType.sendTimeout:
        return '发送超时，请检查网络';
      case DioExceptionType.receiveTimeout:
        return '接收超时，请检查网络';
      case DioExceptionType.badResponse:
        return _handleStatusCode(err.response?.statusCode);
      case DioExceptionType.cancel:
        return '请求已取消';
      case DioExceptionType.unknown:
        return '网络异常，请稍后重试';
      default:
        return '未知错误';
    }
  }
  
  /// 处理状态码错误
  String _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return '请求参数错误';
      case 401:
        return '未授权，请重新登录';
      case 403:
        return '禁止访问';
      case 404:
        return '请求的资源不存在';
      case 500:
        return '服务器内部错误';
      case 502:
        return '网关错误';
      case 503:
        return '服务不可用';
      case 504:
        return '网关超时';
      default:
        return '服务器错误($statusCode)';
    }
  }
  
  /// 显示错误提示
  void _showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
  }
}