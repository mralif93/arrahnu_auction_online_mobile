import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/foundation.dart';
import '../models/user.dart';

class StorageService extends GetxService {
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userKey = 'user_data';
  static const String _rememberMeKey = 'remember_me';
  static const String _selectedCategoryKey = 'selected_category';
  static const String _searchHistoryKey = 'search_history';

  // Initialize storage service
  static Future<StorageService> init() async {
    await GetStorage.init();
    final service = StorageService();
    return service;
  }

  // Token management
  Future<void> saveAuthToken(String token) async {
    await GetStorage().write(_tokenKey, token);
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    await GetStorage().write(_refreshTokenKey, refreshToken);
  }

  String? getAuthToken() {
    return GetStorage().read(_tokenKey);
  }

  String? getRefreshToken() {
    return GetStorage().read(_refreshTokenKey);
  }

  Future<void> clearAuthTokens() async {
    await GetStorage().remove(_tokenKey);
    await GetStorage().remove(_refreshTokenKey);
  }

  // User data management
  Future<void> saveUser(User user) async {
    await GetStorage().write(_userKey, json.encode(user.toJson()));
  }

  User? getUser() {
    final userData = GetStorage().read(_userKey);
    if (userData != null) {
      try {
        final userMap = json.decode(userData) as Map<String, dynamic>;
        return User.fromJson(userMap);
      } catch (e) {
        // Handle error silently
        return null;
      }
    }
    return null;
  }

  Future<void> clearUser() async {
    await GetStorage().remove(_userKey);
  }

  // Remember me preference
  Future<void> setRememberMe(bool rememberMe) async {
    await GetStorage().write(_rememberMeKey, rememberMe);
  }

  bool getRememberMe() {
    return GetStorage().read(_rememberMeKey) ?? false;
  }

  // Category preference
  Future<void> saveSelectedCategory(String category) async {
    await GetStorage().write(_selectedCategoryKey, category);
  }

  String getSelectedCategory() {
    return GetStorage().read(_selectedCategoryKey) ?? 'All';
  }

  // Search history
  Future<void> addSearchHistory(String searchTerm) async {
    if (searchTerm.trim().isEmpty) return;
    
    List<String> history = getSearchHistory();
    
    // Remove if already exists to avoid duplicates
    history.remove(searchTerm);
    
    // Add to beginning
    history.insert(0, searchTerm);
    
    // Keep only last 10 searches
    if (history.length > 10) {
      history = history.take(10).toList();
    }
    
    await GetStorage().write(_searchHistoryKey, json.encode(history));
  }

  List<String> getSearchHistory() {
    final historyData = GetStorage().read(_searchHistoryKey);
    if (historyData != null) {
      try {
        final List<dynamic> historyList = json.decode(historyData);
        return historyList.map((item) => item.toString()).toList();
      } catch (e) {
        // Handle error silently
        return [];
      }
    }
    return [];
  }

  Future<void> clearSearchHistory() async {
    await GetStorage().remove(_searchHistoryKey);
  }

  // Check if user is logged in
  bool get isLoggedIn {
    final token = getAuthToken();
    final user = getUser();
    final loggedIn = token != null && token.isNotEmpty && user != null;
    
    debugPrint('🔍 StorageService.isLoggedIn check:');
    debugPrint('  - Token: ${token != null ? "Present (${token.length} chars)" : "NULL"}');
    debugPrint('  - User: ${user != null ? "Present (${user.fullName})" : "NULL"}');
    debugPrint('  - Result: $loggedIn');
    
    return loggedIn;
  }

  // Clear all stored data (logout)
  Future<void> clearAll() async {
    await clearAuthTokens();
    await clearUser();
    // Keep preferences like remember me and search history
  }

  // App preferences
  Future<void> saveAppPreferences(Map<String, dynamic> preferences) async {
    for (final entry in preferences.entries) {
      await GetStorage().write('pref_${entry.key}', entry.value);
    }
  }

  T? getAppPreference<T>(String key, {T? defaultValue}) {
    return GetStorage().read('pref_$key') ?? defaultValue;
  }
} 