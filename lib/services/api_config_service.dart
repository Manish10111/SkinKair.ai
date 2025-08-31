import 'package:shared_preferences/shared_preferences.dart';

class ApiConfigService {
  static final ApiConfigService _instance = ApiConfigService._internal();

  factory ApiConfigService() {
    return _instance;
  }

  ApiConfigService._internal();

  // Gemini API Key (using environment variable)
  static const String geminiApiKey = String.fromEnvironment('GEMINI_API_KEY');

  // Murf.ai API configuration
  String? _murfApiKey;
  String? _murfApiUrl;

  // Assembly.ai API configuration
  String? _assemblyApiKey;
  String? _assemblyApiUrl;

  // Getters
  String get geminiKey => geminiApiKey;
  String? get murfApiKey => _murfApiKey;
  String? get murfApiUrl => _murfApiUrl ?? 'https://api.murf.ai/v1';
  String? get assemblyApiKey => _assemblyApiKey;
  String? get assemblyApiUrl =>
      _assemblyApiUrl ?? 'https://api.assemblyai.com/v2';

  // Initialize API configurations from storage
  Future<void> initializeApiConfigs() async {
    final prefs = await SharedPreferences.getInstance();

    _murfApiKey = prefs.getString('murf_api_key');
    _murfApiUrl = prefs.getString('murf_api_url');
    _assemblyApiKey = prefs.getString('assembly_api_key');
    _assemblyApiUrl = prefs.getString('assembly_api_url');
  }

  // Murf.ai API configuration methods
  Future<void> setMurfApiKey(String apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('murf_api_key', apiKey);
    _murfApiKey = apiKey;
  }

  Future<void> setMurfApiUrl(String apiUrl) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('murf_api_url', apiUrl);
    _murfApiUrl = apiUrl;
  }

  Future<void> clearMurfConfig() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('murf_api_key');
    await prefs.remove('murf_api_url');
    _murfApiKey = null;
    _murfApiUrl = null;
  }

  // Assembly.ai API configuration methods
  Future<void> setAssemblyApiKey(String apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('assembly_api_key', apiKey);
    _assemblyApiKey = apiKey;
  }

  Future<void> setAssemblyApiUrl(String apiUrl) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('assembly_api_url', apiUrl);
    _assemblyApiUrl = apiUrl;
  }

  Future<void> clearAssemblyConfig() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('assembly_api_key');
    await prefs.remove('assembly_api_url');
    _assemblyApiKey = null;
    _assemblyApiUrl = null;
  }

  // Validation methods
  bool get isGeminiConfigured => geminiApiKey.isNotEmpty;
  bool get isMurfConfigured => _murfApiKey?.isNotEmpty == true;
  bool get isAssemblyConfigured => _assemblyApiKey?.isNotEmpty == true;

  // Get configuration status
  Map<String, bool> getConfigurationStatus() {
    return {
      'gemini': isGeminiConfigured,
      'murf': isMurfConfigured,
      'assembly': isAssemblyConfigured,
    };
  }

  // Get all API endpoints for debugging
  Map<String, String?> getAllApiEndpoints() {
    return {
      'gemini': 'https://generativelanguage.googleapis.com/v1',
      'murf': murfApiUrl,
      'assembly': assemblyApiUrl,
    };
  }
}
