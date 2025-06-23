import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/user.dart';

class StorageService extends GetxService {
  final _box = GetStorage();

  // Keys
  static const String _authTokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  static const String _rememberMeKey = 'remember_me';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _selectedCategoryKey = 'selected_category';
  static const String _searchHistoryKey = 'search_history';

  // Initialize storage
  Future<StorageService> init() async {
    await GetStorage.init();
    return this;
  }

  // Auth token methods
  Future<void> saveAuthToken(String token) async {
    await _box.write(_authTokenKey, token);
  }

  Future<void> removeAuthToken() async {
    await _box.remove(_authTokenKey);
  }

  String? getAuthToken() {
    return _box.read(_authTokenKey);
  }

  // User methods
  Future<void> saveUser(Map<String, dynamic> userData) async {
    await _box.write(_userKey, jsonEncode(userData));
  }

  Future<void> removeUser() async {
    await _box.remove(_userKey);
  }

  Map<String, dynamic>? getUser() {
    final userData = _box.read(_userKey);
    if (userData != null) {
      try {
        return jsonDecode(userData);
      } catch (e) {
        print('Error decoding user data: $e');
        return null;
      }
    }
    return null;
  }

  // Remember me methods
  Future<void> saveRememberMe(bool value) async {
    await _box.write(_rememberMeKey, value);
  }

  bool getRememberMe() {
    return _box.read(_rememberMeKey) ?? false;
  }

  // Refresh token methods
  Future<void> saveRefreshToken(String token) async {
    await _box.write(_refreshTokenKey, token);
  }

  String? getRefreshToken() {
    return _box.read(_refreshTokenKey);
  }

  // Category preference
  Future<void> saveSelectedCategory(String category) async {
    await _box.write(_selectedCategoryKey, category);
  }

  String getSelectedCategory() {
    return _box.read(_selectedCategoryKey) ?? 'All';
  }

  // Search history
  Future<void> addToSearchHistory(String query) async {
    final history = getSearchHistory();
    if (!history.contains(query)) {
      history.insert(0, query);
      if (history.length > 10) {
        history.removeLast();
      }
      await _box.write(_searchHistoryKey, json.encode(history));
    }
  }

  List<String> getSearchHistory() {
    final historyData = _box.read(_searchHistoryKey);
    if (historyData != null) {
      try {
        final List<dynamic> decoded = json.decode(historyData);
        return decoded.cast<String>();
      } catch (e) {
        print('Error decoding search history: $e');
        return [];
      }
    }
    return [];
  }

  Future<void> clearSearchHistory() async {
    await _box.remove(_searchHistoryKey);
  }

  // Check if user is logged in
  bool get isLoggedIn {
    final token = getAuthToken();
    final user = getUser();
    final loggedIn = token != null && token.isNotEmpty && user != null;
    
    return loggedIn;
  }

  // Clear all data
  Future<void> clearAll() async {
    await _box.erase();
  }

  // App preferences
  Future<void> saveAppPreferences(Map<String, dynamic> preferences) async {
    for (final entry in preferences.entries) {
      await _box.write('pref_${entry.key}', entry.value);
    }
  }

  T? getAppPreference<T>(String key, {T? defaultValue}) {
    return _box.read('pref_$key') ?? defaultValue;
  }

  // Clear user data
  Future<void> clearUser() async {
    await _box.remove(_userKey);
    await _box.remove(_authTokenKey);
    await _box.remove(_refreshTokenKey);
  }

  // Preference methods
  Future<void> savePreference(String key, dynamic value) async {
    await _box.write('pref_$key', value);
  }

  T? getPreference<T>(String key, T defaultValue) {
    return _box.read('pref_$key') ?? defaultValue;
  }
} 