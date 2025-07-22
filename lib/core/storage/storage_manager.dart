import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../log/app_logger.dart';

/// 本地存储管理器
class StorageManager {
  static late SharedPreferences _prefs;
  static late Box _box;
  
  // 存储键名常量
  static const String _keyToken = 'user_token';
  static const String _keyUserInfo = 'user_info';
  static const String _keySettings = 'app_settings';
  
  /// 初始化存储管理器
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _box = await Hive.openBox('app_storage');
    AppLogger.info('存储管理器初始化完成');
  }
  
  // ========== Token 相关 ==========
  
  /// 保存用户 Token
  static Future<void> saveToken(String token) async {
    await _prefs.setString(_keyToken, token);
    AppLogger.debug('Token 已保存');
  }
  
  /// 获取用户 Token
  static Future<String?> getToken() async {
    return _prefs.getString(_keyToken);
  }
  
  /// 清除用户 Token
  static Future<void> clearToken() async {
    await _prefs.remove(_keyToken);
    AppLogger.debug('Token 已清除');
  }
  
  /// 检查是否已登录
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
  
  // ========== 用户信息相关 ==========
  
  /// 保存用户信息
  static Future<void> saveUserInfo(Map<String, dynamic> userInfo) async {
    await _box.put(_keyUserInfo, userInfo);
    AppLogger.debug('用户信息已保存');
  }
  
  /// 获取用户信息
  static Map<String, dynamic>? getUserInfo() {
    final data = _box.get(_keyUserInfo);
    if (data == null) return null;
    return Map<String, dynamic>.from(data);
  }
  
  /// 清除用户信息
  static Future<void> clearUserInfo() async {
    await _box.delete(_keyUserInfo);
    AppLogger.debug('用户信息已清除');
  }
  
  // ========== 应用设置相关 ==========
  
  /// 保存应用设置
  static Future<void> saveSettings(Map<String, dynamic> settings) async {
    await _box.put(_keySettings, settings);
    AppLogger.debug('应用设置已保存');
  }
  
  /// 获取应用设置
  static Map<String, dynamic>? getSettings() {
    final data = _box.get(_keySettings);
    if (data == null) return null;
    return Map<String, dynamic>.from(data);
  }
  
  /// 清除应用设置
  static Future<void> clearSettings() async {
    await _box.delete(_keySettings);
    AppLogger.debug('应用设置已清除');
  }
  
  // ========== 通用方法 ==========
  
  /// 保存字符串
  static Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }
  
  /// 获取字符串
  static String? getString(String key) {
    return _prefs.getString(key);
  }
  
  /// 保存整数
  static Future<void> setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }
  
  /// 获取整数
  static int? getInt(String key) {
    return _prefs.getInt(key);
  }
  
  /// 保存布尔值
  static Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }
  
  /// 获取布尔值
  static bool? getBool(String key) {
    return _prefs.getBool(key);
  }
  
  /// 保存对象到 Hive
  static Future<void> setObject(String key, dynamic value) async {
    await _box.put(key, value);
  }
  
  /// 从 Hive 获取对象
  static T? getObject<T>(String key) {
    return _box.get(key);
  }
  
  /// 删除键值
  static Future<void> remove(String key) async {
    await _prefs.remove(key);
    await _box.delete(key);
  }
  
  /// 清除所有数据
  static Future<void> clearAll() async {
    await _prefs.clear();
    await _box.clear();
    AppLogger.info('所有存储数据已清除');
  }
}